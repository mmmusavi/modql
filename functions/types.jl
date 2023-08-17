struct Sol
    hub::Vector{Int64}
    route::Vector{Vector{Int64}}
end

struct Archive
    sol::Sol
    Cost::Vector{Float64}
end

struct ReplayMemory
    states::Vector{Vector{Float64}}
    actions::Vector{Int}
    rewards::Vector{Float64}
    next_states::Vector{Vector{Float64}}
    terminals::Vector{Bool}
end