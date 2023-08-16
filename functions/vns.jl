include("metamodel.jl")
include("initial.jl")
include("cost.jl")
include("perturb.jl")
include("seq_vnd.jl")
include("plot_hub.jl")

function vns()

    model = metamodel(15,3)

    x = initial(model)

    current_cost = cost(model,x)

    k_max = 9

    for i in 1:100

        k = 1

        while k <= k_max

            x_p = perturb(x,k)

            x_z = seq_vnd(x_p,model)

            cost_new = cost(model,x)

            if cost_new < current_cost
                x = x_z
                current_cost = cost_new
                k = 1
            else
                k = k + 1
            end

        end

    end

    println(" best_cost: ", round(current_cost,digits=2))
    println(x)
    plot_hub(x,model)

end

vns()