## Dictionaries

# create a dictionary
myphonebook = Dict("Jenny" => "867-5309", "Kramer" => "555-FILK")

# remove an entry and get it as an output
kramer_num = pop!(myphonebook, "Kramer")

# NOTE: dictionaries are not ordered

## Tuples

myfavoriteanimals = ("penguins", "cats", "sugargliders")

myfavoriteanimals[1]

# NOTE: tuples are immutable

## Arrays

myfriends = ["Ted", "Robyn", "Barney", "Lily", "Marshall"]
fibonacci = [0, 1, 1, 2, 3, 5, 8, 13]

# indexing into arrays
myfriends[3]
# update elements of an array
myfriends[3] = "Baby Bop"
myfriends
# add to an array with push!
push!(fibonacci, 21)
fibonacci
pop!(fibonacci)
fibonacci

# arrays of arrays
favorites = [["koobideh", "chocolate", "eggs"], ["foo", "bar", "baz"]]

# n-dimensional arrays
rand(4, 3)
rand(4, 3, 2)

## For Loops

for n in 1:10
    println(n)
end

for n ∈ 1:10
    println(n)
end

for n = 1:10
    println(n)
end

# create addition tables using for loops
m, n = 5, 5
A = zeros(Int64, m, n)

for i in 1:m
    for j in 1:n
        A[i, j] = i + j
    end
end

# also write iterators on the same line
for i in 1:m, j in 1:n
    A[i, j] = i + j
end

# also write iterators as comprehensions
B = [i + j for i in 1:m, j in 1:n]

for n in 1:10
    A = [i + j for i in 1:n, j in 1:n]
    display(A)
end

## Conditionals
x, y = 3, 90
if x > y
    x
elseif x < y
    y
else
    ""
end

# ternary operator
(x > 3) ? x : y

# short-circuit evaluation
(x > y) && println("$x is larger than $y")
(x < y) && println("$x is smaller than $y")

## How to declare a function

function sayhi(name)
    println("Hi $name, it's great to see you!")
end

f(x) = x^2

sayhi("C3P0")
f(2)

# anonymous (λ) functions
sayhi_anon = name -> println("Hi $name, it's great to see you!")

sayhi_anon("C3P0")

# mutating functions

v = [3, 5, 2]
sort(v)
v
sort!(v)
v

# broadcasting
A = [i + 3j for i in 0:2, j in 0:2]

B = f(A)
C = f.(A)

## Linear Algebra
A = rand(1:4, 3, 3)
B = A
C = copy(A)

[B C]

A[1] = 7

[B C]

# NOTE: only B has changed because B is a pointer to A in memory
# C is a distinct object in memory

x = ones(3)

b = A * x

# create symmetric matrix from A
Asym = A + A'
# syntactic sugar
Apd = A'A

# NOTE: julia returns the least-squares solution for overdetermined problems
# for rank-deficient systems, the least-squares solution with the smallest norm is returned

# NOTE: multiple dispatch & linear algebra
# can convert matrices to different types to use different solver routines automatically
