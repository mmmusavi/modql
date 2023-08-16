using Flux
using Random:length
using Plots
using LinearAlgebra

include("./functions/metamodel.jl")
include("./functions/initial.jl")
include("./functions/cost.jl")
include("./functions/types.jl")
include("./functions/perturb.jl")
include("./functions/main_produce.jl")
include("./functions/hypervol.jl")

function change_to_state(data)

    n = length(data.sol.route)

    newstate = copy(data.sol.hub)

    newstate = vec(newstate)

    newstate = vcat(newstate, [-2])

    for i = 1:n
        newstate = vcat(newstate, data.sol.route[i])
        if i != n
            newstate = vcat(newstate, [-1])
        end
    end

    return newstate

end

function amosa_DQN_no_replay()

    nodes = 10

    hubs = 2

    vehicles = 2

    model = metamodel(nodes, hubs, 0.5, vehicles, 500, 10, 5)

    STATE_SIZE = nodes + 1 + (nodes - hubs) + hubs * (vehicles - 1) + hubs - 1
    ACTION_SPACE = 6

    solve_model = Chain(
        Dense(STATE_SIZE, 64, relu),
        Dense(64, ACTION_SPACE)
    )

    discount_factor = 0.9
    learning_rate = 0.5
    epsilon = 0.1

    optimizer = ADAM(learning_rate)
    loss_function(y, ŷ) = Flux.mse(y, ŷ)

    alpha = 0.95

    HL = 20

    SL = 100

    iter = 100

    Tmax = 100

    Tmin = 1.5

    temp = Tmax

    npareto = 1

    C = []

    archive = Vector{Archive}(undef, HL)

    for i in 1:HL
        position = initial(model)
        cost1 = cost(model, position)
        archive[i] = Archive(Sol(position.hub, position.route), cost1)
    end

    i = rand(1:HL)
    x = deepcopy(archive[i])

    while temp > Tmin
        for i = 1:iter

            state = change_to_state(x)

            q_values = solve_model(state)

            ns = [1,2,3,4,5,7]

            if rand() < epsilon
                action = rand(1:length(ns))
            else
                action = argmax(q_values)
            end

            x_new = perturb(deepcopy(x.sol), ns[action])

            cost_new = cost(model, x_new)

            new_sol = Archive(Sol(x_new.hub, x_new.route), cost_new)

            x_out, archive_out = main_produce(x, new_sol, archive, temp, SL, HL)

            archive = deepcopy(archive_out)
            x = deepcopy(x_out)

            C = zeros(Float64, length(archive), 2)
            for aa in 1:length(archive)
                C[aa, 1] = archive[aa].Cost[1]
                C[aa, 2] = archive[aa].Cost[2]
            end

            C = unique(C, dims=1)
            npareto = size(C, 1)

            next_state = change_to_state(deepcopy(x))

            println(action, sum(state - next_state))

            reward = npareto
            q_values_next = solve_model(next_state)
            target = reward + discount_factor * maximum(q_values_next)
            
            gradient = Flux.gradient(Flux.params(solve_model)) do
                loss_function(q_values[action], target)
            end
                    
            Flux.Optimise.update!(optimizer, Flux.params(solve_model), gradient)
            
        end

        # println(" Temp = ", temp, " Pareto Size = ", npareto)
        temp = alpha * temp
    end

    C = zeros(Float64, length(archive), 2)
    for aa in 1:length(archive)
        C[aa, 1] = archive[aa].Cost[1]
        C[aa, 2] = archive[aa].Cost[2]
    end

    C = unique(C, dims=1)
    npareto = size(C, 1)

    scatter(C[:, 1], C[:, 2], markershape=:circle, legend=false)
    xlabel!("F1")
    ylabel!("F2")
    savefig("plot-amosa-dqn-noreplay.png")

    U_Point = [0, 0]

    AU_Point = [1000000000, 1000000000]

    dm = sqrt(maximum(C[:, 1]) - minimum(C[:, 1]) + maximum(C[:, 2]) - minimum(C[:, 2]))
    mid_temp = 0.0

    for ig in 1:npareto
        mid_temp += sqrt(((C[ig, 1] - U_Point[1]) / (maximum(C[:, 1]) - minimum(C[:, 1])))^2 + ((C[ig, 2] - U_Point[2]) / (maximum(C[:, 2]) - minimum(C[:, 2])))^2)
    end

    mid = mid_temp / npareto

    dd = zeros(npareto - 1)
    if npareto > 1
        for ig in 1:(npareto - 1)
            dd[ig] = sqrt((C[ig, 1] - C[ig + 1, 1])^2 + (C[ig, 2] - C[ig + 1, 2])^2)
        end

        d_bar = sum(dd) / (npareto - 1)

        sm_temp = 0.0
        for ig in 1:length(dd)
            sm_temp += abs(d_bar - dd[ig])
        end
        sm = sm_temp / ((npareto - 1) * d_bar)
    else
        sm = 0.0
    end

    hv = hypervol(C, U_Point, AU_Point, 10000)


    println("Number of Pareto:", npareto)
    println("DM:", dm)
    println("MID:", mid)
    println("SM:", sm)
    println("HyperVol:", hv)

end

amosa_DQN_no_replay()