# hardcode the directory
cd("/projectnb/cs640grp/ahoyland/homework/CAS-CS-640/project/")

# instantiate the Julia environment
using Pkg
Pkg.activate("./julia")
Pkg.instantiate()

Pkg.add("CuArrays")
using CuArrays

# run the scripts in sequence

@info("including conv.jl")
include("./julia/conv.jl")

@info("including convFuzz.jl")
include("./julia/convFuzz.jl")

@info("including convAdpt.jl")
include("./julia/convAdpt.jl")

@info("including convFull.jl")
include("./julia/convFull.jl")

@info("including dense.jl")
include("./julia/dense.jl")

@info("including denseFuzz.jl")
include("./julia/denseFuzz.jl")

@info("including denseAdpt.jl")
include("./julia/denseAdpt.jl")

@info("including denseFull.jl")
include("./julia/denseFull.jl")
