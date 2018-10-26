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

## Optimizing DiffEq Code

# use in-place forms
function lorenz!(du,u,p,t)
    σ,ρ,β = p
    du[1] = σ*(u[2]-u[1])
    du[2] = u[1]*(ρ-u[3]) - u[2]
    du[3] = u[1]*u[2] - β*u[3]
end

# use static arrays
function lorenz_static(u, p, t)
    dx = 10.0*(u[2]-u[1])
    dy = u[1]*(28.0-u[3]) - u[2]
    dz = u[1]*u[2] - (8/3)*u[3]
    @SVector [dx,dy,dz]
end

# don't need in-place form when using static arrays
# just pass a static array as the initial condition
u0      = @SVector [1.0, 0.0, 0.0]
tspan   = (0.0, 100.0)
prob    = ODEProblem(lorenz_static, u0, tspan)
@benchmark solve(prob, Tsit5(), save_everystep=false)

## Interlude: Managing Allocations with Broadcast Fusion

# the expression A + B + C creates two arrays, (A + B) and (A + B + C)
A       = rand(1000,1000);
B       = rand(1000,1000)
C       = rand(1000,1000)

test(A, B, C) = A + B + C
@benchmark test(A,B,C)

# the solution is to use broadcast fusion
test2(A, B, C) = map((a,b,c)->a+b+c, A, B, C)
@benchmark test2(A,B,C)

# put the whole expression into a single function call for only one array
function test3(A,B,C)
    D = similar(A)
    @inbounds for i in eachindex(A)
        D[i] = A[i] + B[i] + C[i]
    end
    return D
end
@benchmark test3(A,B,C)

# use the . operator to apply syntactic sugar to broadcasting
test4(A,B,C) = A .+ B .+ C
@benchmark test4(A,B,C)

test5(A,B,C) = @. A + B + C # only one array allocated
@benchmark test5(A,B,C)

# broadcasting removes intermediate array allocations for many vectorized function calls
# this still results in allocating the output array
# mutation ( .= ) removes this allocation as well
D       = zeros(1000, 1000)
test6!(D, A, B, C) = D .= A .+ B .+ C
@benchmark test6!(D, A, B, C)

# use the macro version instead
test7!(D,A,B,C) = @. D = A + B + C # only one array allocated
@benchmark test7!(D,A,B,C)

# use the in-place map functional instead
test8!(D,A,B,C) = map!((a,b,c)->a+b+c,D,A,B,C)
@benchmark test8!(D,A,B,C)

# in-place matrix multiplication
# slow
@benchmark A*B
# fast
@benchmark A_mul_B!(D,A,B)

## Example: Optimizing Gierer-Meinhardt Reaction-Diffusion PDE Discretization
using LinearAlgebra

# generate the constants
p               = (1.0,1.0,1.0,10.0,0.001,100.0) # a,α,ū,β,D1,D2
N               = 100
Ax              = Tridiagonal([1.0 for i in 1:N-1],[-2.0 for i in 1:N],[1.0 for i in 1:N-1])
Ay              = copy(Ax)
Ax[2,1]         = 2.0
Ax[end-1,end]   = 2.0
Ay[1,2]         = 2.0
Ay[end,end-1]   = 2.0

function basic_version!(dr, r, p, t)
    a, α, ū, β, D1, D2 = p
    u           = r[:,:,1]
    v           = r[:,:,2]
    Du          = D1 * (Ay*u + u*Ax)
    Dv          = D2 * (Ay*v + v*Ax)
    dr[:,:,1]   = Du * a*u*u./v .+ ū .- α*u
    dr[:,:,2]   = Dv + a*u*u .- β*v
end

# define the initial conditions
a, α, ū, β, D1, D2 = p
uss             = (ū + β) / α
vss             = α / β * uss^2
r0              = zeros(100,100,2)
r0[:,:,1]       .= uss + 0.1*rand()
r0[:,:,2]       .= vss

# set up the problem
prob            = ODEProblem(basic_version!, r0, (0.0, 0.1), p)

# solve the "high-level" problem specification
@benchmark solve(prob, Tsit5())

# remove slicing allocations, which produce temporary arrays
# and use broadcast fusion
function gm2!(dr,r,p,t)
  a,α,ū,β,D1,D2 = p
  u             = @view r[:,:,1]
  v             = @view r[:,:,2]
  du            = @view dr[:,:,1]
  dv            = @view dr[:,:,2]
  Du            = D1*(Ay*u + u*Ax)
  Dv            = D2*(Ay*v + v*Ax)
  @. du         = Du + a*u*u./v + ū - α*u
  @. dv         = Dv + a*u*u - β*v
end

prob            = ODEProblem(gm2!,r0,(0.0,0.1),p)
@benchmark solve(prob,Tsit5())

# most allocations are taking place in the matrix multiplication
# replace the matrix multiplication with in-place operations

# set up cache variables
Ayu             = zeros(N,N)
uAx             = zeros(N,N)
Du              = zeros(N,N)
Ayv             = zeros(N,N)
vAx             = zeros(N,N)
Dv              = zeros(N,N)

