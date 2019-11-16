# hardcode the directory
cd("/projectnb/cs640grp/ahoyland/homework/CAS-CS-640/project/")

# instantiate the Julia environment
using Pkg
Pkg.activate("./julia")
Pkg.instantiate()

# Pkg.add("CuArrays")
# using CuArrays

# run the scripts in sequence

@info("including conv.jl")
include("/projectnb/cs640grp/ahoyland/homework/CAS-CS-640/project/julia/conv.jl")
