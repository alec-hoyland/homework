## preamble

using DynamicalSystems
using Plots

## define the system

@inline @inbounds function FitzHughNagumo(u, p, t)
    (a, b, c) = p
    du1 = c * (u[1] + u[2] - 1/3*u[1]^3)
    du2 = - 1 / c * (u[1] - a + b*u[2])
    return SVector{2}(du1, du2)
end

# set up parameters
p = [0.7, 0.8, 3.0]
T = 60
u = [2, -1]

## evolve the system
