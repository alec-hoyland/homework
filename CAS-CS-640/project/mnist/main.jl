## Preamble

using Flux, Flux.Data.MNIST, Statistics
using Flux: onehotbatch, onecold, crossentropy, throttle
using Base.Iterators: repeated, partition
using Printf, BSON

## Fully-connected neural network

function loss(model, x, y)


model = Chain(
    Dense(28^2, 32, relu),
    Dense(32, 10),
    softmax)

loss(x, y) = crossentropy(model(x), y)
accuracy(x, y) = mean(onecold(model(x) .== onecold(y)))
