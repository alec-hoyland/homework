## Representing Data in a Computer
using Images, Statistics, Plots; gr()
path = "/home/ahoyland/code/Fruit-Images-Dataset/Test/"

# load a picture of an apple
apple = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Apple Braeburn/3_100.jpg")
banana = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Banana/116_100.jpg")
typeof(apple[40, 60])

# pull out the red value of the color of the apple
typeof(red(apple[40,60]))
float(red(apple[40,60]))

[ mean(float.(c.(img))) for c = [red,green,blue], img = [apple,banana] ]
apple[18:20, 29:31]

# visualize the distribution of "green" in the pictures
histogram(float.(green.(apple[:])), color="red", label="apple", normalize=true, nbins=25)
histogram!(float.(green.(banana[:])), color="yellow", label="banana", normalize=true, nbins=25)

# the apple is very red
pixel = apple[40, 60];

red_value   = Float64( red(pixel) )
green_value = Float64( green(pixel) )
blue_value  = Float64( blue(pixel) )

print("The RGB values are ($red_value, $green_value, $blue_value)")

## Functions Useful in Machine Learning
using Plots, Interact; gr()

# define the sigmoidal function
σ(x) = 1 / (1 + exp(-x))

plot(σ, -5, 5)
hline!([0, 1], ls = :dash, lw = 3)
vline!([0], ls = :dash, lw = 3)

heaviside(x) = x < 0 ? 0.0 : 1.0

@manipulate for w in 0.1:0.1:20
    plot(x -> σ(w*x), -5, 5, label = "sigma", lw = 2)
    plot!(heaviside, ls = :dash, label = "step")
end

## Modeling Data
using Images

# load the pictures of fruit
apple = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Apple Braeburn/3_100.jpg")
banana = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Banana/116_100.jpg")

# define a new method for the sigmoid function
σ(x, w, b) = 1 / (1 + exp(-w*x + b))

# the parameters (w, b) = (25.58, 15.6) work well
plot(x -> σ(x, 26.58, 15.6), xlim=(0,1), ylim=(-0.1, 1.1), label="model", legend=:topleft, lw=3)
scatter!([mean(Float64.(green.(apple)))], [0.0], label="apple", ms=5)
scatter!([mean(Float64.(green.(banana)))], [1.0], label="banana", ms=5)

## The Loss Function
using Plots; plotlyjs()

# define the sigmoid
σ(x)        = 1 / (1 + exp(-x))
σ(x, w)     = σ(w*x)
σ(x, w, b)  = σ(w*x + b)

# create some data
xs = [2, -3, -1, 1]
ys = [0.8, 0.3, 0.4, 0.4]

# define the loss function
L2(w, b) = sum( (ys .- σ.(xs, w, b)) .^ 2 )

# visualize the loss function
ws = -2:0.05:2
bs = -2:0.05:2

surface(ws, bs, L2, alpha=0.8, zlims=(0,3))

## Minimization
using Plots; gr()

# define the sigmoid function
σ(x)        = 1 / (1 + exp(-x))
σ(x, w)     = σ(w * x)
σ(x, w, b)  = σ(w * x + b)

# define the loss function using some data
x1, y1      = 2, 0.8
L1(w)       = (y1 - σ(x1, w))^2

plot(L1, -2, 1.5, xlabel="w", ylabel="L1(w)", leg=false)

## Intro to Flux
using Flux

# create a model neuron with two inputs, one output, and the σ linking function
model       = Dense(2, 1, σ)

## Learning with a Single Neuron
using CSV, DataFrames, Flux
cd("/home/ahoyland/code/homework/julia")
apples      = CSV.File("data/Apple_Golden_1.dat", header=true, delim='\t') |> DataFrame
bananas     = CSV.File("data/bananas.dat", header=true, delim='\t') |> DataFrame

for df in [apples, bananas]
    rename!(df, Symbol("height ") => :height, Symbol(" width ") => :width,
    Symbol(" red ") => :red, Symbol(" green ") => :green, Symbol(" blue") => :blue)
end

x_apples    = [ [apples[i, :red], apples[i, :green]] for i in 1:size(apples)[1] ]
x_bananas   = [ [bananas[i, :red], bananas[i, :green]] for i in 1:size(bananas)[1] ]

# input data of red and green colors in apples and bananas
xs          = vcat(x_apples, x_bananas)
# true classification
ys          = vcat( zeros(size(x_apples)[1]), ones(size(x_bananas)[1]) );

data        = zip(xs, ys)

# how to create parameters (Tracked Arrays)
W           = Flux.param(rand(1,2))
b           = Flux.param(rand(1))

# create a single-neuron (dense) model
model       = Flux.Dense(2, 1, Flux.σ)

# define a loss function
loss(x,y)   = Flux.mse(model(x), y)

# determine the optimization regime (stochastic gradient descent)
opt         = Flux.SGD([model.W, model.b], 0.01)

# train the model
for i in 1:100
    Flux.train!(loss, data, opt)
end
