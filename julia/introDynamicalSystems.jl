## Creating a Simple Discrete System
using DynamicalSystems, StaticArrays

# equation of motion for a Hénon map
h_eom(x, p, t) = @SArray [1.0 - p[1]*x[1]^2 + x[2], p[2]*x[1]]

# state of the system (doesn't matter if it is Vector or SVector)
state          = zeros(2)

# set up parameters (can be array or tuple)
p              = (1.4, 0.3)

# set up the dynamical system
hénon          = DiscreteDynamicalSystem(h_eom, state, p)

# acquire a trajectory, forward in timee
tr             = trajectory(hénon, 100000)
# trajectory from a different starting point
tr2            = trajectory(hénon, 100000, 0.01rand(2))

# visualize the trajectories
using Plots; gr()

plot(tr[:, 1], tr[:, 2], lw = 0.0, marker = "o", ms = 0.1, alpha = 0.5)
plot(tr2[:, 1], tr2[:, 2], lw = 0.0, marker = "o", ms = 0.1, alpha = 0.5);
xlabel("x"); ylabel("y");

## Orbit Diagrams
# plot of the long-term behavior of a discrete system
# when a parameter is varied
using DynamicalSystems, Plots; gr()

# logistic map
function bf(pvalues, n, Ttr)
    logi = Systems.logistic()
    output = orbitdiagram(logi, 1, 1, pvalues; n = n, Ttr = Ttr)

    for (j, p) in enumerate(pvalues)
        plot(p .* ones(output[j]), output[j], linestyle = "None", # linestyle = None
        marker = "o", ms = 0.2, color = "black")
    end
    xlabel("\$r\$"); ylabel("\$x\$");
    xlim(pvalues[1], pvalues[end])
    # ylim(0, 1)
    return
end

bf(range(2.0, stop=4.0, length=1000), 200, 2000)