function gm3!(dr,r,p,t)
  a,α,ubar,β,D1,D2 = p
  u             = @view r[:,:,1]
  v             = @view r[:,:,2]
  du            = @view dr[:,:,1]
  dv            = @view dr[:,:,2]
  A_mul_B!(Ayu, Ay, u)
  A_mul_B!(uAx, u, Ax)
  A_mul_B!(Ayv, Ay, v)
  A_mul_B!(vAx, v, Ax)
  @. Du         = D1*(Ayu + uAx)
  @. Dv         = D2*(Ayv + vAx)
  @. du         = Du + a*u*u./v + ubar - α*u
  @. dv         = Dv + a*u*u - β*v
end

prob            = ODEProblem(gm3!,r0,(0.0,0.1),p)
@benchmark solve(prob,Tsit5())

# localize the cache variables for type stability

p = (1.0,1.0,1.0,10.0,0.001,100.0,Ayu,uAx,Du,Ayv,vAx,Dv) # a,α,ubar,β,D1,D2
function gm4!(dr,r,p,t)
  a,α,ubar,β,D1,D2,Ayu,uAx,Du,Ayv,vAx,Dv = p
  u = @view r[:,:,1]
  v = @view r[:,:,2]
  du = @view dr[:,:,1]
  dv = @view dr[:,:,2]
  A_mul_B!(Ayu,Ay,u)
  A_mul_B!(uAx,u,Ax)
  A_mul_B!(Ayv,Ay,v)
  A_mul_B!(vAx,v,Ax)
  @. Du = D1*(Ayu + uAx)
  @. Dv = D2*(Ayv + vAx)
  @. du = Du + a*u*u./v + ubar - α*u
  @. dv = Dv + a*u*u - β*v
end
prob = ODEProblem(gm4!,r0,(0.0,0.1),p)
@benchmark solve(prob,Tsit5())

# devectorize the tridiagonal stencil
p = (1.0,1.0,1.0,10.0,0.001,100.0,N)
function fast_gm!(du,u,p,t)
  a,α,ubar,β,D1,D2,N = p

  @inbounds for j in 2:N-1, i in 2:N-1
    du[i,j,1] = D1*(u[i-1,j,1] + u[i+1,j,1] + u[i,j+1,1] + u[i,j-1,1] - 4u[i,j,1]) +
              a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
  end

  @inbounds for j in 2:N-1, i in 2:N-1
    du[i,j,2] = D2*(u[i-1,j,2] + u[i+1,j,2] + u[i,j+1,2] + u[i,j-1,2] - 4u[i,j,2]) +
            a*u[i,j,1]^2 - β*u[i,j,2]
  end

  @inbounds for j in 2:N-1
    i = 1
    du[1,j,1] = D1*(2u[i+1,j,1] + u[i,j+1,1] + u[i,j-1,1] - 4u[i,j,1]) +
            a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
  end
  @inbounds for j in 2:N-1
    i = 1
    du[1,j,2] = D2*(2u[i+1,j,2] + u[i,j+1,2] + u[i,j-1,2] - 4u[i,j,2]) +
            a*u[i,j,1]^2 - β*u[i,j,2]
  end
  @inbounds for j in 2:N-1
    i = N
    du[end,j,1] = D1*(2u[i-1,j,1] + u[i,j+1,1] + u[i,j-1,1] - 4u[i,j,1]) +
           a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
  end
  @inbounds for j in 2:N-1
    i = N
    du[end,j,2] = D2*(2u[i-1,j,2] + u[i,j+1,2] + u[i,j-1,2] - 4u[i,j,2]) +
           a*u[i,j,1]^2 - β*u[i,j,2]
  end

  @inbounds for i in 2:N-1
    j = 1
    du[i,1,1] = D1*(u[i-1,j,1] + u[i+1,j,1] + 2u[i,j+1,1] - 4u[i,j,1]) +
              a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
  end
  @inbounds for i in 2:N-1
    j = 1
    du[i,1,2] = D2*(u[i-1,j,2] + u[i+1,j,2] + 2u[i,j+1,2] - 4u[i,j,2]) +
              a*u[i,j,1]^2 - β*u[i,j,2]
  end
  @inbounds for i in 2:N-1
    j = N
    du[i,end,1] = D1*(u[i-1,j,1] + u[i+1,j,1] + 2u[i,j-1,1] - 4u[i,j,1]) +
             a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
  end
  @inbounds for i in 2:N-1
    j = N
    du[i,end,2] = D2*(u[i-1,j,2] + u[i+1,j,2] + 2u[i,j-1,2] - 4u[i,j,2]) +
             a*u[i,j,1]^2 - β*u[i,j,2]
  end

  @inbounds begin
    i = 1; j = 1
    du[1,1,1] = D1*(2u[i+1,j,1] + 2u[i,j+1,1] - 4u[i,j,1]) +
              a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
    du[1,1,2] = D2*(2u[i+1,j,2] + 2u[i,j+1,2] - 4u[i,j,2]) +
              a*u[i,j,1]^2 - β*u[i,j,2]

    i = 1; j = N
    du[1,N,1] = D1*(2u[i+1,j,1] + 2u[i,j-1,1] - 4u[i,j,1]) +
             a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
    du[1,N,2] = D2*(2u[i+1,j,2] + 2u[i,j-1,2] - 4u[i,j,2]) +
             a*u[i,j,1]^2 - β*u[i,j,2]

    i = N; j = 1
    du[N,1,1] = D1*(2u[i-1,j,1] + 2u[i,j+1,1] - 4u[i,j,1]) +
             a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
    du[N,1,2] = D2*(2u[i-1,j,2] + 2u[i,j+1,2] - 4u[i,j,2]) +
             a*u[i,j,1]^2 - β*u[i,j,2]

    i = N; j = N
    du[end,end,1] = D1*(2u[i-1,j,1] + 2u[i,j-1,1] - 4u[i,j,1]) +
             a*u[i,j,1]^2/u[i,j,2] + ubar - α*u[i,j,1]
    du[end,end,2] = D2*(2u[i-1,j,2] + 2u[i,j-1,2] - 4u[i,j,2]) +
             a*u[i,j,1]^2 - β*u[i,j,2]
   end
