## Model #1: Exponential Growth
using DifferentialEquations
using Plots; gr()

# define the problem
f(u, p, t)  = 0.98u
u0          = 1.0
tspan       = (0.0, 1.0)
prob        = ODEProblem(f, u0, tspan)

sol         = solve(prob)

# visualize the solution

plot(sol,linewidth=5,title="Solution to the linear ODE with a thick line",
     xaxis="Time (t)",yaxis="u(t) (in μm)",label="My Thick Line!") # legend=false
plot!(sol.t, t->1.0*exp(0.98t),lw=3,ls=:dash,label="True Solution!")

# use the 'saveat' keyword to save the solution at those timesteps
sol         = solve(prob, saveat=0.1)
sol         = solve(prob, saveat=[0.2, 0.7, 0.9])

# turn off even more saving
sol         = solve(prob, dense=false)
sol         = solve(prob, save_everystep=false)

# provide hints to the solver
sol         = solve(prob, alg_hints=[:stiff])

# use the Tsit5 algorithm with a fixed relative tolerance
sol         = solve(prob, Tsit5(), reltol=1e-6)

## Solving the Lorenz Equation
function lorenz!(du, u, p, t)
    # using the in-place form (where du is predefined) is faster
    # especially for coupled systems
    σ,ρ,β   = p
    du[1]   = σ*(u[2]-u[1])
    du[2]   = u[1]*(ρ-u[3]) - u[2]
    du[3]   = u[1]*u[2] - β*u[3]
end

# set up initial conditions
u0          = [1.0,0.0,0.0]

# set up parameter values
p           = (10, 28, 8/3) # doesn't matter if it's a tuple or an array

# set up a time span
tspan       = (0.0, 100.0)

# solve the problem
prob        = ODEProblem(lorenz!, u0, tspan, p)
sol         = solve(prob)

## Exploring the Solution

# the time and solution value(s) at the ith time point
(sol.t[10], sol[10])
(sol.t[10], sol.u[10])

# the value of the jth variable at time i
sol[2, 10] == sol[10][2]

# acquire a real matrix of the solutions
A           = convert(Array, sol)

## Plotting the Solution
using Plots; gr()

# by default, the time-series will be plotted for each variable
plot(sol)

# plotting in three dimensions
plot(sol, vars=(1,2,3))

# plotting in three dimensions without interpolation
plot(sol, vars=(1,2,3), denseplot=false)

# in vars, 0=time, so the time series can be plotted as
plot(sol, vars=(0,2))

## Domain-Specific Language for Parametrized Functions

# define the Lotka-Volterra equation without DSL
function lotka_volterra!(du, u, p, t)
    du[1] = p[1]*u[1] - p[2]*u[1]*u[2]
    du[2] = -p[3]*u[2] + p[4]*u[1]*u[2]
  end

# define with the @ode_def macro
lv! = @ode_def LotkaVolterra begin
    dx      = a*x - b*x*y
    dy      = -c*y + d*x*y
end a b c d

# solve the equation
u0 = [1.0,1.0]
p = (1.5,1.0,3.0,1.0)
tspan = (0.0,10.0)
prob = ODEProblem(lv!,u0,tspan,p)
sol = solve(prob)
plot(sol)

## Choosing an ODE Algorithm
using DifferentialEquations
using Plots; gr()

# the van der Pol equation is stiff
van! = @ode_def VanDerPol begin
  dy = μ*((1-x^2)*y - x)
  dx = 1*y
end μ

# this is most notable by the very large parameter μ
prob        = ODEProblem(van!,[0.0,2.0],(0.0,6.3),1e6)

# pass an algorithm hint to the solver
sol         = solve(prob, alg_hints=[:stiff], reltol=1e-6)

# looking at stiffness in the solution
plot(sol, denseplot=false)

## Timing Stiff vs. Non-stiff Solvers
using BenchmarkTools

# consider the lorenz system
function lorenz!(du,u,p,t)
    σ,ρ,β = p
    du[1] = σ*(u[2]-u[1])
    du[2] = u[1]*(ρ-u[3]) - u[2]
    du[3] = u[1]*u[2] - β*u[3]
end
u0 = [1.0,0.0,0.0]
p = (10,28,8/3)
tspan = (0.0,100.0)
prob = ODEProblem(lorenz!,u0,tspan,p)

# benchmark using the generic solver
@btime solve(prob);
# benchmark using a solver for handling stiff problems
@btime solve(prob, alg_hints=[:stiff]);
