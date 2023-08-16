include("types.jl")

function swap_intra(q)
    p = length(q.route)
    q2 = deepcopy(q.route)
    this_route_num = rand(1:p)
    this_route = q.route[this_route_num]
    n = length(this_route)
    if n<2
        return q
    end
    i = randperm(n)[1:2]
    i1, i2 = i[1], i[2]
    qnew = copy(this_route)
    qnew[[i1, i2]] = this_route[[i2, i1]]
    q2[this_route_num] = qnew
    return Sol(q.hub,q2)
end