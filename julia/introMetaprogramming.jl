# writing an expression and evaluating will unsurprisingly, evaluate the expression
2+2

# treat the expression as a literal string (prevents evaluation)
x = "2+2"

# explicitly tell Julia to evaluate the expression
# eval(parse(x))

# quotes
x = :(2+2)
eval(x)

# quote larger expressions
quote
    x = 2 + 2
    hypot(x, 5)
end

:(function mysum(xs)
    sum = 0
    for x in xs
        sum += x
    end
end)

# fruit of the expression tree
x = :(2+2)
y = :($x * $x)
eval(x)
eval(y)

# the root of all eval
ex = :(foo() = println("I'm foo!"))

try
    foo()
catch e
    println(e)
end

eval(ex)
foo()

for name in [:foo, :bar, :baz]
    println(:($name() = println($("I'm $(name)!"))))
end

for name in [:foo, :bar, :baz]
    eval(:($name() = println($("I'm $(name)!"))))
end

bar()
baz()

# original sin

# consider the definition of the sin function based on the Taylor series
mysin(x) = sum((-1)^k / factorial(1.0 + 2k) * x^(1+2k) for k = 0:5)

mysin(0.5), sin(0.5)

using BenchmarkTools
@benchmark mysin(0.5)
@benchmark sin(0.5)

# symbolic version of the + function
plus(a,b) = :($a + $b)
plus(1,2)

reduce(+, 1:10)
reduce(plus, 1:10)

reduce(plus, [:(x^2), :x, 1])

# create a symbolic version of the Taylor series for sine
k = 2
:($((-1)^k) * x^$(1+2k) / $(factorial(1+2k)))
terms = [:($((-1)^k) * x^$(1+2k) / $(factorial(1+2k))) for k = 0:5]
@show reduce(plus, terms)
:(mysin(x) = :((((((1 * x ^ 1) / 1 + (-1 * x ^ 3) / 6) + (1 * x ^ 5) / 120) + (-1 * x ^ 7) / 5040) + (1 * x ^ 9) / 362880) + (-1 * x ^ 11) / 39916800))

@benchmark mysin(0.5)
