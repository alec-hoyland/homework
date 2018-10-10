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
using DataFrames, Plots, CSV; gr()

# load the data
# download("http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv","houses.csv")
houses = CSV.read("/home/ahoyland/code/homework/julia/houses.csv")

# visualize the data
scatter(houses[:sq__ft], houses[:price], markersize=3)

# filter a data frame by feature value
using Statistics
by(houses[houses[:sq__ft] .> 0, :], :type, size)
by(houses[houses[:sq__ft] .> 0, :], :type, x -> mean(x[:price]))

# k-means clustering
using Clustering
df  = houses[houses[:sq__ft] .> 0, :]; # remove entries where the square-footage is zero
# perform the clustering
X   = permutedims(convert(Array{Float64}, df[[:latitude, :longitude]]))
k   = length(unique(df[:zip]))
C   = kmeans(X, k)
# add the clustering to the data frame
insert!(df, ncol(df)+1, C.assignments, :cluster)

# plot the cluster in different colors
clusters_figure = plot()
for i in 1:k
    clustered_houses = df[df[:cluster] .== i, :]
    xvals = clustered_houses[:latitude]
    yvals = clustered_houses[:longitude]
    scatter!(clusters_figure, xvals, yvals, markersize=4)
end
xlabel!("Latitude")
ylabel!("Longitude")
title!("Houses color-coded by cluster")
display(clusters_figure)

unique_zips = unique(df[:zip])
zips_figure = plot()
for uzip in unique_zips
    subs = df[df[:zip].==uzip,:]
    x = subs[:latitude]
    y = subs[:longitude]
    scatter!(zips_figure,x,y)
end
xlabel!("Latitude")
ylabel!("Longitude")
title!("Houses color-coded by zip code")
display(zips_figure)

plot(clusters_figure,zips_figure,layout=(2, 1))

## Nearest Neighbor with a KDTree
using NearestNeighbors

# nearest neighbors of one house
knearest        = 10
id              = 70
point           = X[:,id]

# build the KDTree
kdtree          = KDTree(X)
idxs, dists     = knn(kdtree, point, knearest, true)

# generate a plot with all of the houses in the same color
x               = df[:latitude]
y               = df[:longitude]
scatter(x,y)

# overlay data corresponding to the nearest neighbors of point
x               = df[idxs, :latitude]
y               = df[idxs, :longitude]
scatter!(x,y)

## PCA for Dimensionality Reduction
F               = df[[:sq__ft, :price]]
F               = permutedims(convert(Array{Float64, 2}, F))

scatter(F[1,:], F[2,:])
xlabel!("Square footage")
ylabel!("Housing Prices")

using MultivariateStats

# perform dimensionality-reduction with PCA
M               = fit(PCA, F)
# map the 2-D data in F onto 1-D data with our model M
y               = MultivariateStats.transform(M, F)
# reconstruct to put the 1-D data, y, in a form that can be overlaid
Xr              = reconstruct(M, y)

scatter(F[1,:], F[2,:])
scatter!(Xr[1,:], Xr[2,:])

## Build a Simple Multi-Layer Perceptron on the MNIST Dataset

using Flux, Flux.Data.MNIST
using Flux: onehotbatch, argmax, crossentropy, throttle
using Base.Iterators: repeated

# fetch images from the MNIST dataset
imgs            = MNIST.images()
# take a look at one of them
imgs[3]
typeof(imgs[3])

# convert into floating point numbers
fpt_imgs        = float.(imgs)
# take a look at one of them
fpt_imgs[3]
typeof(fpt_imgs[3])

# unravel each image, creating a 1-D array of floats
unraveled       = reshape.(fpt_imgs, :)
unraveled[3]
typeof(unraveled)

# build a matrix where the vectors become columns
# ... is the `splat` command, meaning pass each element as a new argument
X               = hcat(unraveled...)

# how to go back to images
onefigure       = X[:, 2]
t1              = reshape(onefigure, 28, 28)
using Images
colorview(Gray, t1)

