using Turing, Distributions, RDatasets, MCMCChains, Plots, StatsPlots
using StatsFuns: logistic
using Random
Random.seed!(0)
Turing.turnprogress(false);

# NOTE: Try to predict defaulting on a loan using account balance and income

## Data munging

data = RDatasets.dataset("ISLR", "Default")

# show the first 6 rows of the dataset
first(data, 6)

# create new columns
# where "Default" and "Student" columns are converted to floats
data[!, :DefaultNum] = [r.Default == "Yes" ? 1.0 : 0.0 for r in eachrow(data)]
data[!, :StudentNum] = [r.Student == "Yes" ? 1.0 : 0.0 for r in eachrow(data)]

# delete the old columns
select!(data, Not([:Default, :Student]))

# show the first 6 rows of the dataset
first(data, 6)

## Split data into train and test datasets

# function to split samples
function split_data(df, at = 0.70)
    (r, _) = size(df)
    index::Int = round(at * r)
    train = df[1:index, :]
    test = df[(index+1):end, :]
    return train, test
end

# compute the z-score
function zscore(x::Array{T}) where T <: Number
    (x .- mean(x)) ./ std(x)
end

# rescale columns according to the z-score
data.Balance = zscore(data.Balance)
data.Income = zscore(data.Income)

# split the dataset into 5% training, 95% testing
train, test = split_data(data, 0.05)

# create prediction labels
train_label = train[:, :DefaultNum]
test_label = test[:, :DefaultNum]

# remove columns that are not our predictors
train = train[:, [:StudentNum, :Balance, :Income]]
test = test[:, [:StudentNum, :Balance, :Income]]

# convert the DataFrame objects to matrices
train = Matrix(train)
test = Matrix(test)

## Model declaration

# Bayesian logistic regression
@model logistic_regression(x, y, n, σ) = begin
    intercept ~ Normal(0, σ)
    student ~ Normal(0, σ)
    balance ~ Normal(0, σ)
    income  ~ Normal(0, σ)

    for i in 1:n
        v = logistic(intercept + student*x[i, 1] + balance*x[i, 2] + income*x[i, 3])
        y[i] ~ Bernoulli(v)
    end
end

## Sampling

# how many samples?
n, _ = size(train)

# sample using HMC
f(x) = sample(logistic_regression(train, train_label, n, 1), HMC(0.05, 10), 1500)
chain = mapreduce(f, chainscat, 1:3)

describe(chain)

plot(chain)
corner(chain, [:student, :balance, :income])
