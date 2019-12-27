# https://www.ronanarraes.com/2019/04/my-julia-workflow-readability-vs-performance/

## Initial readable code

using LinearAlgebra
using BenchmarkTools

# constants
const O3x3   = zeros(3,3)
const O3x12  = zeros(3,12)
const O12x18 = zeros(12,18)

# definition of the Kalman function
# written in a straightforward mathematical manner
function kalman_filter()

    # Constants
    # ==========================================================================

    λ = 1/100
    Q = 1e-20I
    R = 1e-2I

    # Dynamic model
    # ==========================================================================

    wx = Float64[ 0 -1  0;
                  1  0  0;
                  0  0  0;]

    Ak_1 = [  wx    -I   O3x12;
             O3x3  λ*I   O3x12;
                  O12x18      ;]

    Fk_1 = exp(Ak_1)

    # Measurement model
    # ==========================================================================

    sx = Float64[ 0  0  0;
                  0  0 -1;
                  0  1  0;]

    Bx = Float64[ 0  0 -1;
                  0  0  0;
                  1  0  0;]

    Hk = [sx O3x3   sx    I O3x3 O3x3;
          Bx O3x3 O3x3 O3x3   Bx    I;]

    # Kalman filter initialization
    # ==========================================================================

    Pu = Matrix{Float64}(I,18,18)

    # Simulation
    # ==========================================================================

    result = Vector{Float64}(undef, 60000)

    result[1] = tr(Pu)

    for k = 2:60000
        Pp = Fk_1*Pu*Fk_1' + Q
        K  = Pp*Hk'*pinv(R + Hk*Pp*Hk')
        Pu = (I - K*Hk)*Pp*(I - K*Hk)' + K*R*K'

        result[k] = tr(Pu)
    end

    return result
end

# test the code
result = kalman_filter();
@show result[end]

# benchmark the code
@btime kalman_filter()

## How to improve the performance of your code

# Q: Is the code type stable?
# A: There's nothing really suspect going on here.
@code_warntype kalman_filter()

# Q: Which steps are most computationally expensive?
# A: Use the TimerOutputs package to benchmark individual steps
using TimerOutputs
function timed_kalman_filter()
    # Constants
    # ==========================================================================

    λ = 1/100
    Q = 1e-20I
    R = 1e-2I

    # Dynamic model
    # ==========================================================================

    wx = Float64[ 0 -1  0;
                  1  0  0;
                  0  0  0;]

    Ak_1 = [  wx    -I   O3x12;
             O3x3  λ*I   O3x12;
                  O12x18      ;]

    Fk_1 = exp(Ak_1)

    # Measurement model
    # ==========================================================================

    sx = Float64[ 0  0  0;
                  0  0 -1;
                  0  1  0;]

    Bx = Float64[ 0  0 -1;
                  0  0  0;
                  1  0  0;]

    Hk = [sx O3x3   sx    I O3x3 O3x3;
          Bx O3x3 O3x3 O3x3   Bx    I;]

    # Kalman filter initialization
    # ==========================================================================

    Pu = Matrix{Float64}(I,18,18)

    # Simulation
    # ==========================================================================

    result = Vector{Float64}(undef, 60000)

    result[1] = tr(Pu)

    reset_timer!()
    for k = 2:60000
        @timeit "Pp" Pp = Fk_1*Pu*Fk_1' + Q
        @timeit "K"  K  = Pp*Hk'*pinv(R + Hk*Pp*Hk')
        @timeit "Pu" Pu = (I - K*Hk)*Pp*(I - K*Hk)' + K*R*K'

        result[k] = tr(Pu)
    end

    print_timer()

    return result
end

timed_kalman_filter()

## Perform the following modifications
# 1. Pre-allocate K, Pu, and Pp before the loop and use the same location in memory each time.
# 2. Pre-allocate instead of using the UniformScaling operator.
# 3. Replace duplicated code with an auxiliary variable.
# 4. Use the @inbounds macro to disable index-checking

function optimized_kalman_filter()

    # Constants
    # ==========================================================================

    # pre-allocate instead of using the UniformScaling operator in the loop (2)
    I6  = Matrix{Float64}(I,6,6)
    I18 = Matrix{Float64}(I,18,18)
    λ   = 1/100
    Q   = 1e-20I18
    R   = 1e-2I6

    # Dynamic model
    # ==========================================================================

    wx = Float64[ 0 -1  0;
                  1  0  0;
                  0  0  0;]

    Ak_1 = [  wx     -I   O3x12;
             O3x3   λ*I   O3x12;
                   O12x18     ;]

    Fk_1 = exp(Ak_1)

    # Measurement model
    # ==========================================================================

    sx = Float64[ 0  0  0;
                  0  0 -1;
                  0  1  0;]

    Bx = Float64[ 0  0 -1;
                  0  0  0;
                  1  0  0;]

    Hk = [sx O3x3   sx    I O3x3 O3x3;
          Bx O3x3 O3x3 O3x3   Bx    I;]

    # Kalman filter initialization
    # ==========================================================================

    # pre-allocate the outputs (1)
    Pu = Matrix{Float64}(I,18,18)
    Pp = similar(Pu)

    # Simulation
    # ==========================================================================

    result = Vector{Float64}(undef, 60000)

    result[1] = tr(Pu)

    # Auxiliary variables.
    K    = zeros(18,6)
    aux1 = zeros(18,18)

    # use the inbounds macro to ignore index checking (4)
    @inbounds for k = 2:60000
        Pp   .= Fk_1*Pu*Fk_1' .+ Q
        K    .= Pp*Hk'*pinv(R .+ Hk*Pp*Hk')
        # replace duplicate code with an auxiliary variable (3)
        aux1 .= I18 .- K*Hk
        Pu   .= aux1*Pp*aux1' .+ K*R*K'

        result[k] = tr(Pu)
    end

    return result
end

@btime kalman_filter()
@btime optimized_kalman_filter()