# train the data using the true labels
labels          = MNIST.labels()
# one-hot-encode labels
Y               = onehotbatch(labels, 0:9)
# build the network
m               = Chain(Dense(28^2, relu),
                    Dense(32, 10),
                    softmax)
# define the loss functions and accuracy
loss(x, y)      = Flux.crossentropy(m(x), y)
accuracy(x, y)  = mean(argmax(m(x)) .== argmax(m(y)))

# create our training data and declare the evaluation function
dataset         = repeated((X, Y), 200)
evalcb          = () -> @show (loss(X, Y))
opt             = ADAM(Flux.params(m))

# train the model and look at the accuracy thereafter
Flux.train!(loss, dataset, opt, cb = throttle(evalcb, 10))
accuracy(X, Y)

# create test data
tX              = hcat(float.(reshape.(MNIST.images(:test), :))...)
test_image      = m(tX[:, 1])
indmax(test_image)-1

# look at the original test image
using Images
t1 = reshape(tX[:,1],28,28)
colorview(Gray, t1)

## Linear Regression in Julia
using Plots; gr()
using Statistics

xvals       = repeat(1:0.5:10, inner=2)
yvals       = 3 .+ xvals + 2rand(length(xvals))
scatter(xvals, yvals, color = :black, legend = false)

# write a function in Julia to find the best fit
function find_best_fit(xvals, yvals)

    meanx   = mean(xvals)
    meany   = mean(yvals)
    stdx    = std(xvals)
    stdy    = std(yvals)
    r       = cor(xvals, yvals)
    a       = r * stdy / stdx
    b       = meany - a*meanx
    return a, b
end

a, b = find_best_fit(xvals, yvals)
ŷ = a * xvals .+ b

plot!(xvals, ŷ)

## Plot using LaTeX Annotation
using LaTeXStrings, Plots; pyplot()

x       = 1:0.2:4
x2      = L"x^2"
logx    = L"log(x)"
sqrtx   = L"\sqrt{x}"

y1 = sqrt.(x)
y2 = log.(x)
y3 = x.^2

f1 = plot(x,y1,legend = false)
plot!(f1, x,y2) # "plot!" means "plot on the same canvas we just plotted on"
plot!(f1, x,y3)
title!("Plot $x2 vs. $logx vs. $sqrtx")
annotate!(f1,[(x[6],y1[6],text(sqrtx,16,:center)),
          (x[11],y2[11],text(logx,:right,16)),
          (x[6],y3[6],text(x2,16))])

## Statistics Plots
using DataFrames, CSV, StatPlots

# plot a simple two-dimensional histogram
n       = 1000
set1    = randn(n)
set2    = randn(n)
histogram2d(set1, set2, nbins=20, colorbar=true)

# return to the `houses` dataset
houses  = CSV.File("/home/ahoyland/code/homework/julia/houses.csv") |> DataFrame
df      = houses[houses[:sq__ft] .> 0, :]
x       = df[:sq__ft]
y       = df[:price]
gh      = histogram2d(x, y, nbins=20, colorbar=true)
xaxis!(gh, "square feet")
yaxis!(gh, "price")

y       = rand(10000, 6)
f2      = violin(["Series 1" "Series 2" "Series 3" "Series 4" "Series 5"], y, legend=false, color = :red)

boxplot!(["Series 1" "Series 2" "Series 3" "Series 4" "Series 5"],y,leg=false,color=:green)

some_cities = ["SACRAMENTO","RANCHO CORDOVA","RIO LINDA","CITRUS HEIGHTS","NORTH HIGHLANDS","ANTELOPE","ELK GROVE","ELVERTA" ]

fh = plot(xrotation=90)
for ucity in some_cities
    subs = df[df[:city].==ucity,:]
    city_prices = subs[:price]
    violin!(fh,[ucity],city_prices,leg=false)
end
display(fh)

# subplots!
mylayout = @layout([a{0.5h};[b{0.7w} c]])
plot(fh,f2,gh,layout=mylayout,legend=false)
