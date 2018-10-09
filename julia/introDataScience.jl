## Julia for Data Science

# download the data
cd("/home/alec/code/homework/julia/")
P = download("https://raw.githubusercontent.com/nassarhuda/easy_data/master/programming_languages.csv", "programming_languages.csv")

# read the data
using CSV, DataFrames
P = CSV.File("programming_languages.csv", header=true) |> DataFrame
# can also used DelimitedFiles.readdlm()

# when was language X created?
function language_created_year(P::DataFrame, language::String)
    loc = findfirst(P[2] .== language)
    return P[loc,1]
end

# what year was Julia created?
language_created_year(P, "Julia")

# create a more robust function that handles cases

function language_created_year_v2(P::DataFrame, language::String)
    loc = findfirst(lowercase.(P[2]) .== lowercase.(language))
    return P[loc, 1]
end

language_created_year_v2(P, "Julia") == language_created_year_v2(P, "julia")

# write to a file
using DelimitedFiles
writedlm("programming_languages_data.txt", Matrix(P), '-')
P2 = readdlm("programming_languages_data.txt", '-') |> DataFrame
P == P

# store the data in a Dictionary
dict = Dict{Integer, Vector{String}}()

for i = 1:size(Matrix(P),1)
    year,lang = Matrix(P[i,:])
    if year in keys(dict)
        dict[year] = push!(dict[year],lang)
    else
        dict[year] = [lang]
    end
end

# what programming languages were developed in 2003
dict[2003] # do it as a dictionary
using DataFramesMeta
@linq P |> where(:year .== 2003) |> select(pl03 = :year, :language)

## Algorithms in Data Science
using DataFrames, Plots, CSV; pyplot()

# load the data
download("http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv","houses.csv")
houses = CSV.read("houses.csv")

# visualize the data
scatter(houses[:sq__ft], houses[:price], markersize=3)

# filter a data frame by feature value
using Statistics
by(houses[houses[:sq__ft] .> 0, :], :type, size)
by(houses[houses[:sq__ft] .> 0, :], :type, x -> mean(x[:price]))

# k-means clustering
using Clustering
df  = houses[houses[:sq__ft] .> 0, :]; # remove entries where the square-footage is zero
X   = permutedims(convert(Array{Float64}, df[[:latitude, :longitude]]))
k   = length(unique(df[:zip]))
C   = kmeans(X, k)
