using Serialization

function analyze_results(name)

    file_path = "./results/$name.jls"

    res = open(file_path, "r") do io
        deserialize(io)
    end

end

analyze_results("amosa")