function change_to_state(x)

    n = length(x.sol.route)

    newstate = copy(x.sol.hub)

    newstate = vec(newstate)

    newstate = vcat(newstate,[-2])

    for i=1:n
        newstate = vcat(newstate,x.sol.route[i])
        if i!=n
            newstate = vcat(newstate,[-1])
        end
    end

    return newstate

end