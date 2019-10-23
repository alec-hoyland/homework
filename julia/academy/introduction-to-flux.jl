using Flux, Plots

# flux provides the sigmoid function
σ

# create a dense layer
model = Dense(2, 1, σ)

# call the model as a function
x = rand(2)
model(x)
# same as evaluating the model
σ.(model.W*x + model.b)

## Try on some real data
using CSV, DataFrames
cd("/home/alec/code/homework/julia/academy/")
apples = CSV.File("../data/Apple_Golden_1.dat", delim='\t', allowmissing=:none, normalizenames=true) |> DataFrame
bananas = CSV.File("../data/bananas.dat", delim='\t', allowmissing=:none, normalizenames=true) |> DataFrame

# extract out the features we care about
x_apples = [ [row.red, row.green] for row in eachrow(apples)]
x_bananas = [ [row.red, row.green] for row in eachrow(bananas)]

# create a training dataset
xs = [x_apples; x_bananas]

# create a vector of the labels for the data in the training set
ys = [fill(0, size(x_apples)); fill(1, size(x_bananas))]

## Interlude: see what tracked numbers are
propertynames(model.W)
model.W.tracker
model.W.data
model.W.grad

## Backpropagation
η = 0.01
for step in 1:20
    i = rand(1:length(xs))
    loss = Flux.mse(model(xs[i]), ys[i])
    Flux.back!(loss)
    model.W.data .-= model.W.grad * η
    model.b.data .-= model.b.grad * η
end

## Training a model
model = Dense(2, 1, σ)
L(x, y) = Flux.mse(model(x), y)
opt = SGD(params(model))
for step in 1:100
    Flux.train!(L, zip(xs, ys), opt)
end

## Neural Networks / Deep Learning

# NOTE: clever data type to save space
using Flux: onehot
ys = vcat(fill(onehot(1, 1:2), size(x_apples)),
          fill(onehot(2, 1:2), size(x_bananas)))

# NOTE: Flux.batch turns your input vector of features into a matrix
# improved speed w/ matrix multiplication

# NOTE: Interators.repeated()
# model = Chain(Dense(2, 4, σ), Dense(4, 3, identity), softmax)
