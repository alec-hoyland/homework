cd("/home/alec/code/homework/CAS-CS-640/project/julia/")
using Pkg
Pkg.activate(".")
Pkg.instantiate()

try
    @info "including conv"
include("conv.jl")
catch
    this_error
end

try
    @info "including convFuzz"
include("convFuzz.jl")
catch
    this_error
end

try
    @info "including convAdpt"
include("convAdpt.jl")
catch
    this_error
end

try
    @info "including convFull"
include("convFull.jl")
catch
    this_error
end

try
    @info "including dense"
include("dense.jl")
catch
    this_error
end

try
    @info "including denseFuzz"
include("denseFuzz.jl")
catch
    this_error
end

try
    @info "including denseAdpt"
include("denseAdpt.jl")
catch
    this_error
end

try
    @info "including denseFull"
include("denseFull.jl")
catch
    this_error
end
