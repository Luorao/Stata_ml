{smcl}
{* July 24, 2020}{...}
{cmd:help gbc}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:gbc}} Module to call Python Sklearn, fit gradient boosting classifier and generate prediction. {p2colreset}{...}


{title:Syntax}

{p 8 17 1}
{hi:gbc}
{it:outcome}
{it:varlist}
{ifin}, {p_end}
{space 10}{cmd:[}
{space 10}{cmd:sampleweight/sa}{cmd:(}{it:varname, sample weight}{cmd:)}
{space 10}{cmd:loss/lo} {cmd:(}{it:{‘deviance’, ‘exponential’}, loss function to be optimized}{cmd:)}
{space 10}{cmd:learning_rate/le}{cmd:(}{it:float, a parameter that shrinks the contribution of each tree}{cmd:)}
{space 10}{cmd:nestimators/ne}{cmd:(}{it:integer, # trees in the forest)}{cmd:)}
{space 10}{cmd:subsample/su} {cmd:(}{it:float, the fraction of samples to be used for fitting the individual base learners)}{cmd:)}
{space 10}{cmd:criterion/cr}{cmd:(}{it:{‘friedman_mse’, ‘mse’, ‘mae’}, the function to measure the quality of a split}{cmd:)}
{space 10}{cmd:maxdepth/maxd}{cmd:(}{it:integer, the maximum depth of the tree}{cmd:)} 
{space 10}{cmd:min_impurity_decrease/mi} {cmd:(}{it:float, a node will be split if this split induces a decrease of the impurity no less than this value}{cmd:)} 
{space 10}{cmd:maxfeatures/maxf}{cmd:(}{it:“auto”, “sqrt”, “log2” or an integer/float, the number of features to consider when looking for the best split}{cmd:)} 
{space 10}{cmd:validation_fraction/va} {cmd:(}{it:float, the proportion of training data to set aside as validation set for early stopping}{cmd:)}
{space 10}{cmd:tol}{cmd:(}{it:float, tolerance for the early stopping}{cmd:)} 
{space 10}{cmd:niter_no_change/ni}{cmd:(}{it:integer, is used to decide if early stopping will be used to terminate training when validation score is not improving.}{cmd:)} 
{space 10}{cmd:ccp_alpha/cc} {cmd:(}{it:non-negative float, complexity parameter used for Minimal Cost-Complexity Pruning}{cmd:)} 
{space 10}{cmd:psample/ps}{cmd:(}{it:varname, indicator of prediction sample}{cmd:)]} 
{space 10}{cmd:]}
{space 10}{cmd:predict/pr}({it:new varname, name of the prediction var}{cmd:)}
{space 10}{cmd:graph/gr}({it:string/path-like or file-like object}{cmd:)}


{title:Description}

{pstd} {cmd: gbc} takes the advantages of Stata-Python integration, calling function "GradientBoostingClassifier()" in scikit-learn module, fitting gradient boosting model and generating prediction. User can fit model with sample weight. Due to the limitation of python package, please replace categorical variables with dummies.

     
{title:Options}


{phang} {cmd:sampleweight/ca}{cmd:(}{it:varname, optional}{cmd:)} Sample weight, the default is 1 for everyone.

{phang} {cmd:loss/lo}{cmd:(}{‘deviance’, ‘exponential’}, default=’deviance’}{cmd:)} Loss function to be optimized. ‘deviance’ refers to deviance (= logistic regression) for classification with probabilistic outputs.

{phang} {cmd:learning_rate/le}{cmd:(}{it:float, optional, default=0.1}{cmd:)} A parameter that shrinks the contribution of each tree. 

{phang} {cmd:nestimators/ne}{cmd:(}{it:integer, optional, default=100}{cmd:)} The number of trees in the forest. 

