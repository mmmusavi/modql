using Plots

function plot_hub(q,model)

    w = q.hub
    route = q.route

    x = model.x
    y = model.y
    n = model.n
    h = model.p
    hubs = unique(w)

    p = plot()
        
    for i in 1:n
        if w[i] == i
            scatter!(p, [x[i]], [y[i]], color=:black, marker=:o, markersize=4, label="")
        else
            scatter!(p, [x[i]], [y[i]], color=:black, marker=:o, markersize=2, label="")
        end
    end

    for i in 1:h
        this_route = route[i]

        all_routes = []
        current_route = []

        for j in 1:length(this_route)
            if this_route[j] != 0
                push!(current_route, this_route[j])
            elseif !isempty(current_route)
                prepend!(current_route, hubs[i])
                push!(current_route, hubs[i])
                push!(all_routes, current_route)
                current_route = []
            end
        end

        if !isempty(current_route)
            prepend!(current_route, hubs[i])
            push!(current_route, hubs[i])
            push!(all_routes, current_route)
        end

        for j in 1:length(all_routes)
            for k in 2:length(all_routes[j])
                plot!(p,[x[all_routes[j][k]], x[all_routes[j][k-1]]], [y[all_routes[j][k]], y[all_routes[j][k-1]]], color=:black, linestyle=:dash, linewidth=1, label="")
            end
        end

    end

    p

end