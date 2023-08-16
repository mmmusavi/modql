function nearest(q, model)

    p = model.p
    t = model.t
    d = model.d
    routes = Vector{Any}(undef, p)
    hub = q
    hubs = unique(hub)
    vehicle_capacity = model.vehicle_capacity
    vehicle_num = model.vehicle_num

    for i = 1:p

        this_veh_num = 1

        this_nodes = findall(x -> x == hubs[i], hub)

        this_nodes = [idx[2] for idx in this_nodes]
        
        deleteat!(this_nodes, findfirst(x -> x == hubs[i], this_nodes))

        this_route = []

        pos_prev = 0

        sum_veh = 0

        while length(this_nodes) != 0

            if length(this_route) == 0
                _, pos = findmin(t[hubs[i],this_nodes])
            else
                _, pos = findmin(t[pos_prev,this_nodes])
            end

            pos = this_nodes[pos]

            sum_veh += d[pos]

            if sum_veh >= vehicle_capacity && this_veh_num < vehicle_num
                sum_veh = d[pos]
                push!(this_route, 0)
                this_veh_num += 1
            end

            push!(this_route, pos)
            pos_prev = pos
            deleteat!(this_nodes, findfirst(x -> x == pos, this_nodes))

        end

        zero_count = count(x -> x == 0, this_route)

        if zero_count < vehicle_num - 1
            for k = 1:vehicle_num - 1 - zero_count
                push!(this_route, 0)
            end
        end

        routes[i] = this_route
        
    end

    return routes

end