{phang} {cmd:subsample/su}{cmd:(}{it:float, optional, default=1.0}{cmd:)} The fraction of samples to be used for fitting the individual base learners. If smaller than 1.0 this results in Stochastic Gradient Boosting. subsample interacts with the parameter nestimators. Choosing subsample < 1.0 leads to a reduction of variance and an increase in bias.

{phang} {cmd:criterion/cr}{cmd:(}{it:{‘friedman_mse’, ‘mse’, ‘mae’}, optional, default="friedman_mse"}{cmd:)} The function to measure the quality of a split. Supported criteria are ‘friedman_mse’ for the mean squared error with improvement score by Friedman, ‘mse’ for mean squared error, and ‘mae’ for the mean absolute error. The default value of ‘friedman_mse’ is generally the best as it can provide a better approximation in some cases.tree-specific.

{phang} {cmd:maxdepth/maxd}{cmd:(}{it:integer, optional, default=3}{cmd:)} Maximum depth of the individual regression estimators. The maximum depth limits the number of nodes in the tree. Tune this parameter for best performance; the best value depends on the interaction of the input variables. 

{phang} {cmd:min_impurity_decrease/mi}{cmd:(}{it:float, optional, default=0}{cmd:)} A node will be split if this split induces a decrease of the impurity greater than or equal to this value. 

{phang} {cmd:maxfeatures/maxf}{cmd:(}{it:{“auto”, “sqrt”, “log2”} An integer or a float, optional, default=”auto”}{cmd:)} If int, then consider max_features features at each split.
If float, then max_features is a fraction and int(max_features * n_features) features are considered at each split.If “auto”, then max_features=sqrt(n_features). If “sqrt”, then max_features=sqrt(n_features) (same as “auto”). If “log2”, then max_features=log2(n_features).

{phang} {cmd:validation_fraction/va}{cmd:(}{it:float, optional, default=0.1}{cmd:)} The proportion of training data to set aside as validation set for early stopping. Must be between 0 and 1. 

{phang} {cmd:niter_no_change/ni}{cmd:(}{it:integer, optional, default=None}{cmd:)} It is used to decide if early stopping will be used to terminate training when validation score is not improving. By default it is set to None to disable early stopping. If set to a number, it will set aside validation_fraction size of the training data as validation and terminate training when validation score is not improving in all of the previous niter_no_change numbers of iterations. The split is stratified.

{phang} {cmd:tol}{cmd:(}{it:float, optional, default=0.0001}{cmd:)} Tolerance for the early stopping. When the loss is not improving by at least tol for niter_no_change iterations (if set to a number), the training stops. Only used if niter_no_change is set to an integer. 

{phang} {cmd:ccp_alpha/cc}{cmd:(}{it:non-negative float, optional, default=0.0}{cmd:)} Complexity parameter used for Minimal Cost-Complexity Pruning. The subtree with the largest cost complexity that is smaller than ccp_alpha will be chosen. By default, no pruning is performed. See Minimal Cost-Complexity Pruning for details.

{phang} {cmd:psample/ps}{cmd:(}{it:varname, optional}{cmd:)} A 0-1 variable to indicate whether observation should be used in prediction. The default is all observations.

{phang} {cmd:predict/pr}{cmd:(}{it:varname, required}{cmd:)} The name of the prediction variables. It should comply with Stata variable naming convention. 

{phang} {cmd:graph/gr}{cmd:(}{it:filename/pathname, required}{cmd:)} The filename/pathname of feature importance barplot(eg: "name", "name.png", "/home/directory1/directory2/name", "/home/directory1/directory2/name.pdf"). The default is png format, saving in the current working directory. Relative pathname is not supported. The user can either set the working directory ahead, or use an absolute pathname. 

************************************************************************************************************


{title:Reference & more...}

{phang}Friedman, J. H.(February 1999). Greedy Function Approximation: A Gradient Boosting Machine.{p_end}
{phang}Friedman, J. H.(March 1999), Stochastic Gradient Boosting.{p_end}

{title:Author}

{phang}Luorao Bian{p_end}



