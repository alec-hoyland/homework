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

function distance(a::AbstractVector{T}, b::AbstractVector{T}) where T <: Number
    d = 0;
    for ii = 1:length(a)
        d = d + (a[ii] - b[ii])^2;
    end
    return sqrt(d)
end

function distance(a::AbstractVector{T}, b::AbstractVector{T}) where T <: String
    d = 0;
    for ii = 1:length(a)
        if a[ii] != b[ii]
            d = d + 1;
        end
    end
    return sqrt(d)
end

df = impute_missing_data!(df);
df = normalize_features!(df);
