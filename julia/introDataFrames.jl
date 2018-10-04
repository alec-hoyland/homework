## Introduction to DataFrames
using DataFrames

# construct a data frame
DataFrame()

# construct a data frame with some stuff in it
DataFrame(A = 1:3, B = rand(3), C = ["a", "b", "c"])

# create a data frame from a dictionary
x = Dict("A" => [1,2], "B" => [true, false], "C" => ['a', 'b'])
DataFrame(x)

# create a data frame from an anonymous dictionary
DataFrame(:A => [1,2], :B => [true, false], :C => ['a', 'b'])

# create a data frame from a vector of vectors
DataFrame( [rand(3) for i in 1:3] )

# create a data frame from a vector
DataFrame(transpose([1, 2, 3]))
DataFrame([1; 2; 3])

# pass a second argument to name the columns
DataFrame([1:3 4:6 7:9], [:A, :B, :C])

# create a data frame from a matrix
DataFrame(rand(3,4))
DataFrame(rand(3,4), Symbol.('a':'d'))

# create an uninitialized data frame
DataFrame([Int, Float64, Any], [:A, :B, :C], 1)
DataFrame([Int, Float64, String], [:A, :B, :C], 1)

# create a data frame with column names but no rows
DataFrame([Int; Float64; String], [:A, :B, :C])

# create a data frame of type Int
DataFrame(Int, 3, 5)

# create a data frame with non-homogeneous types
DataFrame([Int, Float64], 4)

## Conversion to a Matrix

# begin with a data frame with two rows and two columns
x = DataFrame(x=1:2, y = [:A, :B])

# force it to be converted to a matrix
Matrix(x)
typeof(Matrix(x))

# the type is inferred from the data
typeof(Matrix(DataFrame(Int, 2, 2)))

## Handling of Duplicate Names

DataFrame(:a => 1, :a => 2, :a_1 => 3; makeunique=true)

## Getting Basic Information about a Data Frame

x = DataFrame(A = [1, 2], B = [1.0, missing], C = ["a", "b"])

# get the size of the data frame
size(x)
size(x, 1)

# length gives the number of columns
nrow(x)
ncol(x)
length(x)

# acquire general statistics
describe(x)

# give information about a column
showcols(x)

# return the names of all columns
names(x)

# eltypes returns the element types
eltypes(x)

# peek at the top rows of a data table
y = DataFrame(rand(1:10, 1000, 10))
head(y)
# peek at the bottom rows
tail(y, 3)

# given the data frame above, there are three ways to access columns
x[1], x[:A], x[:, 1]

# grab a row from a data frame
x[1, :]

# grab a single cell
x[1, 1]

# assignment can be done to a scalar
x[1:2, 1:2] = 1

# or to a vector of length equal to the number of assigned rows
x[1:2, 1:2] = [1,2]
x

# or to another data frame of matching size
x[1:2, 1:2] = DataFrame([5 6; 7 8])

## Handling Missing Values

# the singleton type Missing.missing deals with missing values
# Any <: Missing
# arrays automatically create the correct Union type
x = [1, 2, missing]
typeof(x)
ismissing(1), ismissing(missing), ismissing(x), ismissing.(x)

# extract missing from an array
eltype(x), Missings.T(eltype(x))

# missing comparisons produce missing
missing == missing, missing != missing, missing < missing
1 == missing, 1 != missing, 1 < missing

# stronger comparisons produce Booleans
isequal(missing, missing), missing === missing, isequal(missing, 1)

# many (not all) functions handle missing
map(x -> x(missing), [sin, cos, zero, sqrt])
# map(x -> x(missing), [+, -, *, /, div])

# return iterator skipping missing values
collect(skipmissing([1, missing, 2, missing]))

# return iterator with missing replaced with something else
collect(Missings.replace([1.0, missing, 2.0, missing], NaN))
# another way to do this
coalesce.([1.0, missing, 2.0, missing], NaN)

## Manipulating Columns

x = DataFrame(Bool, 3, 4);

# rename columns by creating a new data frame
rename(x, :x1 => :A)

# rename columns in-place
rename!(x, :x1 => :A)

# rename each column according to a function
rename!(c -> Symbol(string(c)^2), x)

# names! will change the names of all variables
names!(x, [:a, :b, :c, :d])

# can't pass non-unique names without the makeunique flag
names!(x, fill(:a, 4), makeunique=true);

# reorder the names vector as needed
srand(3446)
x[shuffle(names(x))];

# merge / add columns
x = DataFrame([(i, j) for i in 1:3, j in 1:4]);
hcat(x, x, makeunique=true);

# prepend by using a data frame
y = [DataFrame(A = [1, 2, 3]) x];

# add a column in the middle
using BenchmarkTools
@btime [$x[1:2] DataFrame(A=[1,2,3]) $x[3:4]]

