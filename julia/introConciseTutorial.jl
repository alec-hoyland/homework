## Data Types

## Strings
a = "Sphinx of black quartz, judge my vow"

# standard operations
split(a)
join(["Sphinx", "of"], " ")
replace(a, "vow" => "oath")

# concatenation
"Sphinx " * "of"
string("Sphinx ", "of")

## Arrays
# N-dimensional mutable containers

# constructing
a       = []
a       = Int64[]
a       = Array{Int64,1}()
a       = zeros(5)
a       = zeros(Int64, 5)

# vector container (1-D)
a       = [1; 2; 3]
a       = [1, 2, 3]
a       = vcat(100, 102:2:110)
a       = [100; 102:2:110]

# matrix container (2-D)
a       = [1 2 3]

# heterogeneous arrays
a       = [10, "foo", false]
a       = Union{Int64, String, Bool}[10, "Foo", false]

# iterators vs. arrays
a       = [1:10]
a       = collect(1:10)

# accessing elements of an array
a[1:3]
a[[1:3; 4]]

# methods on arrays
a       = collect(1:3)
b       = 4
push!(a, b)

b       = [5, 6]
append!(a, b)

pop!(a)

popfirst!(a)

deleteat!(a, 2)

pushfirst!(a, 6)

sort!(a)

in(1, a)
in(a, 1)

length(a)
maximum(a)
empty!(a)

a       = [1 2 3 4 5 6 7 8 9 10]
a       = vec(a)

isempty(a)

findall(x -> x > 4, a)
deleteat!(a, findall(x -> x > 4, a))

## Multidimensional and Nested Arrays

# creating a matrix by columns
a       = [[1, 2, 3] [4, 5, 6]]
# creating a matrix by rows
a       = [1 4; 2 5; 3 6]
# creating nested vectors
a       = [[1, 2, 3], [4, 5, 6]]
# creating and filling a matrix
a       = zeros(3,2)
a       = fill("abc", 3, 2)

## Tuples
# lists of immutable elements

a       = (1, 2, 3)
a       = 1, 2, 3

# tuples in arrays
v       = [a]
# convert tuple to array
v       = collect(a)

# named tuples
nt      = (a=1, b=2)
nt.a
keys(nt)
values(nt)
collect(nt)
pairs(nt)

## Dictionaries
# mappings from keys to values with apparently random sorting

a       = Dict()
a       = Dict('a'=>1, 'b'=>2, 'c'=>3)

# add pairs to the dictionary
a['d']  = 4
# add pairs using maps
map((i,j) -> a[i]=j, ['e', 'f', 'g'], [10, 20, 30])

# look up value
a['c']
# look up value with default for missing key
get(a, 'x', 0)

# get all keys (as an iterator)
keys(a)
# get all values (as an iterator)
values(a)
# check if a key exists
haskey(a, 'a')
# check if a given key/value pair exists
in('a' => 1, a)

## Sets
# represent collections of unordered, unique values

# empty (zero elements) set
a       = Set()
# initialize a set with values
a       = Set([1,2,2,3,4])
# set intersection, union, and difference
b       = Set([2,2,3,4,5])
intersect(a,b)
union(a,b)
setdiff(a,b)

## Memory and Copying
# Julia by default copies only the memory address of large objects
# unless the programmer specifiically requests a "deep" copy

# "equals" sign (assignment)
# primitive types (viz. Float64, Int64, String) are deep copied
# containers of primitive types are copied by pointer

# copy(x)
# primitive types are deep copied
# containers of primitive types are deep copied
# containers of containers are copied by pointer

# deepcopy(x)
# everything is deep copied recursively

# use "==" to determine if the values are identical
# use "===" to determine if the memory addresses are identical
a = [1, 2]; b = [1, 2];
a == b
a === b
a = (1, 2); b = (1, 2);
a == b
a === b

## Control Flow

# all typical control flow statements work as expected
for i = 1:2, j = 2:4
    println(i*j)
end

# continue and break are supported

# list comprehensions and maps
[sin(π/2*i) for i in [1,2,3]]
[x + 2y for x in [10,20,30], y in [1,2,3]]
# [myDict[i] = value for (i, value) in enumerate(myList)]
# [students[name] = sex for (name, sex) in zip(names, sexes)]
# map((n,s) -> students[n] = s, names, sexes)

# logical operators
# and: &&
# or: ||
# not: !

# "do" blocks define anonymous functions which are passed as first arguments to the
# outer functions

# expects the first argument to be a function
myarray     = rand(10)
findall(x -> x > 0.5, myarray)
findall(myarray) do x
    x > 0.5
end
