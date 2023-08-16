using Random
Random.seed!(1234)

struct Model
    n::Int64
    p::Int64
    alpha::Float64
    vehicle_num::Int64
    vehicle_capacity::Float64
    eps_full::Float64
    eps_empty::Float64
    x::Matrix{Int64}
    y::Matrix{Int64}
    c::Matrix{Float64}
    w::Matrix{Int64}
    t::Matrix{Float64}
    d::Matrix{Int64}
end

function metamodel(n, p,alpha,vehicle_num,vehicle_capacity,eps_full,eps_empty)

    n::Int = n
    p::Int = p
    alpha::Float64 = alpha
    vehicle_num::Int64 = vehicle_num
    vehicle_capacity::Float64 = vehicle_capacity

    eps_full::Float64 = eps_full
    eps_empty::Float64 = eps_empty

    x = rand(0:10000, 1, n)
    y = rand(0:10000, 1, n)

    c = zeros(n, n)
    for i in 1:n
        for j in 1:n
            c[i,j] = sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2)
        end
    end

    w = rand(10:20, n, n)
    t = copy(c)

    d = zeros(1, n)

    for i = 1:n
        d[i] = sum(w[:,i])
    end

    model = Model(n, p, alpha, vehicle_num, vehicle_capacity, eps_full, eps_empty, x, y, c, w, t, d)

    return model

end