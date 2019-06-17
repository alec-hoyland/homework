#%% ---
#%% title : Homework 3
#%% author: Alec Hoyland
#%% data : 2019-06-17
#%% options :
#%%     doctype: md2pdf
#%% ---

#%% ## Introduction
#%% We implement a sparse autoencoder, a neural network designed to learn data representations.
#%% The representations here will be mostly sparse.

cd("/home/alec/code/homework/CAS-CS-542/homework3/")

#%% ### Step 1: Generate Training Data

using NPZ
using StatsBase

images = npzread("images.npy")

function sampleImages(images, n=10000; patch_size=8)
    # output matrix
    samples = zeros(eltype(images), n, patch_size^2)
    #  useful variables
    img_x, img_y, img_z = size(images)
    patch_lim = img_x - patch_size + 1;
    for i in 1:n
        rand_image = rand(1:img_z)
        rand_patch = rand(1:patch_lim)
        patch_vec = rand_patch:rand_patch+patch_size-1
        samples[i, :] = vec(images[patch_vec, patch_vec, rand_image])
    end
    return samples
end

function normalizeData!(x)
    # squash data to [0.1, 0.9]
    x -= mean(x)
    # truncate to 3 standard deviations and normalize
    pstd = 3 * std(x)
    max(min(x, pstd))/pstd

    # rescale from [-1, 1] to [0.1, 0.9]
    x = (x + 1) * 0.4 + 0.1
    return x
end

#%% ### Building the Neural Network
#%% I'm going to try to do this in Julia, which is the language I am familiar with.
#%% So we will see how that goes. Unfortunately for this assignment,
#%% it means that I am going to have to write a lot of my own code,
#%% rather than relying on the TFs to do it for me.

#%% Furthermore, I am going to try to write all of my own code,
#%% rather than use a machine learning package like Flux,
#%% since Julia supports extremely robust autodifferentiation for gradient computation
#%% and that's cheating for this assignment.

#%% My first step is to implement the sigmoid function.

σ(z) = 1 / (1 + exp(-z))

#%% Then, I will build the main autoencoder cost function...after I add some helper functions.

#%% This function reshapes the parameters into their matrix form,
#%% rather than wrapped up in a single vector.
#%% I think of the vector as the "wound up" form, so this function is called `unravel`.

function unravel(theta::Vector{T}, visiblesize, hiddensize) where T
    W1 = reshape(theta[1:hiddensize*visiblesize],hiddensize,visiblesize)
    W2 = reshape(theta[hiddensize*visiblesize+1:2*hiddensize*visiblesize],visiblesize,hiddensize)
    b1 = theta[2*hiddensize*visiblesize+1:2*hiddensize*visiblesize+hiddensize]
    b2 = theta[2*hiddensize*visiblesize+hiddensize+1:end]
    return W1, W2, b1, b2
end

#%% Here is the sparsity cost, computed using the formula from the supporting pdf.

function sparsityCost(ρ, average_hidden_activity)
    return sum(ρ*log(ρ/average_hidden_activity) + (1 - ρ)*log((1-ρ)/(1-average_hidden_activity)))
end

#%% This function is type-stable, and will be called a lot, so I wrote it out explicitly.

function pnp(p)
    # computes p * (1 - p)
    return p * (one(p) - p)
end

#%% Here is the autoencoder function. The indexing is a little clumsy,
#%% and that's what I would refactor first if I were to rewrite this.
#%% I decided to keep it as is for now because this is my first time building
#%% a neural network, and I wanted to see exactly how the matrices are composed (and decomposed).
#%% Though I know that the [Flux](https://fluxml.ai/) package in particular has great tools for this.

function autoencoderCost(theta::Vector{T}, visiblesize, hiddensize, data::Array{T, 2}, grad::Vector{T},
            λ::T = 0.0, ρ::T = 0.01, β::T = 0.0) where T <: Real
    # store the parameters
    W1, W2, b1, b2 = unravel(theta, visiblesize, hiddensize)
    # other useful variables
    m= size(data, 2)

    # perform the first pass encoding
    a1 = data
    z2 = W1 * a1 .+ b1
    a2 = σ(z2)
    z3 = W2 * a2 .+ b2
    a3 = σ(z3)
    output = a3

    average_hidden_activity = mean(a2, 2)
    sparsity_cost = sparsityCost(ρ, average_hidden_activity)
    least_squares_cost = sum((output - data).^2) / (2 * m)
    regularization_cost = 1 / 2 * sum(theta[1:2*hiddensize*visiblesize].^2)
    # compute the total cost as the sum of the others
    cost = least_squares_cost + ρ * sparsity_cost + λ * regularization_cost

    if length(grad) > 0
        # use back-propagation
        a3′ = pnp.(a3)
        a2′ = pnp.(a2)

        # do a Kullback-Leibler kinda thing
        sparsity_term = β * (-ρ / average_hidden_activity + (1 - ρ)/(1 - average_hidden_activity))

        # backpropagate
        d3 = -(data - a3) .* a3′
        d2 = (W2' * d3 .+ sparsity_term) .* a2′

        # build the gradient vector
        grad[1:visiblesize*hiddensize] = (d2*a1'/m + lambda*W1) |> vec
        grad[visiblesize*hiddensize+1:2*visiblesize*hiddensize] = (d3*a2'/m + lambda*W2) |> vec
        grad[2*visiblesize*hiddensize+1:2*hiddensize*visiblesize+hiddensize] = (sum(d2,2)/m) |> vec
        grad[2*hiddensize*visiblesize+hiddensize+1:end] = (sum(d3,2)/m) |> vec
    end
    return cost
end

#%% The numerical gradient is computed with some small parameter ``\epsilon``
#%% to avoid divide-by-zero errors.
#%% The gradient is computed using a finite center-difference approximation.

function computeNumericalGradient(f, x::Vector{T}) where T <: Real
    ϵ = 1e-4
    # output vector
    g = zeros(length(x))

    for i = 1:length(x)
        x[i] += ϵ
        fp = f(x)
        x[i] -= 2*ϵ
        fm = f(x)
        g[i] = (fp - fm)/(2ϵ)
        x[i] += ϵ
    end

    return g
end
