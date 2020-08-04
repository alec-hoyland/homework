## Problem 1

n = [1.2,1,1.4,1,1.6,1,1.8,1,2,1,2,1,2,1,1.9,1,1.8,1,1.6,1,1.5,1,1.3,1.1]
L = 1. / n;

λ = range(0.7, 2, length=1000)

function problem1_baseline(λ, n, L)
    T = zeros(length(λ))
    for i = 1:length(λ)
        ω = 2π/λ[i]
        k = ω*n
        M = prod([[cos(k*L) sin(k*L)/k; -k*sin(k*L) cos(k*L)] for (k,L) in zip(k,L)])
        t = 2*im*ω / (-M[2,1] + ω^2 * M[1,2] + im*ω*(M[1,1]+M[2,2]))
        T[i] = abs2(t)
    end
    return T
end

function problem1_rewrite(λ, n, L)
    T = zeros(length(λ))
    for i = 1:length(λ)
        ω = 2π/λ[i]
        k = ω*n

        # first pass

        sin_kL, cos_kL = sincos(k[1] * L[1])

        M = [cos_kL sin_kL/k[1]; -k[1]*sin_kL cos_kL]

        # second pass

        for ii = 2:length(k)
            kL = k[ii] * L[ii]
            sin_kL, cos_kL = sincos(kL)
            M *= [cos_kL sin_kL/k[ii]; -k[ii]*sin_kL cos_kL]
        end

        t = 2*im*ω / (-M[2,1] + ω^2 * M[1,2] + im*ω*(M[1,1]+M[2,2]))
        T[i] = abs2(t)
    end
    return T
end

problem1_baseline(λ, n, L) ≈ problem1_rewrite(λ, n, L)

function matrix_mult_kernel(a, b)
    C = zeros(2, 2)
    C[1, 1] = a[1, 1] * b[1, 1] + a[1, 2] * b[2, 1]
    C[2, 1] = a[2, 1] * b[1, 1] + a[2, 2] * b[2, 1]
    C[1, 2] = a[1, 1] * b[1, 2] + a[1, 2] * b[2, 2]
    C[2, 2] = a[2, 1] * b[1, 2] + a[2, 2] * b[2, 2]
    return C
end

function matrix_mult_kernel2(m, kL)

end

a, b = rand(2, 2), rand(2, 2)
a * b ≈ matrix_mult_kernel(a, b)

sincos(1)
