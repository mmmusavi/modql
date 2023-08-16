function cost(model, q)
    
    hub = q.hub
    route = q.route
    alpha = model.alpha
    p = model.p
    n = model.n
    c = model.c
    w = model.w
    t = model.t
    d = model.d
    eps_full = model.eps_full
    eps_empty = model.eps_empty
    vehicle_capacity = model.vehicle_capacity
    
    hub_nodes = unique(hub)

    y = zeros(1, n)
    
    cost1 = 0
    cost2 = 0
    cost3 = 0
    
    for i = 1:n

        t1 = 0
        
        for j = 1:n
            
            if hub[i] != hub[j]
                
                t1 = t1 + w[i,j]
                
            end
            
        end
        
        y[i] = t1
        
        cost1 = cost1 + c[i,hub[i]] * sum(w[i,:])
        
        t2 = 0
        
        for k = 1:p
            
            for l = 1:p
                
                t2 = t2 + c[hub_nodes[k],hub_nodes[l]] * y[i]
                
            end
            
        end
        
        cost2 = cost2 + (alpha * t2) / 2
        
        cost3 = cost3 + c[hub[i],i] * sum(w[:,i])
        
    end

    veh_num = 0

    at = zeros(1, n)
    load = zeros(1, n)

    for i = 1:p

        this_route = route[i]

        veh_num = veh_num + 1

        route_checker = 0

        for j = 1:length(this_route)

            if this_route[j] == 0

                veh_num = veh_num + 1

                route_checker = 0

            elseif route_checker == 0

                at[this_route[j]] = t[hub[this_route[j]],this_route[j]]

                load[this_route[j]] = d[this_route[j]]

                route_checker = 1
            else

                at[this_route[j]] = at[this_route[j - 1]] + t[this_route[j - 1],this_route[j]]

                load[this_route[j]] = load[this_route[j - 1]] + d[this_route[j]]

                route_checker = 1

            end 

        end

    end

    veh_cap_vol = zeros(1, n)
    carbon = zeros(1, n)
    for i = 1:n
        veh_cap_vol[i] = max(load[i] - vehicle_capacity, 0)
        carbon[i] = (((eps_full - eps_empty) * load[i]) / vehicle_capacity) + (eps_empty * ceil(load[i] / vehicle_capacity))
    end

    violate = 1000 * sum(veh_cap_vol)

    z1 = cost1 + cost2 + cost3 + sum(at) + violate

    z2 = sum(carbon) + violate

    return [z1,z2]

end