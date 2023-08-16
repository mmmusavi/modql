include("types.jl")

function insertion_inter(q)

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

    newval = copy(route1[i1])

    route11 = [route1[1:i1-1]; route1[i1+1:end]]

    route22 =[route2[1:i2]; newval; route2[i2+1:end]]

    q2[h[1]] = route11
    q2[h[2]] = route22
    q2
    if newval != 0
        hub[newval] = hubs[h[2]]
    end

    return Sol(hub,q2)
end