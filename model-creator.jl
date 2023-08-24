using Serialization

include("./functions/metamodel.jl")
include("./functions/model_ref.jl")

table_data = model_ref()

folder_path = "./models"
for row in table_data
    instance, nodes, hubs, vehicles = row

    model = metamodel(nodes, hubs, 0.5, vehicles, 10, 5)

    file_path = joinpath(folder_path, "$instance.jls")

    open(file_path, "w") do io
        serialize(io, model)
    end
end