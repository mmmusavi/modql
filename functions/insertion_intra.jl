include("types.jl")

function insertion_intra(q)
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
    if i1 < i2
        qnew = [this_route[1:i1-1]; this_route[i1+1:i2]; this_route[i1]; this_route[i2+1:end]]
    else
        qnew = [this_route[1:i2]; this_route[i1]; this_route[i2+1:i1-1]; this_route[i1+1:end]]
    end

    q2[this_route_num] = qnew
    return Sol(q.hub,q2)
end