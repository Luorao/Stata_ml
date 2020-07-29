{smcl}
{* July 24, 2020}{...}
{cmd:help rfc}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:rfc}} Module to call Python Sklearn, fit random forest classifier and generate prediction. {p2colreset}{...}


{title:Syntax}

{p 8 17 1}
{hi:rfc}
{it:outcome}
{it:varlist}
{ifin}, {p_end}
{space 10}{cmd:[}
{space 10}{cmd:psample/ps}{cmd:(}{it:varname, indicator of prediction sample}{cmd:)}
{space 10}{cmd:sampleweight/sa}{cmd:(}{it:varname, sample weight}{cmd:)}
{space 10}{cmd:nestimators/ne}{cmd:(}{it:integer, # trees in the forest}{cmd:)}
{space 10}{cmd:criterion/cr}{cmd:(}{it:{“gini”, “entropy”}, the function to measure the quality of a split}{cmd:)}
{space 10}{cmd:maxdepth/maxd}{cmd:(}{it:integer, the maximum depth of the tree}{cmd:)}
{space 10}{cmd:maxfeatures/maxf} {cmd:(}{it:“auto”, “sqrt”, “log2” or an integer/float, the number of features to consider when looking for the best split}{cmd:)}
{space 10}{cmd:]}
{space 10}{cmd:predict/pr}({it:new varname, name of the prediction var}{cmd:)}
{space 10}{cmd:graph/gr}({it:string/path-like or file-like object}{cmd:)}


{title:Description}

{pstd} {cmd:rfc}  takes the advantages of Stata-Python integration, calling function "RandomForestClassifier()" in scikit-learn module, fitting random forest and generating prediction. The command allows user to fit model with sample weight. Due to the limitation of python package, please replace categorical variables with dummies.

     
{title:Options}


{phang} {cmd:psample/ps}{cmd:(}{it:varname, optional}{cmd:)} A 0-1 variable to indicate whether observation should be used in prediction. The default is all observations.

{phang} {cmd:sampleweight/ca}{cmd:(}{it:varname, optional}{cmd:)} Sample weight, the default is 1 for everyone.

{phang} {cmd:nestimators/ne}{cmd:(}{it:integer, optional}{cmd:)} The number of trees in the forest. 

{phang} {cmd:criterion/cr}{cmd:(}{it:{“gini”, “entropy”}, optional, default=”gini”}{cmd:)} The function to measure the quality of a split. Supported criteria are “gini” for the Gini impurity and “entropy” for the information gain. Note: this parameter is tree-specific.

{phang} {cmd:maxdepth/maxd}{cmd:(}{it:integer, optional, default=None}{cmd:)}The maximum depth of the tree. If None, then nodes are expanded until all leaves are pure or until all leaves contain less than min_samples_split samples.

{phang} {cmd:maxfeatures/maxf}{cmd:(}{it:{“auto”, “sqrt”, “log2”} An integer or a float, optional, default=”auto”}{cmd:)} If int, then consider max_features features at each split.
If float, then max_features is a fraction and int(max_features * n_features) features are considered at each split.
If “auto”, then max_features=sqrt(n_features).
If “sqrt”, then max_features=sqrt(n_features) (same as “auto”).
If “log2”, then max_features=log2(n_features).

{phang} {cmd:criterion/cr}{cmd:(}{it:{“gini”, “entropy”}, optional, default=”gini”}{cmd:)} The function to measure the quality of a split. Supported criteria are “gini” for the Gini impurity and “entropy” for the information gain. Note: this parameter is tree-specific.

{phang} {cmd:predict/pr}{cmd:(}{it:varname, required}{cmd:)} The name of the prediction variables. It should comply with Stata variable naming convention. 

{phang} {cmd:graph/gr}{cmd:(}{it:filename/pathname, required}{cmd:)} The filename/pathname of feature importance barplot(eg: "name", "name.png", "/home/directory1/directory2/name", "/home/directory1/directory2/name.pdf"). The default is png format, saving in the current working directory. Since the argument comes in as a string and there is no ".py"  script involved, relative pathname won't work. The user can either set the working directory ahead, or use an absolute pathname. 

************************************************************************************************************


{title:Reference & more...}

{phang}Breiman, L.(2001), Random Forests, Machine Learning 45(1), 5-32.{p_end}
{phang}Breiman, L.(2002), Manual On Setting Up, Using, And Understanding Random Forests V3.1{p_end}

{title:Author}

{phang}Luorao Bian{p_end}



