include("types.jl")

function reversion_inter(q)
    p = length(q.route)

    h = randperm(p)[1:2]

    hub = copy(q.hub)

    hubs = unique(hub)

    q2 = deepcopy(q.route)

    route1 = q2[h[1]]
    route2 = q2[h[2]]

    if length(route1) <2 || length(route2) == 0
        return q
    end

    j = randperm(length(route1))[1:2]
    i = sort(j)
    j1, j2 = j[1], j[2]
    i2 = rand(1:length(route2))

    # println(route1)
    # println(route2)
    # println(j)
    # println(i2)

    newval = copy(route1[j1:j2])

    newval2 = reverse(newval)

    # println(newval)
    # println(newval2)

    route11 = [route1[1:j1-1]; route1[j2+1:end]]

    route22 =[route2[1:i2]; newval2; route2[i2+1:end]]

    q2[h[1]] = route11
    q2[h[2]] = route22

    for i=1:length(newval)
        if newval[i] != 0
            hub[newval[i]] = hubs[h[2]]
        end
    end

    return Sol(hub,q2)
end