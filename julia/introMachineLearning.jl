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

print("The RGB values are ($red_value, $green_value, $blue_value)")

# make changes to file
