include("nearest.jl")
include("types.jl")

function swap_alloc(q,hub,non,model)

    hu = copy(q.hub)

    hu[non]=hub
    
    route = nearest(hu,model)

    return Sol(hu,route)

end