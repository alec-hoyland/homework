#%% ---
#%% title : Homework 4
#%% author: Alec Hoyland
#%% date : 2019-06-28
#%% options :
#%%     doctype: md2pdf
#%% ---

#%% The algorithm will always converge to a local minimum,
#%% but there is no guarantee of global convergence.
#%% 

cd("/home/alec/code/homework/CAS-CS-542/homework4/")

using FileIO, Images

img = load("Bayes_noisy.png")

getPixelValues(img) = unique(gray.(img))

function findNeighbors(x::AbstractArray{T, 2}, i::Int, j::Int) where T
    sz = size(x) .+ 1
    x_limit = (0, sz[1])
    y_limit = (0, sz[2])

    possible_neighbors = [(i, j+1), (i, j-1), (i+1, j), (i-1, j)]
    neighbors = typeof(possible_neighbors)()

    for testpoint in possible_neighbors
        if testpoint[1] in x_limit
            continue
        end
        if testpoint[2] in y_limit
            continue
        end
        push!(neighbors, testpoint)
    end

    return neighbors
end

function energy(x, y; h=0, β=0, η=0)
    E = 0
    img = gray.(x)
    # pixel preference term
    E += h * sum(img)
    # neighbor similarity term
    sz = size(img)
    for i in 1:sz[1], j in 1:sz[2]
        neighbors, testpoint = findNeighbors(img, i, j)
        for n in neighbors
            E += β * img[i, j] * img[n...]
        end
    end
    # encourage flipping term
    for i in 1:sz[1], j in 1:sz[2]
        E += η * img[i, j] * y[i, j]
    end
    return E
end
