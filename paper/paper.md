---
title: 'LinRegOutliers: A Julia package for detecting outliers in linear regression'
tags:
  - Julia
  - linear regression
  - outlier detection
  - robust statistics
authors:
  - name: Mehmet Hakan Satman
    orcid: 0000-0002-9402-1982
    affiliation: 1
  - name: Shreesh Adiga
    orcid: 0000-0002-1818-6961
    affiliation: 2
  - name: Guillermo Angeris
    orcid: 0000-0000-0000-0000 
    affiliation: 3
  - name: Emre Akadal
    orcid: 0000-0001-6817-0127 
    affiliation: 4
affiliations:
 - name: Department of Econometrics, Istanbul University, Istanbul, Turkey
   index: 1
 - name: Department of Electronics and Communication Engineering, RV College of Engineering, Bengaluru, India
   index: 2
 - name: AFFILIATION FOR GUILLERMO ANGERIS
   index: 3
 - name: Department of Informatics, Istanbul University, Istanbul, Turkey
   index: 4

date: 26 November 2020
bibliography: paper.bib
---

# Summary

*LinRegOutliers* is a *Julia* package that implements many outlier detection algorithms in linear regression. The implemented algorithms can be categorized as regression diagnostics, direct methods, robust methods, multivariate methods, and graphical methods. 
Diagnostics are generally used in initial stages of direct methods. Since the design matrix of a regression model is multivariate data, the package also contains some robust covariance matrix estimators and outlier detection methods developed for multivariate data. Graphical methods are implemented for visualizing the regression residuals and the distances between observations using Euclidean or Mahalanobis distances generally calculated using a robust covariance matrix. The functions in the package have the same calling conventions. The package covers most of the literature on this topic and provides a good basis for those who want to implement novel methods.


# State of the field
Suppose the linear regression model is

$$
y = X \beta + \epsilon
$$

where $y$ is the vector of dependent variable, $X$ is the $n \times p$ design matrix, $\beta$ is the vector
of unknown parameters, $n$ is the number of observations, $p$ is the number of parameters, and $\epsilon$ is the vector of error-term with zero mean and constant 
variance. The Ordinary Least Squares (OLS) estimator $\hat{\beta} = (X'X)^{-1}X'y$ is not resistant to outliers even if a single 
observation lies far from the regression hyper-plane. There are many direct and robust methods for detecting outliers in linear regression in the literature. Robust methods are based on estimating robust regression parameters and observations with higher absolute residuals are labelled as outliers whereas direct methods are generally based on enlarging a clean subset of observations by iterations since a termination criterion is met. 
Although outlier detection in multivariate data is another topic, robust covariance estimators and some multivarite outlier detection methods are used for detecting influential observations in design matrix of regression models.
    
# Statement of need 

Julia is a high performance programming language designed primarily for scientific computing. *LinRegOutliers* is the unique Julia package that covers the literature on the topic of detecting outliers in linear regression, well. The package implements 
*hadimeasure* [@hadimeasure], *covratio*, *dfbeta*, *dffit* [@diagnostics], *cooks* [@cooks]  for regression diagnostics,
*ransac* [@ransac], *ks89* [@ks89], *hs93* [@hs93], *atkinson94* [@atkinson94],  *py95* [@py95], *cm97* [@cm97], *smr98* [@smr98], *asm2000* [@asm2000], *bacon* [@bacon],  *imon2005* [@imon2005], *bch* [@bch], *ccf* [@ccf], *lad* [@lad], *lta* [@lta], 
*lms* [@lms], *lts* [@lts], *satman2013* [@satman2013], *satman2015* [@satman2015] for regression data, *hadi1992* [@hadi1992], *hadi1994* [@hadi1994], *mve* [@mve], *mcd* [@mcd], *dataimage* [@dataimage] for multivariate data. 


# Installation and basic usage

*LinRegOutliers* can be downloaded and installed using the Julia package manager by typing

```julia
julia> using Pkg
julia> Pkg.add("LinRegOutliers")
```

in Julia console. The regression methods follow a uniform call convention. For instance one can type

```julia
julia> setting = createRegressionSetting(@formula(calls ~ year), phones);
julia> smr98(setting)
```

or

```julia
julia> X = hcat(ones(24), phones[:, "year"]);
julia> y = phones[:, "calls"];
julia> smr98(X, y)
10-element Array{Int64,1}:
 15
 16
 17
 18
 19
 20
 21
 22
 23
 24

```

to apply *smr98* [@smr98] on Telephone data [@lms], where $X$ is the design matrix with ones in its first column. Observations 15th to 24th are reported as outliers by the method. Some methods return not only the indices of outliers but some extra details covered by a ```Dict``` object. For example the *ccf* function returns a ```Dict``` containing *betas*, *outliers*, *lambdas*, and *residuals as seen in the example below.

```julia
julia> ccf(X, y)
Dict{Any,Any} with 4 entries:
  "betas"     => [-63.4816, 1.30406]
  "outliers"  => [15, 16, 17, 18, 19, 20]
  "lambdas"   => [1.0, 1.0, 1.0, 1.0, 1.0, ...
  "residuals" => [-2.67878, -1.67473, -0.37067, -0.266613, …
```

Indices of outliers can be accessed using standard ```Dict``` operations like

```julia
julia> result = ccf(X, y)
julia> result["outliers"]
```
 




# References
