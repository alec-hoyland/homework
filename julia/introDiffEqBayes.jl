using DiffEqBayes

f1 = @ode_def_nohes LotkaVolterra begin
    dx = a*x - x*y
    dy = -3*y + x*y
end a

p = [1.5]
u0 = [1.0, 1.0]
tspan = (0.0, 10.0)
prob = ODEProblem(f1, u0, tspan, p)

σ = 0.01
t = collect(linspace(1, 10, 10))
sol = solve(prob, Tsit5())


randomized = VectorOfArray([(sol(t[i]) + σ * randn(2)) for i in 1:length(t)])
data = convert(Array,randomized)

bayesian_result_turing = turing_inference(prob1,Tsit5(),t,data,priors;num_samples=500)
