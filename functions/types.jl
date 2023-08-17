struct Sol
    hub::Matrix{Int64}
    route::Vector{Any}
end

struct Archive
    sol::Sol
    Cost::Array{Float64,1}
end

struct ReplayMemory
    states::Vector{Vector{Float64}}
    actions::Vector{Int}
    rewards::Vector{Float64}
    next_states::Vector{Vector{Float64}}
    terminals::Vector{Bool}
end