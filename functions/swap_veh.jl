include("types.jl")

function AddZero(q)

    p = length(q.route)

    h = rand(1:p)

    q2 = deepcopy(q.route)

    route = q2[h]

    if length(route)==0
        return q
    end

    nonzeros = count(!iszero, route)

    countzeros = count(iszero, route)

    if countzeros == nonzeros
        return q
    end

    i = rand(1:length(route))

    route =[route[1:i]; 0; route[i+1:end]]

    q2[h] = route
    
    return Sol(q.hub,q2)
end

function RemoveZero(q)

    p = length(q.route)

    h = rand(1:p)

    q2 = deepcopy(q.route)

    route = q2[h]

    num_zeros = count(x -> x == 0, route)
    if num_zeros > 0
        idx = rand(1:length(route))
        while route[idx] != 0
            idx = rand(1:length(route))
        end
        qnew = vcat(route[1:idx-1], route[idx+1:end])
    else
        qnew = copy(route)
    end

    q2[h] = qnew

    return Sol(q.hub,q2)
end