cd("/home/alec/code/homework/CAS-CS-640/project/data")

using BSON

data_conv = BSON.load("mnist_conv.bson")
data_convFuzz = BSON.load("mnist_convFuzz.bson")
data_convAdpt = BSON.load("mnist_convAdpt.bson")
data_convFull = BSON.load("mnist_convFull.bson")

data_dense = BSON.load("mnist_dense.bson")
data_denseFuzz = BSON.load("mnist_denseFuzz.bson")
data_denseAdpt = BSON.load("mnist_denseAdpt.bson")
data_denseFull = BSON.load("mnist_denseFull.bson")
