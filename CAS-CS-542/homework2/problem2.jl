#%% ---
#%% title : Homework #2, Problem 2
#%% author: Alec Hoyland
#%% data : 2019-06-05
#%% options :
#%%     doctype: md2html
#%% ---


#%% Processing the dataset
#%% We will load the dataset into a Data Frame,
#%% then clean it, by replacing missing values with the mode for categorical variables,
#%% and the mean for numerical variables.

cd("/home/alec/code/homework/CAS-CS-542/homework2/")

# preamble
using DataFrames
using CSV
using StatsBase

# load the data into a Data Frame
df = CSV.File("data/crx.data.training", header = false, missingstring = "?") |> DataFrame;

@show df

function impute_missing_data!(df)
    # iterate through the columns of the data frame
    # if the element type of the column is numerical, replace the missing values with the mean of the positives
    # if the element type of the column is not, replace the missing values with the mode of the positives
    for n in names(df)
        if Base.nonmissingtype(eltype(df[n])) <: Number
            # force conversion to Float64 type for numerical data
            df[n] = df[n] .* float(1);
            df[n] = coalesce.(df[n], mean(skipmissing(df[df[:Column16] .== "+", n])));
        else
            df[n] = coalesce.(df[n], mode(skipmissing(df[df[:Column16] .== "+", n])));
        end
    end
    return df
end

function normalize_features!(df)
    # if a feature (a column of the data frame) is numerical
    # normalize it by replacing with the z-scored value
    for n in names(df)
        if Base.nonmissingtype(eltype(df[n])) <: Number
            df[n] .= zscore(df[n])
        end
    end
    return df
end

function distance(a, b)

    function point_dist(a::T, b::T) where T <: Number
        return d = (a-b)^2
    end

    function point_dist(a::T, b::T) where T <: String
        if a == b
            d = 0
        else
            d = 1
        end
        return d
    end

    d = 0
    for i = 1:length(a)
        d += point_dist(a[i], b[i])
    end
    return sqrt(d)
end

function majority_vote(labels::Vector)
    counts = countmap(labels)
    res = labels[1]
    max_value = -1
    for (k, v) in counts
        if v > max_value
            res, max_value = k, v
        end
    end
    return res
end

function predict(training, testing, k=5)
    # output vector
    predictedLabels = String[]
    # compute the distance between each high-dimensional point
    for i = 1:size(testing, 1)
        sourcePoint = testing[i, :]
        distances = Float64[]
        for j in 1:size(training, 1)-1
            destPoint = training[j, :]
            dist = distance(sourcePoint, destPoint)
            push!(distances, dist)
        end
        # sort the candidates
        candidates = training[sortperm(distances)[1:k]]
        predictedLabel = skim(candidates)
        # append the best guess
        push!(predictedLabels, predictedLabel)
    end
    return predictedLabels
end

df = impute_missing_data!(df);
df = normalize_features!(df);

function get_all_distances(imageI::AbstractArray, x::AbstractArray)
    diff = imageI .- x
    distances = vec(sum(diff .* diff,1))
end

function get_k_nearest_neighbors(x::AbstractArray, imageI::AbstractArray, k::Int = 3, train = true)
    nRows, nCols = size(x)
    distances = get_all_distances(imageI, x)
    sortedNeighbors = sortperm(distances)
    if train
        return kNearestNeighbors = Array(sortedNeighbors[2:k+1])
    else
        return kNearestNeighbors = Array(sortedNeighbors[1:k])
    end
end

function assign_label(x::AbstractArray, y::AbstractArray{Int64}, imageI::AbstractArray, k, train::Bool)
    kNearestNeighbors = get_k_nearest_neighbors(x, imageI, k, train)
    counts = Dict{Int, Int}()
    highestCount = 0
    mostPopularLabel = 0
    for n in kNearestNeighbors
        labelOfN = y[n]
        if !haskey(counts, labelOfN)
            counts[labelOfN] = 0
        end
        counts[labelOfN] += 1
        if counts[labelOfN] > highestCount
            highestCount = counts[labelOfN]
            mostPopularLabel = labelOfN
        end
     end
    mostPopularLabel
end
