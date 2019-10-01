# navigate to the directory
cd("/home/alec/code/homework/CAS-CS-640/programming1/")
# include("nnet.jl")
include("nnet2.jl")

using CSV
using DataFrames
using Statistics
using LinearAlgebra

X = CSV.File("data/dataset1/LinearX.csv", header = false) |> DataFrame |> Matrix
Y = CSV.File("data/dataset1/LinearY.csv", header = false) |> DataFrame |> Matrix

# nn = NeuralNetwork([2, 100, 1])
#
# nIters = 10;
# nSamples = size(X, 1)
# for ii = 1:nIters * nSamples
#     train!(nn,X[rand(1:nSamples),:], Y[rand(1:nSamples),:])
# end


net = init_network([2, 3, 2])

# To train the network use the form `train(network, input, output)`:
train(net, [0.15, 0.7],[0.1, 0.9])

# To evaluate an input use the form `net_eval(network, inputs)`
net_eval(net, [0.15, 0.7])
