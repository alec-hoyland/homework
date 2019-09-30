# navigate to the directory
cd("/home/alec/code/homework/CAS-CS-640/programming1/")
include("nnet.jl")

using CSV
using DataFrames
using Statistics
using LinearAlgebra

X = CSV.File("data/dataset1/LinearX.csv", header = false) |> DataFrame |> Matrix
Y = CSV.File("data/dataset1/LinearY.csv", header = false) |> DataFrame |> Matrix

nn = NeuralNetwork([2, 100, 1])

nSamples = size(X, 1)
for ii = 1:nSamples
    train!(nn,X[rand(1:nSamples),:], Y[rand(1:nSamples),:])
end
