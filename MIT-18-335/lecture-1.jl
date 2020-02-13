# https://nbviewer.jupyter.org/github/mitmath/18335/blob/master/psets/pset1.ipynb
# https://github.com/mitmath/18335/blob/master/psets/pset1.pdf
# https://nbviewer.jupyter.org/github/mitmath/18335/blob/master/notes/Floating-Point-Intro.ipynb


## Entering and working with floating point numbers

# some floating point numbers
1.5e7

# not technically a floating point number since 1 and 49 aren't floating point
# the result is a rounded version of 1/49
x = 1/49
# not quite 1 ...
x*49
1 - x*49

# double-precision has 53 bits of significand
# these are all the same thing
2.0^-52, eps(), eps(1.0), eps(Float64)

# ulp: unit in the last place error

# get more precision
big(1) / big(49)

# rational numbers
3//2

# 1.5 is exactly represented min binary floating point
big(1.5), 1.5 == 3//2

# 0.1 is *not* exactly represented
big(0.1), 0.1 == 1//10

## Overflow, Underflow, Inf, and NaN

# okay, in the representable range
1e300
# overflows (becomes Inf)
(1e300)^2

# what is the maximum value for a float?
floatmax(), floatmax(Float64), floatmax(Float32)

# as with big numbers, same with small numbers
1e-300
# underflows to +0
(1e-300)^2

# what is the minimum value for a float?
floatmin(Float64), floatmin(Float32)

# underflow to -0
-1e-300 * 1e-300

# positive and negative zero?
+0.0 == -0.0
1 / +0.0, 1 / -0.0
signbit(+0.0), signbit(-0.0)

# not a number: NaN
0 * Inf, Inf / Inf, 0 / 0

# usually Julia will throw an exception instead of contaminate your computations
sqrt(-1.0)
sqrt(complex(-1.0))

## Cancellation error
x = 2.0^-60
exp(x)
exp(x) - 1

# naive algorithm computed in BigFloat precision
Float64(exp(big(x)) - 1)
# could also use Taylor expansion of exp(x)
x + x^2/2 + x^3/6

# how to deal with catastrophic cancellation?
# rearrange the calculation to be solvable analytically
# and then only use floating point arithmetic *after* this is accomplished

# sometimes you can get lucky and there are functions
expm1(x)

## Accumulation of roundoff errors

# here is a naive function that computes cumulative sums
function my_cumsum(x)
    y = similar(x)
    y[1] = x[1]
    for i = 2:length(x)
        y[i] = y[i-1] + x[i]
    end
    return y
end

# compare error accumulation between Float32 and Float64 data types
eps(Float32), eps(Float64)

x = rand(Float32, 10^7)
@time y = my_cumsum(x)
y_exact = my_cumsum(Float64.(x))
err = abs.(y .- y_exact) ./ abs.(y_exact)

using PyPlot
n = 1:10:length(err) # downsample by 10 for plotting speed
loglog(n, err[n])
ylabel("relative error")
xlabel("# summands")
# plot a √n line for comparison
loglog([1,length(err)], sqrt.([1,length(err)]) * 1e-7, "k--")
text(1e3,1e-5, L"\sim \sqrt{n}")
title("naive cumsum implementation")

# the error scales with √n, which makes sense for a random walk process

@time y2 = cumsum(x)
err2 = abs.(y2 .- yexact) ./ abs.(yexact)
loglog(n, err2[n])
ylabel("relative error")
xlabel("# summands")
title("built-in cumsum function")
loglog(n, sqrt.(log.(n)) * 1e-7, "k--")
text(1e2,3.3e-7, L"\sim \sqrt{\log n}")



## Problem 2: Funny functions

# a: write a function L4(x, y) to compute the L₄ norm

L4(x, y) = (abs(x)^4 + abs(y)^4)^(0.25)

L4(1.0e100, 0.0)
L4(1.0e-100, 0.0)

tseries(x) = 1 + 4(x-1) + 6(x-1)^2 + 4(x-1)^3
L4_test(x, y) = (tseries(abs(x))^4 + tseries(abs(y))^4)^(0.25)

L4_test(1.0e100, 0.0)

## Problem 4: Addition, another way

function div2sum(x, first = 1, last = length(x))
    n = last - first + 1
    if n < 2
        s = zero(eltype(x))
        for i = first:last
            s += x[i]
        end
        return s
    else
        mid = div(first + last, 2)
        return div2sum(x, first, mid) + div2sum(x, mid+1, last)
    end
end

# check its accuracy for a set logarithmically spaced n's.  Since div2sum is slow,
# we won't go to very large n or use too many points
N = round.(Int, 10 .^ range(1,7,length=50)) # 50 points from 10¹ to 10⁷
err = Float64[]
for n in N
    x = rand(Float32, n)
    xdouble = Float64.(x)
    push!(err, abs(div2sum(x) - sum(xdouble)) / abs(sum(xdouble)))
end

using PyPlot
loglog(N, err, "bo-")
title("simple div2sum")
xlabel("number of summands")
ylabel("relative error")
grid()
