## Baysian Neural Networks
# https://github.com/TuringLang/TuringTutorials/blob/master/3_BayesNN.ipynb

using Turing, Flux, Plots, Random

Turing.turnprogress(false)
Turing.setadbackend(:reverse_diff)

## Generate sample data

# Number of points to generate.
N = 80
M = round(Int, N / 4)
Random.seed!(1234)

# Generate artificial data.
x1s = rand(M) * 4.5; x2s = rand(M) * 4.5;
xt1s = Array([[x1s[i] + 0.5; x2s[i] + 0.5] for i = 1:M])
x1s = rand(M) * 4.5; x2s = rand(M) * 4.5;
append!(xt1s, Array([[x1s[i] - 5; x2s[i] - 5] for i = 1:M]))

x1s = rand(M) * 4.5; x2s = rand(M) * 4.5;
xt0s = Array([[x1s[i] + 0.5; x2s[i] - 5] for i = 1:M])
x1s = rand(M) * 4.5; x2s = rand(M) * 4.5;
append!(xt0s, Array([[x1s[i] - 5; x2s[i] + 0.5] for i = 1:M]))

# Store all the data for later.
xs = [xt1s; xt0s]
ts = [ones(2*M); zeros(2*M)]

# Plot data points.
function plot_data()
    x1 = map(e -> e[1], xt1s)
    y1 = map(e -> e[2], xt1s)
    x2 = map(e -> e[1], xt0s)
    y2 = map(e -> e[2], xt0s)

    Plots.scatter(x1,y1, color="red", clim = (0,1))
    Plots.scatter!(x2, y2, color="blue", clim = (0,1))
end

plot_data()

## Define a neural network
# where parameters are expressed as distributions

# convert a vector into a set of weights and biases
function unpack(nn_params::AbstractVector)
    W₁ = reshape(nn_params[1:6], 3, 2)
    b₁ = reshape(nn_params[7:9], 3)

    W₂ = reshape(nn_params[10:15], 2, 3)
    b₂ = reshape(nn_params[16:17], 2)

    Wₒ = reshape(nn_params[18:19], 1, 2)
    bₒ = reshape(nn_params[20:20], 1)
    return W₁, b₁, W₂, b₂, Wₒ, bₒ
end

# construct a neural network using Flux and return a predicted value
function nn_forward(xs, nn_params::AbstractVector)
    W₁, b₁, W₂, b₂, Wₒ, bₒ = unpack(nn_params)
    nn = Chain(Dense(W₁, b₁, tanh),
               Dense(W₂, b₂, tanh),
               Dense(Wₒ, bₒ, σ))
    return nn(xs)
end

# create a probabilistic model

# create regularization and Gaussian prior variance terms
alpha = 0.09
sig = sqrt(1.0 / alpha)

# specify the probabalistic model
@model bayes_nn(xs, ts) = begin
    # create prior distributions for all parameters
    nn_params ~ MvNormal(zeros(20), sig .* ones(20))

    # construct a probabalistic neural network model
    preds = nn_forward(xs, nn_params)

    # observe each prediction
    for i = 1:length(ts)
        ts[i] ~ Bernoulli(preds[i])
    end
end

## Perform inference
N = 5000
ch = sample(bayes_nn(hcat(xs...), ts), HMC(0.05, 4), N)

# extract all weights and biases
theta = ch[:nn_params].value.data

## Prediction visualization

# Plot the data we have.
plot_data()

# Find the index that provided the highest log posterior in the chain.
_, i = findmax(ch[:lp].value.data)

# Extract the max row value from i.
i = i.I[1]

# Plot the posterior distribution with a contour plot.
x_range = collect(range(-6,stop=6,length=25))
y_range = collect(range(-6,stop=6,length=25))
Z = [nn_forward([x, y], theta[i, :])[1] for x=x_range, y=y_range]
contour!(x_range, y_range, Z)



# Return the average predicted value across
# multiple weights.
function nn_predict(x, theta, num)
    mean([nn_forward(x, theta[i,:])[1] for i in 1:10:num])
end;


# Plot the average prediction.
plot_data()

n_end = 1500
x_range = collect(range(-6,stop=6,length=25))
y_range = collect(range(-6,stop=6,length=25))
Z = [nn_predict([x, y], theta, n_end)[1] for x=x_range, y=y_range]
contour!(x_range, y_range, Z)

:

# Number of iterations to plot.
n_end = 500

anim = @animate for i=1:n_end
    plot_data()
    Z = [nn_forward([x, y], theta[i,:])[1] for x=x_range, y=y_range]
    contour!(x_range, y_range, Z, title="Iteration $i", clim = (0,1))
end every 5;
