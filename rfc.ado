*python set userpath /usr/local/lib/python3.7/, permanently
*python set exec /usr/local/bin/python3.7m, permanently

 
cap program drop rfc
program define rfc
    version 16
    syntax varlist [if] [in], [PSample(varlist max=1) SAmpleweight(varlist max=1) NEstimators(integer 100) CRiterion(string) MAXDepth(integer 0) MAXFeatures(string)] PRedict(string) GRaph(string)

	
	//make sure `predict' is a valid newvar
	cap confirm variable `predict'
	if !_rc {
        di in red "variable `predict' already exists"
		exit
		}
	
	
	//seperate y from x and mark sample 
	gettoken label feature : varlist
	marksample touse
    quietly count if `touse'
	if r(N)==0 {
        di in red "no observation in the estimation sample"
		exit
		}	
	
	
	//gen estimation/prediction sample/ sampleweight if not defined
	cap drop esample_copy234 psample_copy234 sampleweight_copy234	
	
	gen esample_copy234=`touse'		
		
	if "`psample'"==""  gen psample_copy234=1
	else gen psample_copy234=`psample'
	local psample "psample_copy234"
	
	if "`sampleweight'"=="" gen sampleweight_copy234=1
	else gen sampleweight_copy234=`sampleweight'
	local sampleweight "sampleweight_copy234"
	
	
	//use png as default output type
	if substr("`graph'",-4,1)!="." local graph "`graph'.png"
	
	
	// if maxfeatures is not defined, use auto, if it is not sqrt, auto or log2 , but a number, use it
	// if it is none of the above, throw an error
	local maxftstr=1
	if "`maxfeatures'"=="" local maxfeatures "auto"
	if "`maxfeatures'"!=""{
		if "`maxfeatures'"!="sqrt"&"`maxfeatures'"!="log2"&"`maxfeatures'"!="auto"& regexm("`maxfeatures'", "^[-+]?[0-9]*\.?[0-9]+$")==1{
			local maxfeatures `maxfeatures'
			local maxftstr=0
			}
		if regexm("`maxfeatures'", "^[-+]?[0-9]*\.?[0-9]+$")==0 & "`maxfeatures'"!="auto"{
			di in red "`maxfeatures' is not a valid max_feature argument, please use sqrt, auto or log2"
		exit
			}
		}
		
		
	//set maxdepth to none if not defined
	if `maxdepth'==0 local maxdepth "None"
	
	
	//set criterion to gini if not defined
	if "`criterion'"=="" local criterion "gini"
	if "`criterion'"!="gini" & "`criterion'"!="entropy"{
		di in red "`criterion' is not a valid criterion, please use either gini or entropy"
		exit
			}
			
			
	// python is sentitive to datatype, so call program by maxfeatures
	if  `maxftstr'==1{
	python: dorfc("`label'", "`feature'","`sampleweight'",`nestimators',"`criterion'",`maxdepth',"`maxfeatures'","esample_copy234","`psample'","`predict'","`graph'")
	}
	if `maxftstr'==0{
	python: dorfc("`label'", "`feature'","`sampleweight'",`nestimators',"`criterion'",`maxdepth',`maxfeatures',"esample_copy234","`psample'","`predict'","`graph'")
	}
	
	qui drop sampleweight_copy234 psample_copy234 esample_copy234
	
end

version 16
python:

from sfi import Data
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier

pd.set_option('display.max_row', 1000)
pd.set_option('display.max_columns', 50)


def dorfc(label, features, sampleweight,nestimators,criterion,maxdepth,maxfeatures,esample,psample,predict,graph):	
	all = pd.DataFrame(Data.get(label+" "+features+" "+esample+" "+psample+" "+sampleweight,missingval=np.nan))	
	all.replace([np.inf, -np.inf], np.nan)
	
	for column in all:	
		if all[column].dtypes=='object':
			all[column]=pd.to_numeric(all[column],errors="coerce",downcast='integer')
	varnames=list()	
	xnames=list()

	for item in str.split(features):
		xnames.append(item)
	for item in str.split(label+" "+features+" "+esample+" "+psample+" "+sampleweight):
		varnames.append(item)	

	n_xs=len(str.split(features))
	x1=str.split(features)[0]
	xk=str.split(features)[-1]

	all.columns=varnames
	all['missing']=all.drop(label, axis=1).isnull().sum(axis=1)>=1 
	all = all.astype({esample: int, psample: int})

	
	all_est=all.dropna(how='any',axis=0)
	all_est=all_est.drop('missing', axis=1)	


	X_est = all_est.loc[all_est[esample]==1,x1:xk]	
	X_est=X_est.to_numpy(dtype='float32')

	y_est = all_est.loc[all_est[esample]==1,label]
	y_est=y_est.to_numpy(dtype='float32')

	cwt_est = all_est.loc[all_est[esample]==1,sampleweight]
	cwt_est = cwt_est.to_numpy(dtype='float32')

	print("Dimension of X_train:")
	print(X_est.shape)
	
	all= all.apply(lambda x: x.fillna(x.mean()),axis=0)
	X_prd=all.drop(['missing',label,esample,psample,sampleweight], axis=1)
	X_prd=X_prd.to_numpy(dtype='float32')

	rfc = RandomForestClassifier(oob_score=True, n_estimators=nestimators, criterion=criterion, max_depth= maxdepth, max_features= maxfeatures)
	rfc.fit(X_est, y_est, sample_weight=cwt_est)

	fis=rfc.feature_importances_.tolist()
	ipt=zip(xnames,fis)
	importances=sorted(ipt, key= lambda t: t[1],reverse=False)
	
	xnames=list()
	fis=list()
	rank=list()	
	r=-1
	print("Feature importances:")
	for item in importances:
		print(item)
		xnames.append(item[0])
		fis.append(item[1])
		r=r+1	
		rank.append(r)	

	plt.figure()
	plt.title("Feature importances")
	plt.barh(rank,fis, color="g", align="center")
	plt.yticks(range(X_est.shape[1]), xnames)
	plt.show()
	plt.savefig(graph)
		
	all['y_pred'] = rfc.predict(X_prd)
	all.loc[all['missing']==True,'y_pred']=np.nan
	all.loc[all[psample]==0,'y_pred']=np.nan
	prd=np.array(all['y_pred'])
	
	Data.addVarFloat(predict)
	Data.store(predict, None, prd)
end