# or use the insert! function
insert!(y, 2, [1,2,3], :newcol) # much faster!!

# append a column in-place
insert!(x, ncol(x)+1, [1,2,3], :A)
# prepend a column in-place
insert!(x, 1, [1,2,3], :B)

# merge two data frames, overwriting duplicates
df1 = DataFrame(x = 1:3, y = 4:6)
df2 = DataFrame(x = 'a':'c', z = 'd':'f', new=11:13);
df1, df2, merge!(df1, df2)

# subsetting / removing columns
x = DataFrame([(i,j) for i in 1:3, j in 1:5])
# subset by index
x[[1, 2, 4, 5]]
# subset by column name
x[[:x1, :x4]]
# subset by Boolean
x[[true, false, true, true, false]]

# create a data frame vs. access the contents
x[[:x1]]
x[:x1]

# nuke a data frame
empty!(y)

# delete columns from a data frame
z = copy(x)
x, delete!(z, 3)

# modify column by name
x = DataFrame([(i,j) for i in 1:3, j in 1:5])
# modify without copying anything (in-place)
x[:x1] = x[:x2]
# add a new column at the end by name (without using insert! or merge!)
x[:A] = [1,2,3]
# add a new column by index
x[7] = 11:13

# find column name
x = DataFrame([(i,j) for i in 1:3, j in 1:5])
# check to see if a name exists
:x1 in names(x)

## Manipulating Columns of DataFrames
using DataFrames

# start with a DataFrame of Bools that has default column names
x = DataFrame(Bool, 3, 4);

# create a new DataFrame with renamed columns
rename(x, :x1 => :A)

# perform in-place renaming
rename!(c -> Symbol(string(c)^2), x)

# rename a column without knowing the original name
rename(x, names(x)[3] => :third)

# change the names of all variables
names!(x, [:a, :b, :c, :d])
# can't use duplicate names (unless makeunique=true)
names!(x, fill(:a, 4), makeunique=true)

# reorder the names(x) vector as needed, creating a new DataFrame
using Random
x[shuffle(names(x))]

# merging/adding columns
x = DataFrame([(i,j) for i in 1:3, j in 1:3])
y = DataFrame([(i, j) for i in 1:3, j in 4:6])
hcat(x, y)
# append a vector
y = hcat(x, [1, 2, 3], makeunique=true)
# prepend a vector
y = hcat([1, 2, 3], x, makeunique=true)

# insert a column into the middle (multiple times)
insert!(y, 2, [1, 2, 3], :newcol, makeunique=true)

## Manipulating Rows of DataFrames

x = DataFrame(id=1:10, x = rand(10), y = [zeros(5); ones(5)])

# check if a DataFrame, or a subset of its columns are sorted
issorted(x)
issorted(x, :x)

# sort column :x in-place
sort!(x, :x)

# sort column :id
y = sort(x, :id)

# sort by two columns, first is decreasing, second is increasing
sort(x, (:y, :x), rev=(true, false))
sort(x, (order(:y, rev=true), :x))

# even more sorting (let's try to figure out what they did here)
sort(x, (order(:y, rev=true), order(:x, by=v->-v)))

# reorder rows randomly
using Random
x[shuffle(1:10), :]

# swap two rows
sort(x, :id)
x[[1, 10], :] = x[[10, 1], :]
x

# another way to swap (back)
x[1, :], x[10, :] = x[10, :], x[1, :]
x

# merging/adding rows
x = DataFrame(rand(3, 5))
vcat(x, x)

# reverse order of names
y = x[reverse(names(x))]

# automatic column-name matching
vcat(x, y)

# append by directly modifying x in-place
append!(x, x)

# add one row to the end
# must use correct number of values and types
push!(x, 1:5)

# also works with dictionaries
push!(x, Dict(:x1=> 1, :x2=>5, :x3=>32, :x4=>4, :x5=>11))

# subsetting/removing rows
x = DataFrame(id=1:10, val='a':'j')

# subset by index
x[1:2, :]

# just peek without copying anything
view(x, 1:2)

# by boolean indexing
x[repeat([true, false], outer=5), :]

# don't copy, just view
view(x, repeat([true, false], 5), :)

# delete one row
deleterows!(x, 7)

# delete a collection of rows
deleterows!(x, 6:7)

# create a new DataFrame, where filtering function operates on the specified row
x = DataFrame([1:4, 2:5, 3:6])
filter(r -> r[:x1] > 2.5, x)

# in-place modification of x (with do-block syntax)
filter!(x) do r
    if r[:x1] > 2.5
        return r[:x2] < 4.5
    end
    r[:x3] < 3.5
end
x

# deduplicating
x = DataFrame(A=[1,2], B=["x", "y"])
append!(x, x)
x[:C]= 1:4
x

unique(x, [1,2])
