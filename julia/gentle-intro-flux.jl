# https://medium.com/@Jernfrost/machine-learning-for-dummies-in-julia-6cd4d2e71a46

## Taking Gradients
using Flux
using Flux.Tracker

f(x) = 3x^2 + 2x + 1
df(x) = Tracker.gradient(f, x; nest = true)[1]
df(2)
d2f(x) = Tracker.gradient(df, x; nest = true)[1]
d2f(2)

f(W, b, x) = W * x + b
Tracker.gradient(f, 2, 3, 4)

# treating things as parameters
W = param(2)
b = param(3)
f(x) = W * x + b
grads = Tracker.gradient(() -> f(4), params(W, b))
grads[W]
grads[b]

## Simple Models

# consider a linear regression
W = rand(2, 5)
b = rand(2)

predict(x) = W*x .+ b

function loss(x, y)
  ŷ = predict(x)
  sum((y .- ŷ).^2)
end

x, y = rand(5), rand(2) # Dummy data
loss(x, y) # ~ 3

W = param(W)
b = param(b)

gs = Tracker.gradient(() -> loss(x, y), params(W, b))

# using the gradient to improve our estimation
using Flux.Tracker: update!

Δ = gs[W]
# update the parameter and reset the gradient
update!(W, -0.1Δ)

# loss is less than before
loss(x, y)

## Building Layers

# using the previous coding style
using Flux
W1 = param(rand(3, 5))
b1 = param(rand(3))
layer1(x) = W1 * x .+ b1

W2 = param(rand(2, 3))
b2 = param(rand(2))
layer2(x) = W2 * x .+ b2

model(x) = layer2(σ.(layer1(x)))
model(rand(5))

# define a helper function, linear
function linear(in, out)
  W = param(randn(out, in))
  b = param(randn(out))
  x -> W * x .+ b
end

linear1 = linear(5, 3)
linear2 = linear(3, 2)

model(x) = linear2(σ.(linear1(x)))
model(rand(5))

# another way, using a struct that explicitly represents the affine layer
struct Affine
  W
  b
end

Affine(in::T, out::T) where T <: Integer = Affine(param(randn(out, in)), param(randn(out)))

# overload call, so the object can be used as a function
(m::Affine)(x) = m.W * x .+ m.b

a = Affine(10, 5)
a(rand(10))

## Stacking It Up

# more intuitive to have a list of layers
# foldl chains together the calls to the layers
layers = [Dense(10, 5, σ), Dense(5, 2), softmax]
model(x) = foldl((x, m) -> m(x), layers, init = x)
model(rand(10))

# Flux provides a Chain constructor
model2 = Chain(Dense(10, 5, σ), Dense(5, 2), softmax)
model2(rand(10))
