include("metamodel.jl")
include("initial.jl")
include("cost.jl")
include("perturb.jl")
include("plot_hub.jl")

function sa_hub()
    model = metamodel(15,3)

    best_solution = initial(model)

    best_cost = cost(model,best_solution)

    current_solution = deepcopy(best_solution)

    current_cost = best_cost

    T = 100

    T_min = 0.5

    alpha = 0.99

    MaxIter = 100

    while T > T_min
        
        for iter=1:MaxIter

            ns = [1,2,3,4,5,7,8,9]

            k = rand(1:length(ns))

            x_new = perturb(current_solution,ns[k])

            cost_new = cost(model,x_new)
            
            if cost_new < current_cost
                
                current_solution = x_new
                current_cost = cost_new
                
            else
                
                delta = cost_new - current_cost
                
                p = exp(-delta/T)
                
                if rand() <= p
                    
                    current_solution = x_new
                    current_cost = cost_new
                    
                end
                
            end
                        
            if current_cost < best_cost
                
                best_solution = current_solution
                best_cost = current_cost
                
            end
        end
        # println(best_solution)
        # plot_hub(best_solution,model)

        T *= alpha

        # println("T: ",round(T,digits=2)," best_cost: ", round(best_cost,digits=2))

    end

    println("T: ",round(T,digits=2)," best_cost: ", round(best_cost,digits=2))
    println(best_solution)

    plot_hub(best_solution,model)

end

sa_hub()