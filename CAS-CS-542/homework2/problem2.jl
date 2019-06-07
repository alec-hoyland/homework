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
using Combinatorics

## Define the KNN algorithm

function impute_missing_data!(df)
    # iterate through the columns of the data frame
    # if the element type of the column is numerical, replace the missing values with the mean of the positives
    # if the element type of the column is not, replace the missing values with the mode of the positives
    for n in names(df)
        if Base.nonmissingtype(eltype(df[n])) <: Number
            # force conversion to Float64 type for numerical data
            df[n] = df[n] .* float(1);
            df[n] = coalesce.(df[n], mean(skipmissing(df[df[:Column16] .== "+", n])));
        elseif Base.nonmissingtype(eltype(df[n])) <: String
            df[n] = coalesce.(df[n], mode(skipmissing(df[df[:Column16] .== "+", n])));
        else
            df[n] = map(char -> convert(String, char), df[n])
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
    # computes the distance metric between points a and b

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

function distancesFrom(testPoint, trainingData::DataFrame)
    dist = zeros(size(trainingData, 1))
    for i in size(trainingData, 1)
        dist[i] = distance(testPoint, trainingData[i, :])
    end
    return dist
end

function predict(testPoint, trainingData::DataFrame, k)
    sortedNeighbors = sortperm(distancesFrom(testPoint, trainingData));
    return sortedNeighbors[1:k]
end

function assign_label(testPoint, trainingData::DataFrame, k, labels)
    kNearestNeighbors = predict(testPoint, trainingData, k)
    counts = Dict{String, Int}()
    highestCount = 0
    mostPopularLabel = ""
    for n in kNearestNeighbors
        labelOfN = labels[n]
        if !haskey(counts, labelOfN)
            counts[labelOfN] = 0
        end
        counts[labelOfN] += 1
        if counts[labelOfN] > highestCount
            highestCount = counts[labelOfN]
            mostPopularLabel = labelOfN
        end
    end
    return mostPopularLabel
end

## Set up the training dataset

# load the data into a Data Frame
trainingData = CSV.File("data/crx.data.training", header = false, missingstring = "?") |> DataFrame;
# make the data pretty
impute_missing_data!(trainingData);
normalize_features!(trainingData);

@show first(trainingData, 6)

## Load the testing data

testingData = CSV.File("data/crx.data.testing", header = false, missingstring = "?") |> DataFrame;
impute_missing_data!(testingData);
normalize_features!(testingData);
@show first(testingData, 6)

## Testing the algorithm

predictedLabels = fill("-", size(testingData, 1))
actualLabels = testingData[:, 16]
accuracy = zeros(3);
k = [3, 10, 23]
for (i, k) in enumerate(k)
    for j = 1:size(testingData, 1)
        predictedLabels[j] = assign_label(testingData[j, 1:15], trainingData[:, 1:15], k, trainingData[:, 16])
    end
    accuracy[i] = sum(predictedLabels .== actualLabels) / length(predictedLabels)
end

#%% ## Results
#%% I tested the dataset for three values of the hyperparameter `k`,

@show DataFrame(k=k, accuracy=accuracy)

#%% and see that ``k=23`` provides the best accuracy on the dataset for the values tested.
#%% Here, accuracy is the fraction of the correct labeling,
#%% given the known labels of the testing set.

#%% ## Using the algorithm on a new dataset
#%% I applied the k-nearest-neighbors algorithm to the `lenses` dataset.

testingData = CSV.File("data/lenses.testing", header = false, missingstring = "?") |> DataFrame;
trainingData = CSV.File("data/lenses.training", header = false, missingstring = "?") |> DataFrame;

function makeCategorical!(df::DataFrame)
    for n in names(df)
        df[n] = map(string, df[n])
    end
    return df
end

makeCategorical!(testingData)
makeCategorical!(trainingData)

predictedLabels = fill("1", size(testingData, 1))
actualLabels = testingData[:, 5]
k = [3, 4, 10]
accuracy = zeros(3)
for (i, k) in enumerate(k)
    for j = 1:size(testingData, 1)
        predictedLabels[j] = assign_label(testingData[j, 1:4], trainingData[:, 1:4], k, trainingData[:, 5])
    end
    accuracy[i] = sum(predictedLabels .== actualLabels) / length(predictedLabels)
end

#%% I tested the dataset for three values of the hyperparameter `k`,

@show DataFrame(k=k, accuracy=accuracy)

#%% and see that ``k=10`` provides the best accuracy on the dataset for the values tested.
#%% Here, accuracy is the fraction of the correct labeling,
#%% given the known labels of the testing set.
