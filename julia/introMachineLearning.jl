## Representing Data in a Computer
using Images, Statistics, Plots; gr()
path = "/home/ahoyland/code/Fruit-Images-Dataset/Test/"

# load a picture of an apple
apple = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Apple Braeburn/3_100.jpg")
banana = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Banana/116_100.jpg")
typeof(apple[40, 60])

# pull out the red value of the color of the apple
typeof(red(apple[40,60]))
float(red(apple[40,60]))

[ mean(float.(c.(img))) for c = [red,green,blue], img = [apple,banana] ]
apple[18:20, 29:31]

# visualize the distribution of "green" in the pictures
histogram(float.(green.(apple[:])), color="red", label="apple", normalize=true, nbins=25)
histogram!(float.(green.(banana[:])), color="yellow", label="banana", normalize=true, nbins=25)

# the apple is very red
pixel = apple[40, 60];

red_value   = Float64( red(pixel) )
green_value = Float64( green(pixel) )
blue_value  = Float64( blue(pixel) )

print("The RGB values are ($red_value, $green_value, $blue_value)")

## Functions Useful in Machine Learning
using Plots, Interact; gr()

# define the sigmoidal function
σ(x) = 1 / (1 + exp(-x))

plot(σ, -5, 5)
hline!([0, 1], ls = :dash, lw = 3)
vline!([0], ls = :dash, lw = 3)

heaviside(x) = x < 0 ? 0.0 : 1.0

@manipulate for w in 0.1:0.1:20
    plot(x -> σ(w*x), -5, 5, label = "sigma", lw = 2)
    plot!(heaviside, ls = :dash, label = "step")
end

## Modeling Data
using Images

# load the pictures of fruit
apple = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Apple Braeburn/3_100.jpg")
banana = load("/home/ahoyland/code/Fruit-Images-Dataset/Test/Banana/116_100.jpg")

# define a new method for the sigmoid function
σ(x, w, b) = 1 / (1 + exp(-w*x + b))

# the parameters (w, b) = (25.58, 15.6) work well
plot(x -> σ(x, 26.58, 15.6), xlim=(0,1), ylim=(-0.1, 1.1), label="model", legend=:topleft, lw=3)
scatter!([mean(Float64.(green.(apple)))], [0.0], label="apple", ms=5)
scatter!([mean(Float64.(green.(banana)))], [1.0], label="banana", ms=5)

## The Loss Function
using Plots; plotlyjs()

# define the sigmoid
σ(x)        = 1 / (1 + exp(-x))
σ(x, w)     = σ(w*x)
σ(x, w, b)  = σ(w*x + b)

# create some data
xs = [2, -3, -1, 1]
ys = [0.8, 0.3, 0.4, 0.4]

# define the loss function
L2(w, b) = sum( (ys .- σ.(xs, w, b)) .^ 2 )

# visualize the loss function
ws = -2:0.05:2
bs = -2:0.05:2

surface(ws, bs, L2, alpha=0.8, zlims=(0,3))

## Minimization
using Plots; gr()

# define the sigmoid function
σ(x)        = 1 / (1 + exp(-x))
σ(x, w)     = σ(w * x)
σ(x, w, b)  = σ(w * x + b)

# define the loss function using some data
x1, y1      = 2, 0.8
L1(w)       = (y1 - σ(x1, w))^2

plot(L1, -2, 1.5, xlabel="w", ylabel="L1(w)", leg=false)
