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

## MNIST handwriting recognition

using Flux, Flux.Data.MNIST, Images

labels = MNIST.labels();
images = MNIST.images();

# explore the data

# what data type are the images?
typeof(images[1])

# find the number of inputs (how many images are there?)
n_inputs = unique(length.(images))[]

# find the number of outputs (how many outputs are there?)
n_outputs = length(unique(labels))

# create the features to pass to the neural network
preprocess(img) = vec(Float64.(img))

# create batched matrices for efficiency
function create_batch(r)
    # use a subset of the images in a single batch
    xs = [preprocess(img) for img in images[r]]
    # create the labels corresponding to the images used
    ys = [Flux.onehot(label, 0:9) for label in labels[r]]
    return (Flux.batch(xs), Flux.batch(ys))
end

training_batch = create_batch(1:5000)

# setting up the neural network

# one layer with a softmax output
model = Chain(Dense(n_inputs, n_outputs, identity), softmax)
# use the crossentropy of the model output and the supplied label
L(x, y) = Flux.crossentropy(model(x), y)

# testing the neural network
@time Flux.train!(L, params(model), [training_batch], Descent(0.01))
# inspect the loss
L(training_batch...)

# train repeatedly, using callbacks to watch the loss
callback() = @show(L(training_batch...))
Flux.train!(L, params(model), Iterators.repeated(training_batch, 3), Descent(0.01), cb = callback)

# throttle the callback to display only 1/second
Flux.train!(L, params(model), Iterators.repeated(training_batch, 40), Descent(0.01), cb = Flux.throttle(callback, 1))

# test on novel data as well
testing_batch = create_batch(5001:10000)

using Printf
training_loss = Float64[]
testing_loss = Float64[]

# callback function to print the loss from both the training and testing data
function update_loss!()
    push!(training_loss, L(training_batch...).data)
    push!(testing_loss, L(testing_batch...).data)
    @printf("training loss = %.2f, testing loss = %.2f\n", training_loss[end], testing_loss[end])
end

# train the model and output the loss for the trained and tested data at each step
Flux.train!(L, params(model), Iterators.repeated(training_batch, 1000), Descent(0.01), cb = Flux.throttle(update_loss!, 1))
