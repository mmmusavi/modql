using Clustering

function cluster(archive::Vector{Archive}, target_size::Int)
    cost_data = hcat([archive_item.Cost for archive_item in archive]...)
    num_clusters = min(length(archive), target_size)
    assignments = kmeans(cost_data, num_clusters)
    
    cluster_counts = zeros(Int, num_clusters)
    
    clustered_archive = Archive[]
    
    for (idx, assignment) in enumerate(assignments.assignments)
        if length(clustered_archive) < target_size
            cluster_counts[assignment] += 1
            push!(clustered_archive, archive[idx])
        else
            break
        end
    end
    
    return clustered_archive
end
