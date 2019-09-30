# implement a one-layer neural network
# with backpropagation learning from scratch
# with regulatarization

function σ(x)
    sigma = 1 / (1 + exp(-x))
    return sigma
end

function σ′(x)
    sigma = σ(x)
    return sigma * (1 - sigma)
end

# the network consists of an input layer (layer 1)
# a hidden layer (layer 2)
# and an output layer (layer 3)

# create the network

mutable struct NeuralNetwork
    structure
    weights
    biases
    learning_rate
end

function NeuralNetwork(structure)
    # initialize the neural network with randomized parameters
    weights = Array{Array{Float64, 2}, 1}()
    biases = Array{Array{Float64, 1}, 1}()
    push!(weights, 0.1 * randn(structure[1], structure[2]))
    push!(weights, 0.1 * randn(structure[2], structure[3]))
    push!(biases, 0.1 * randn(structure[2]))
    push!(biases, 0.1 * randn(structure[3]))
    return NeuralNetwork(structure, weights, biases, 0.1)
end

# forward propagation
function forward(nn::NeuralNetwork)
    ai = σ(X)
    zj = transpose(weights_ij) * ai + bj
    aj = σ(zj)
    zk = transpose(weights_jk) * aj + bk
    ak = σ(zk)
    return (ai, zj, aj, zk, ak)
end

# backward propagation
function backward(nn::NeuralNetwork, target, ai, zj, aj, zk, ak)
    gradient_ij = zeros(nn.structure[1], nn.structure[2])
    gradient_jk = zeros(nn.structure[2], nn.structure[3])
    δj = zeros(nn.structure[2], 1)
    δk = zeros(nn.structure[3], 1)

    # compute gradient of the error w.r.t. the output layer parameters
    for k in 1:nn.structure[3]
        δk[k] = delta_k(ak[k], target[k], zk[k])
    end

    for j in 1:nn.structure[2], k in 1:nn.structure[3]
        gradient_jk[j, k] = δk[k] * aj[j]
    end

    # compute the gradient of the error w.r.t. the hidden layer parameteers
    for j in 1:nn.structure[2]
        δj[j] = delta_j(zj[j], δk, nn.weights[2][j, :])
    end

    for i in 1:nn.structure[1], j in 1:nn.structure[2]
        gradient_ij[i, j] = δj[j] * ai[i]
    end

    return (gradient_ij, gradient_jk, δj, δk)
end

function update_params!(params, gradient, learning_rate)
    return params - learning_rate * gradient
end

function update_params!(nn::NeuralNetwork, learning_rate, gradient_ij, gradient_jk, δj, δk)
    update_params!(nn.weights[1], gradient_ij, learning_rate)
    update_params!(nn.weights[2], gradient_jk, learning_rate)
    update_params!(nn.biases[1], δj, learning_rate)
    update_params!(nn.biases[2], δk, learning_rate)
end

function cost(predictions, targets)
    # L2 norm error
    return 0.5 * norm(predictions - targets, 2)
end

function delta_k(prediction, target, z)
    # all evaluated at index k
    return (prediction - target) * σ′(z)
end

function delta_j(zj, δk, weights_jk)
    return σ′(zj) * dot(δk, weights_jk)
end
