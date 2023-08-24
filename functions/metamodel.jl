include("./cab.jl")
include("./ap.jl")

struct Model
    n::Int64
    p::Int64
    alpha::Float64
    vehicle_num::Int64
    vehicle_capacity::Float64
    eps_full::Float64
    eps_empty::Float64
    c::Matrix{Float64}
    w::Matrix{Float64}
    t::Matrix{Float64}
    d::Matrix{Float64}
end

function metamodel(n, p, alpha, vehicle_num, eps_full, eps_empty)

    n::Int64 = n
    p::Int64 = p
    alpha::Float64 = alpha
    vehicle_num::Int64 = vehicle_num

    eps_full::Float64 = eps_full
    eps_empty::Float64 = eps_empty

    if n <= 25
        rr = Hub_CAB()
    else
        rr = Hub_AP()
    end

    c = rr["c"][1:n, 1:n]
    w = rr["w"][1:n, 1:n]

    t = copy(c)

    d = zeros(1, n)

    for i = 1:n
        d[i] = sum(w[:, i])
    end

    vehicle_capacity::Float64 = 1.5 * sum(d) / (p * vehicle_num)

    model = Model(n, p, alpha, vehicle_num, vehicle_capacity, eps_full, eps_empty, c, w, t, d)

    return model

end