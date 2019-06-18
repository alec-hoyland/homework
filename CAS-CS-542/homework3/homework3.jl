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

using LinearAlgebra
# using JuMP
using NPZ
using StatsBase
using NLopt
using Plotly

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

#%% ### Step 2: Building the Neural Network
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

function autoencoder(theta::Vector{T}, visiblesize, hiddensize, data::Array{T, 2}, grad::Vector{T};
            λ::T = 0.0, ρ::T = 0.01, β::T = 0.0) where T <: Real
    # store the parameters
    W1, W2, b1, b2 = unravel(theta, visiblesize, hiddensize)
    # other useful variables
    m = size(data, 2)

    # perform the first pass encoding
    a1 = data
    z2 = W1 * a1 .+ b1
    a2 = σ.(z2)
    z3 = W2 * a2 .+ b2
    a3 = σ.(z3)
    output = a3

    average_hidden_activity = mean(a2)
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
        grad[1:visiblesize*hiddensize] = (d2*a1'/m + λ*W1) |> vec
        grad[visiblesize*hiddensize+1:2*visiblesize*hiddensize] = (d3*a2'/m + λ*W2) |> vec
        grad[2*visiblesize*hiddensize+1:2*hiddensize*visiblesize+hiddensize] = (sum(d2, dims=2)/m) |> vec
        grad[2*hiddensize*visiblesize+hiddensize+1:end] = (sum(d3, dims=2)/m) |> vec
    end
    return cost, grad
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

#%% ### Step 3: Testing
#%% We will test the gradient function to make sure that it's working correctly.

function testGradient()

    # read the data
    images = npzread("images.npy")
    traindata = Array{Float64, 2}(undef, 64, 100)
    samples = sampleImages(images)

    # parameters
    hidden = 25;
    visible = 64;
    λ = 1e-4;
    β = 3.0;
    ρ = 0.01;
    theta = 0.1 * randn(2*hidden*visible + hidden + visible)

    function justcost(x)
        cost, grad = autoencoder(x, visible, hidden, traindata, zeros(size(theta)), λ=λ, ρ=ρ, β=β)
        return cost
    end

    # compute the cost and gradient
    cost, grad = autoencoder(theta, visible, hidden, traindata, zeros(size(theta)), λ=λ, ρ=ρ, β=β)
    # compute the gradient using the numerical scheme
    grad_num = computeNumericalGradient(justcost, theta)
    # compute the normalized difference, 0 => perfect
    diff = norm(grad_num - grad) / norm(grad_num + grad)^2

    return diff, grad, grad_num
end

diff, grad, grad_num = testGradient()

#%% In the test of the gradient, we should expect the normalized difference to be close to zero.
#%% As our parameter ``\epsilon`` decreases, we should see convergence in accuracy.
#%% Since both of our schemes are numerical here, we just hope for decent accordance between the methods.
#%% This will tell us that our backpropagation is working.

#%% ### Step 4: Using the algorithm

function initialize(hiddensize, visiblesize)
    r = sqrt(6) / sqrt(hiddensize+visiblesize+1)
    W1 = rand(hiddensize,visiblesize)*2*r .- r
    W2 = rand(visiblesize,hiddensize)*2*r .- r
    b1 = zeros(hiddensize)
    b2 = zeros(visiblesize)
    return vcat(W1[:],W2[:],b1,b2)
end

function autoencode(data, hiddensize, visiblesize; λ=1e-4, β=3.0, ρ=0.01, maxiter=400)
    theta::Vector{Float64} = initialize(hiddensize,visiblesize)
    count = 0

    function objective(x,grad)
        count += 1
        println("iteration $count")
        return autoencoder(x, visible, hidden, traindata, grad, λ=λ, ρ=ρ, β=β)
    end

    opt = Opt(:LD_LBFGS,length(theta))

    min_objective!(opt, objective)
    maxeval!(opt, maxiter)
    minf, minx, ret = optimize(opt, theta)

    W1 = reshape(minx[1:hiddensize*visiblesize],hiddensize,visiblesize)
    W2 = reshape(minx[hiddensize*visiblesize+1:2*hiddensize*visiblesize],visiblesize,hiddensize)
    b1 = minx[2*hiddensize*visiblesize+1:2*hiddensize*visiblesize+hiddensize]
    b2 = minx[2*hiddensize*visiblesize+hiddensize+1:end]

    return minf, W1, W2, b1, b2
end

function main()
    # load the data
    images = npzread("images.npy")
    traindata = sampleImages(images)

    # useful parameters
    hiddensize = 25
    visiblesize = 64
    λ = 1e-4
    β = 3.0
    ρ = 0.01

    f,W1,W2,b1,b2 = autoencode(traindata,hiddensize,visiblesize)
    # displaynetwork(W1', "hw3-autoencoder")
end

# The following function was copied from kjchavez on GitHub
# https://github.com/kjchavez/deep-learning-julia/blob/master/autoencoder/sparse-autoencoder-tutorial.jl#L90

function displaynetwork(A,filename)
        m,n = size(A)
        sz = Int(sqrt(m))
        A = A .- mean(A)
        layout = [
            "autosize" => false,
            "width" => 500,
            "height"=> 500
        ]

        gridsize = Int(ceil(sqrt(n)))
        buffer = 1
        griddata = ones(gridsize*(sz+1)+1,gridsize*(sz+1)+1)
        index = 1
        for i = 1:gridsize
                for j = 1:gridsize
                        if index > n
                                continue
                        end
                        columnlimit = maximum(abs.(A[:,index]))
                        griddata[buffer+(i-1)*(sz+buffer).+(1:sz),buffer.+(j-1)*(sz.+buffer).+(1:sz)] = reshape(A[:,index],sz,sz)/columnlimit
                        index += 1
                end
        end

        data = [
          [
            "z" => griddata,
            "colorscale" => "Greys",
            "type" => "heatmap"
          ]
        ]
        response = Plotly.plot(data, ["layout" => layout, "filename" => filename, "fileopt" => "overwrite"])
        plot_url = response["url"]
end

# Run it!
main()
