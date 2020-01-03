## Tutorial 1: Bayesian Mixture Models

# https://github.com/TuringLang/TuringTutorials/blob/master/1_GaussianMixtureModel.ipynb
using Distributions, StatsPlots, Random

Random.seed!(3)

N = 30

# means of the clusters
μs = [-3.5, 0.0]
# generate the data points in two dimensions
x = mapreduce(c -> rand(MvNormal([μs[c], μs[c]], 1.), N), hcat, 1:2)

# visualize the unlabeled data
scatter(x[1, :], x[2, :], legend = false, title = "Synthetic Dataset")

## Gaussian mixture model

using Turing
Turing.turnprogress(false)

@model GaussianMixtureModel(x) = begin

    D, N = size(x)

    # Draw the paramters for cluster 1.
    μ1 ~ Normal()

    # Draw the paramters for cluster 2.
    μ2 ~ Normal()

    μ = [μ1, μ2]

    # Uncomment the following lines to draw the weights for the K clusters
    # from a Dirichlet distribution.

    α = 1.0
    w ~ Dirichlet(2, α)

    # Comment out this line if you instead want to draw the weights.
    # w = [0.5, 0.5]

    # Draw assignments for each datum and generate it from a multivariate normal.
    k = Vector{Int}(undef, N)
    for i in 1:N
        k[i] ~ Categorical(w)
        x[:,i] ~ MvNormal([μ[k[i]], μ[k[i]]], 1.)
    end
    return k
end

gmm_model = GaussianMixtureModel(x)
gmm_sampler = Gibbs(PG(100, :k), HMC(0.05, 10, :μ1, :μ2))
tchain = mapreduce(c -> sample(gmm_model, gmm_sampler, 100), MCMCChains.chainscat, 1:3);

# the tutorial is broken