end
prob = ODEProblem(fast_gm!,r0,(0.0,0.1),p)
@benchmark solve(prob,Tsit5())

# switch the solver to a stiff solver
prob = ODEProblem(fast_gm!,r0,(0.0,100.0),p)
@benchmark solve(prob,CVODE_BDF(linear_solver=:GMRES))

## Callbacks

# define an ODE which represents the motion of a bouncing ball
using DifferentialEquations
ball! = @ode_def BallBounce begin
    dy = v
    dv = -g
end g

# trigger the callback when v == 0 (indicating the ball hits the Earth's surface)
function condition(u, t, integrator)
    u[1]
end

# when the callback is triggered, reverse the velocity with a frictional term
function affect!(integrator)
    integrator.u[2] = -integrator.p[2] * integrator.u[2]
end

bounce_cb = ContinuousCallback(condition, affect!)

# parameters for the ode problem
u0      = [50.0, 0.0]
tspan   = (0.0, 15.0)
p       = (9.8, 0.9)
prob    = ODEProblem(ball!, u0, tspan, p, callback=bounce_cb)

# solve
sol     = solve(prob, Tsit5())

# plot the solution
using Plots; gr()
plot(sol)

# kick the ball
function condition_kick(u,t,integrator)
    t == 2
end
function affect_kick!(integrator)
    integrator.u[2] += 50
end
kick_cb = DiscreteCallback(condition_kick,affect_kick!)
u0 = [50.0,0.0]
tspan = (0.0,10.0)
p = (9.8,0.9)
prob = ODEProblem(ball!,u0,tspan,p,callback=kick_cb)
sol = solve(prob,Tsit5(),tstops=[2.0])
plot(sol)

# merge the two conditions
cb = CallbackSet(bounce_cb,kick_cb)

u0 = [50.0,0.0]
tspan = (0.0,15.0)
p = (9.8,0.9)
prob = ODEProblem(ball!,u0,tspan,p,callback=cb)
sol = solve(prob,Tsit5(),tstops=[2.0])
plot(sol)

## Integration Termination

# the harmonic oscillator model
u0 = [1.,0.]
harmonic! = @ode_def HarmonicOscillator begin
   dv = -x
   dx = v
end
tspan = (0.0,10.0)
prob = ODEProblem(harmonic!,u0,tspan)
sol = solve(prob)
plot(sol)

# define an affect function
# that terminates the integration
function terminate_affect!(integrator)
    terminate!(integrator)
end

# do so when the model returns to zero
function terminate_condition(u,t,integrator)
    u[2]
end
terminate_cb = ContinuousCallback(terminate_condition, terminate_affect!)

sol = solve(prob,callback=terminate_cb)
plot(sol)

# terminate only on upcrossings
# to get the full period
terminate_upcrossing_cb = ContinuousCallback(terminate_condition,terminate_affect!,nothing)

sol = solve(prob,callback=terminate_upcrossing_cb)
plot(sol)

## Formatting Plots
using DifferentialEquations, Plots
gr()
lorenz = @ode_def Lorenz begin
  dx = σ*(y-x)
  dy = ρ*x-y-x*z
  dz = x*y-β*z
end σ β ρ

p = [10.0,8/3,28]
u0 = [1., 5., 10.]
tspan = (0., 100.)
prob = ODEProblem(lorenz, u0, tspan, p)
sol = solve(prob)

# plot the solutions as lines
plot(sol)

# phase plot
plot(sol, vars=(:x, :y, :z))

# plotting uses interpolation
scatter(sol,vars=[:x])
plot(sol,vars=(1,2,3),denseplot=false)
plot(sol,vars=(1,2,3),plotdensity=100)
plot(sol,vars=(1,2,3),plotdensity=10000)
