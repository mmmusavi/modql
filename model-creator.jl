using Serialization

include("./functions/metamodel.jl")

nodes = 10

hubs = 2

vehicles = 2

model = metamodel(nodes, hubs, 0.5, vehicles, 500, 10, 5)

folder_path = "./models"

file_path = joinpath(folder_path, "model-10-2-2.jls")

open(file_path, "w") do io
    serialize(io, model)
end