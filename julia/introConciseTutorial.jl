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

## Functions

# define inline
f(x,y)      = 2x + y

# define by function keyword
function f(x)
    x + 2
end

# keyword arguments
myFunction(a, b=1; c=2) = (a + b)*3 + c

# declare function arguments as a certain type
myFunction(a::Float64) = 2*a

# splat operator to specify variable number of arguments and "splice" a list
function average(init, args...)
    s = 0
    for arg in args
        s += arg
    end
    return init + s/length(args)
end

a = average(10, 1, 2, 3)
a = average(10, [1, 2, 3] ...)

# templates
myFunction(x::T, y::T2, z::T2) where {T <: Number, T2} = 5x + 5y + 5z
myFunction(1,2,3)
myFunction(1, 2.5, 3.5)
# myFunction(1, 2, 3.5) <-- not allowed since y and z are not the same type

# functions as objects
f(x) = 2x
a = f(2)
a = f
a(5)

## Custom Structures

# defining a (mutable) structure
mutable struct MyOwnType
    property1
    property2::String
end

# defining a struct with parametrized types
mutable struct MyOwnType{T <: Number}
    property1
    property2::String
    property3::T
end

# structs are immutable by default
# mutable objects (such as arrays) within immutable structs are mutable
struct MyImmutableType
    property1::Array{Float64,1}
end

a = MyImmutableType(collect(1:10))

a.property1
push!(a.property1, 11)
a.property1

## I/O

open("afile.txt", "w") do f  # "w" for writing
  write(f, "test\n")         # \n for newline
end

## RTEs & Exceptions

try
  # ..some dangerous code..
catch e
    if isa(e, KeyError)
      # do something
    end
  # ..what to do if an error happens, most likely send an error message using:
  error("My detailed message")
end

## Metaprogramming

# colon prefix operator
expr = :(1+2) # save the `1+2` expression in the `expr` expression
eval(expr)    # here the expression is evaluated and the code returns 3

# interpolation is supported
a = 1
expr = :($a+2) # expr is now :(1+2)

# an alternative to :([...]) is the quote [...] end block

# parse a string
expr = Meta.parse("1+2") # parses the string "1+2" and saves the `1+2` expression in the `expr` expression, same as expr = :(1+2)
eval(expr)          # here the expression is evaluated and the code returns 3

# equivalent expression from the tree
expr = Expr(:call, :+, 1, 2)

# symbols
a = 2;
ex = Expr(:call, :*, a, :b) # ex is equal to :(2 * b). Note that b doesn't even need to be defined
a = 0; b = 2;               # no matter what now happens to a, as a is evaluated at the moment of creating the expression and the expression stores its value, without any more reference to the variable
eval(ex)                    # returns 4, not 0

# macros

macro unless(test_expr, branch_expr)
    quote
        if !$test_expr
            $branch_expr
        end
    end
end

array = [1, 2, 'b']

# 3 in array is the first expression
@unless 3 in array println("array does not contain 3")
@unless in(3, array) println("array does not contain 3")
