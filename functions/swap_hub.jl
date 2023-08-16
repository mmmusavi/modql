include("types.jl")

function swap_hub(q)

    hub = copy(q.hub)

    hubs = unique(hub)

    p = length(hubs)

    n = length(hub)

    all_nodes = collect(1:n)

    non_hub_nodes = filter(x -> !(x in hubs), all_nodes)

    i1 = rand(1:p)

    remove_hub = hubs[i1]

    add_hub = non_hub_nodes[rand(1:n-p)]

    hub[hub .== remove_hub] .= add_hub

    hub[add_hub] = add_hub

    q2 = deepcopy(q.route)

    for i=1:p
        q2[i] = filter(x -> x != add_hub, q2[i])
    end

    newhubs = unique(hub)

    idx = findfirst(x -> x==add_hub, newhubs)

    push!(q2[idx],remove_hub)

    return Sol(hub,q2)

end