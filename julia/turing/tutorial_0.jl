## Coin-Flipping without Turing

using Random, Plots, Distributions
using StatsPlots

# set the true probability of heads in a coin
p_true = 0.5

# iterate from having seen 0 observations to 100 observations
Ns = 0:100

# use the Bernoulli distribution to flip 100 coins
Random.seed!(12) # for reproducibility
data = rand(Bernoulli(p_true), last(Ns))

# inspect the coin flips
@show data[1:5]

# prior belief about the probability of heads in a coin toss
prior_belief = Beta(1, 1)

# make an animation
animation = @gif for (i, N) in enumerate(Ns)

    # Count the number of heads and tails.
    heads = sum(data[1:i-1])
    tails = N - heads

    # Update our prior belief in closed form (this is possible because we use a conjugate prior).
    updated_belief = Beta(prior_belief.α + heads, prior_belief.β + tails)

    # Plotting
    plot(updated_belief,
        size = (500, 250),
        title = "Updated belief after $N observations",
        xlabel = "probability of heads",
        ylabel = "",
        legend = nothing,
        xlim = (0,1),
        fill=0, α=0.3, w=3)
    vline!([p_true])
end

## Coin Flipping with Turing.jl

using Turing, MCMCChains
using Distributions
using StatsPlots

# define a coin-flip model using Turing
@model coinflip(y) = begin
    # prior belief about the probability of heads in a coin flip
    p ~ Beta(1, 1)

    # the number of observations
    N = length(y)
    for n in 1:N
        # heads or tails of a coin a drawn from a Bernoulli distribution
        y[n] ~ Bernoulli(p)
    end
end

# Hamiltonian Monte Carlo (HMC) sampler
iterations = 100
ϵ = 0.05
τ = 10

# previously observed results
data = rand(Bernoulli(0.5), 100)

# start sampling
chain = sample(coinflip(data), HMC(ϵ, τ), iterations, progress=false)

# construct summary of sampling process for parameter p
plot(chain[:p], seriestype = :histogram, xlim = (0, 1))

# Compute the posterior distribution in closed-form.
N = length(data)
heads = sum(data)
prior_belief = Beta(1, 1)
updated_belief = Beta(prior_belief.α + heads, prior_belief.β + N - heads)

# Visualize a blue density plot of the approximate posterior distribution using HMC (see Chain 1 in the legend).
p = plot(chain[:p], seriestype = :density, xlim = (0,1), legend = :best, w = 2, c = :blue)

# Visualize a green density plot of posterior distribution in closed-form.
plot!(p, range(0, stop = 1, length = 100), pdf.(Ref(updated_belief), range(0, stop = 1, length = 100)),
        xlabel = "probability of heads", ylabel = "", title = "", xlim = (0,1), label = "Closed-form",
        fill=0, α=0.3, w=3, c = :green)

# Visualize the true probability of heads in red.
vline!(p, [0.5], label = "True probability", c = :red)
