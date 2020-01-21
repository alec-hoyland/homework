using Turing, Random, Plots
Random.seed!(1234)

# observed series of events
y = [ 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 1.0, 1.0 ];
# length of the observed chain
N = length(y)
# number of states
K = 3;

# visualize the chain
plot(y, xlim = (0,15), ylim = (-1,5), size = (500, 250))



# Turing model definition
@model BayesHMM(y, K) = begin
    # Get observation length.
    N = length(y)

    # State sequence.
    s = tzeros(Int, N)

    # Emission matrix.
    m = Vector(undef, K)

    # Transition matrix.
    T = Vector{Vector}(undef, K)

    # Assign distributions to each element
    # of the transition matrix and the
    # emission matrix.
    for i = 1:K
        T[i] ~ Dirichlet(ones(K)/K)
        m[i] ~ Normal(i, 0.5)
    end

    # Observe each point of the input.
    s[1] ~ Categorical(K)
    y[1] ~ Normal(m[s[1]], 0.1)

    for i = 2:N
        s[i] ~ Categorical(vec(T[s[i-1]]))
        y[i] ~ Normal(m[s[i]], 0.1)
    end
end;

# sampling
g = Gibbs(HMC(0.001, 7, :m, :T), PG(20, :s))
c = sample(BayesHMM(y, 3), g, 100);

# Import StatsPlots for animating purposes.
using StatsPlots

# Extract our m and s parameters from the chain.
m_set = c[:m].value.data
s_set = c[:s].value.data

# Iterate through the MCMC samples.
Ns = 1:length(c)

# Make an animation.
animation = @animate for i in Ns
    m = m_set[i, :];
    s = Int.(s_set[i,:]);
    emissions = collect(skipmissing(m[s]))

    p = plot(y, c = :red,
        size = (500, 250),
        xlabel = "Time",
        ylabel = "State",
        legend = :topright, label = "True data",
        xlim = (0,15),
        ylim = (-1,5));
    plot!(emissions, color = :blue, label = "Sample $N")
end every 10

# Index the chain with the persistence probabilities.
subchain = c[:,["T[$i][$i]" for i in 1:K],:]

# Plot the chain.
plot(subchain,
    colordim = :parameter,
    seriestype=:traceplot,
    title = "Persistence Probability",
    legend=:right
    )

heideldiag(c[:T])
