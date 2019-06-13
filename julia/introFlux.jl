using Flux.Tracker

f(x) = 3x^2 + 2x + 1;
df(x) = Tracker.gradient(f, x; nest = true)[1]

df(2)

d2f(x) = Tracker.gradient(df, x; nest = true)[1]

d2f(2)

# when a function has many parameters, they can be passed explicitly
f(W, b, x) = W * x + b

Tracker.gradient(f, 2, 3, 4)

# treat something as a parameter
# gradient() automatically takes gradients of variables listed as parameters
using Flux

W = param(2)
b = param(3)

f(x) = W * x + b

grads = Tracker.gradient(() -> f(4), params(W, b))
grads[W]
grads[b]

## Simple Models

W = rand(2, 5)
b = rand(2)

predict(x) = W*x .+ b

function loss(x, y)
  ŷ = predict(x)
  sum((y .- ŷ).^2)
end

x, y = rand(5), rand(2) # Dummy data
loss(x, y) # ~ 3

# improve prediction by optimizing W via gradient descent
using Flux.Tracker

W = param(W)
b = param(b)

gs = Tracker.gradient(() -> loss(x, y), params(W, b))

using Flux.Tracker: update!

Δ = gs[W]

# update the parameter and reset the gradient
update!(W, -0.1Δ)

loss(x, y)

## Building Layers

using Flux

W1 = param(rand(3, 5))
b1 = param(rand(3))

layer1(x) = W1 * x .+ b1

W2 = param(rand(2, 3))
b2 = param(rand(2))

layer2(x) = W2 * x .+ b2

model(x) = layer2(σ.(layer1(x)))
model(rand(5))
