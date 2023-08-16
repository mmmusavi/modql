include("initial.jl")
include("cost.jl")
include("perturb.jl")

function seq_vnd(x,model)

    current_solution = deepcopy(x)

    current_cost = cost(model,current_solution)

    k = 1

    k_max = 9

    while k <= k_max

        candidate_solution = perturb(current_solution,k)

        cost_new = cost(model,candidate_solution)

        if cost_new < current_cost

            current_solution = candidate_solution

            current_cost = cost_new

            k = 1

        else

            k = k + 1

        end

    end

    return current_solution

end