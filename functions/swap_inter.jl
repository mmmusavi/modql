include("types.jl")

function swap_inter(q)
    
    p = length(q.route)

    h = randperm(p)[1:2]

    hub = copy(q.hub)

    hubs = unique(hub)

    q2 = deepcopy(q.route)

    route1 = q2[h[1]]
    route2 = q2[h[2]]

    if length(route1) ==0 || length(route2) == 0
        return q
    end

    i1 = rand(1:length(route1))
    while route1[i1] == 0
        i1 = rand(1:length(route1))
    end
    i2 = rand(1:length(route2))
    while route2[i2] == 0
        i2 = rand(1:length(route2))
    end

    route1[i1], route2[i2] = route2[i2], route1[i1]

    if route1[i1] != 0
        hub[route1[i1]] = hubs[h[1]]
    end

    if route2[i2] != 0
        hub[route2[i2]] = hubs[h[2]]
    end

    return Sol(hub,q2)
end