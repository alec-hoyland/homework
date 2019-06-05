#%% ---
#%% title : Homework #2, Problem 1
#%% data : 2019-06-03
#%% options :
#%%     doctype: md2pdf
#%%

#%% ## Introduction
#%% Detroit is a lovely city, but it also has a serious crime problem.
#%% Here, we use linear least-squares regression to determine
#%% a minimal model that predicts the homicide rate,
#%% using data from J.C. Fisher (1976).

cd("/home/alec/code/homework/CAS-CS-542/homework2/")

# preamble
using NPZ
using DataFrames
using StatsModels
using GLM

# load the data set
df = npzread("data/detroit.npy") |> DataFrame
colnames = [:FTP, :UEMP, :MAN, :LIC, :GR, :NMAN, :GOV, :HE, :WE, :HOM]
names!(df, colnames)

@show df

#%% ## Determining a linear model fit
#%% We attempt to predict the homicide rate `HOM` as a linear function of `FTP`, `WE`,
#%% and some other variable. We will therefore make 8 fits, each using a model
#%% `HOM ~ FTP + WE + X`, where `X` is one of the other variables in the dataset.
#%% Since we want the model to have four parameters and depend on only three independent variables,
#%% and two of them are fixed, I have decided not to use the PRESS criterion for
#%% evaluating the goodness of a parsimonious model.
#%% Instead, I have opted to use the Bayesian information criterion.
#%% Since all models use the same data and have the same number of parameters,
#%% the model which minimizes the residual sum of squares (equivalently, the negative log-likelihood)
#%% is the best model fit.

# determine a linear model with individual effects
vars = [:UEMP, :MAN, :LIC, :GR, :NMAN, :GOV, :HE]
f = Array{Formula}(undef, length(vars))
ols = Array{StatsModels.DataFrameRegressionModel}(undef, length(vars))
for (i, var) in enumerate(vars)
    f[i] = @eval @formula(HOM ~ 1 + FTP + WE + $var)
    ols[i] = fit(LinearModel, f[i], df)
end

BIC = deviance.(ols)
vars[argmin(BIC)]

#%% The variable to add is `j vars[argmin(BIC)]`.

#%% Formal justification
#%% The variable that should be factored into the linear model is `LIC`.
#%% The Bayesian information criterion is formally defined as
#%% ``\mathrm{BIC} = \ln(n)k - 2 \ln(\hat{\mathcal{L}})``
#%% where ``\hat{\mathcal{L}}`` is the maximized value of the likelihood function
#%% ``\mathcal{L} = p(x | \hat{\theta}, M)`` where ``M`` is the model and ``\hat{\theta}``
#%% are the parameter values that maximize the likelihood.
#%% ``n`` is the number of data points in ``x``, the observed data,
#%% and ``k`` is the number of parameters.

#%% For a prior for ``\theta`` under model ``M``
#%% we can integrate out the parameters.
#%%
#%% ``p(x | M) = \int p(x | \theta, M) p(\theta | M) \mathrm{d}\theta``
#%%
#%% Then, considering the log-likelihood ``\ln(p(x | \theta, M))``,
#%% and expanding to a second-order Taylor series about the maximum-likelihood estimate
#%% ``\hat{\theta}``,
#%%
#%% ``\ln(p(x | \theta, M)) = \ln\hat{\mathcal{L}} - \frac{1}{2}(\theta - \hat{\theta})^T n \mathcal{I}(\theta) (\theta - \hat{\theta})``
#%%
#%% Here, ``\mathcal{I}(\theta)`` is the expected Fisher information per observation.
#%% The first-order terms disappear because we expanded about the maximum likelihood,
#%% hence the first derivative is zero.
#%% If we chose a prior such that it is relatively linear near the MLE, we can integrate and get
#%%
#%% ``p(x | M) \approx \hat{\mathcal{L}}(2\pi / n)^{k/2} | \mathcal{I}(\hat{\theta}) | ^{-1/2} p(\hat{\theta})``
#%%
#%% For large ``n``, we can ignore the terms of constant order, to approximate:
#%%
#%% p(M | x) \propto p(x | M) p(M) \approx \exp(\ln (\hat{\mathcal{L}}) - \frac{k}{2} \ln (n))``
#%%
#%% from which we define ``\mathrm{BIC} = \ln(n)k - 2 \ln(\hat{\mathcal{L}})``.
#%% For an ordinary least squares fit, minimizing the negative logarithm of the likelihood
#%% is equivalent to minimizing the residual sum of squares error.
#%% We prove this in homework #2, question 1 part D.
#%% Therefore, since we have restricted our model to three explanatory variables,
#%% and two are chosen for us, we can select the best model by choosing the one
#%% with the third variable which results in the lowest residual sum of squares error
#%% after ordinary least squares fitting.

using Plots; gr()

scatter(1961:1973, df.HOM,
    xlabel = "year",
    ylabel = "homicide rate",
    label = "real data")
scatter!(1961:1973, predict(ols[argmin(BIC)]), label = "predicted", legend = :topleft)
