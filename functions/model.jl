using JuMP, GLPK
using Random

# Create a JuMP model with the Gurobi solver
model = Model(GLPK.Optimizer)
set_optimizer_attribute(model, "msg_lev", GLPK.GLP_MSG_ALL)

# Set the random seed for reproducibility (optional)
Random.seed!(1234)

# Define scalars
n = 10
p = 2
alpha = 0.5
bigM = 100000
vehicle_cost = 10
vehicle_capacity = 350

# Define sets
nodes = 0:n+1

# Define parameters
c = rand(10:20, n, n)
w = rand(10:20, n, n)
t = c

@variable(model, x[i=nodes, j=nodes],Bin)
@variable(model, y[i=nodes, k=nodes, j=nodes] >= 0)
@variable(model, at[i=nodes] >= 0)
@variable(model, load[i=nodes] >= 0)
@variable(model, z[i=nodes, j=nodes, k=nodes], Bin)
@variable(model, v[k=nodes] >= 0,Int)

@objective(model, Min, 
    sum(c[i,k]*x[i,k]*sum(w[i,j] for j=1:n) for i=1:n, k=1:n)
    + sum(alpha*c[k,l]*y[i,k,l] for i=1:n, k=1:n, l=1:n)
    + sum(c[k,i]*x[i,k]*sum(w[j,i] for j=1:n) for i=1:n, k=1:n)
    + vehicle_cost*sum(v[k] for k=1:n)
    + sum(at[i] for i=1:n)
)

@constraint(model, sum(x[i,i] for i=1:n) == p)

for i=1:n
    @constraint(model, sum(x[i,k] for k=1:n) == 1)
end

for i=1:n
    for k=1:n
        @constraint(model, x[i,k] <= x[k,k])
    end
end

for i=1:n
    for k=1:n
        @constraint(model, sum(y[i,k,l] for l=1:n) - sum(y[i,l,k] for l=1:n) == sum(w[i,j]*x[i,k] for j=1:n) -  sum(w[i,j]*x[j,k] for j=1:n))
    end
end

for i=1:n
    for j=1:n
        for k=1:n
            if i!=j && i!=k && k!=j
                @constraint(model, 2*z[i,j,k] <= x[j,k] + x[i,k])
            end
        end
    end
end

for j=1:n
    for k=1:n
        if j!=k
            @constraint(model, sum(z[i,j,k] for i=0:n if i!=j && i!=k) == x[j,k])
        end
    end
end

for i=1:n
    for k=1:n
        if i!=k
            @constraint(model, sum(z[i,j,k] for j=1:n+1 if i!=j && j!=k) == x[i,k])
        end
    end
end

for k=1:n
    @constraint(model, sum(z[0,j,k] for j=1:n if j!=k) == v[k])
end

for k=1:n
    @constraint(model, sum(z[i,n+1,k] for i=1:n if i!=k) == v[k])
end

for i=1:n
    for k=1:n
        if i!=k
            @constraint(model, at[i] >= t[k,i]*z[0,i,k])
        end
    end
end

for i=1:n
    for j=1:n
        for k=1:n
            if i!=j && i!=k && k!=j
                @constraint(model, at[j] + bigM*(1-z[i,j,k]) >= t[i,j] + at[i])
            end
        end
    end
end

for i=1:n
    for k=1:n
        if i!=k
            @constraint(model, load[i] >= sum(w[j,i] for j=1:n)*z[0,i,k])
        end
    end
end

for i=1:n
    for j=1:n
        for k=1:n
            if i!=j && i!=k && k!=j
                @constraint(model, load[j] + bigM*(1-z[i,j,k]) >= sum(w[j,i] for j=1:n) + load[i])
            end
        end
    end
end

for i=1:n
    @constraint(model, load[i] <= vehicle_capacity)
end

# Solve the model
@time optimize!(model)

# Print results
println("Objective value: ", objective_value(model))

Hubs = Int[]
Allocations = Int[]

for i=1:n
    if value(x[i,i]) == 1
        push!(Hubs,i)
    end
    for j=1:n
        if value(x[i,j]) == 1
            push!(Allocations,j)
        end
    end
end
println("Hubs:",Hubs)
println("Allocations:",Allocations)
#println(JuMP.value.(y))
println(JuMP.value.(z))
println(JuMP.value.(at))
println(JuMP.value.(load))
println(JuMP.value.(v))