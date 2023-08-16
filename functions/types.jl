struct Sol
    hub::Matrix{Int64}
    route::Vector{Any}
end

struct Archive
    sol::Sol
    Cost::Array{Float64,1}
end