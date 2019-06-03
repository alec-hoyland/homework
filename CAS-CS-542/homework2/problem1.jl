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

# determine a linear model with individual and mixed effects
# f = Array{Formula}(undef, length(colnames))
for i, val in enumerate(colnames)
    f[i] = Term(:HOM) ~ ConstantTerm(1) + Term(:FTP) * Term(:We) * Term(val)
end
myModel = fit(LinearModel, f, df)
