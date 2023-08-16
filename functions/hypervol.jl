function hypervol(F, U, AU, N)
    n_sol, dim = size(F)
    samples = AU' .+ (U' .- AU') .* rand(N, dim)
    dominated = 0
    
    for i = 1:n_sol
        idx = sum(F[i,:]' .<= samples, dims=2) .== dim
        dominated += sum(idx)
        samples = samples[.!idx,:]
    end
    
    hv = dominated / N
    return hv
end