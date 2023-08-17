include("nearest.jl")
include("types.jl")

function initial(model)

    n = model.n
    w = model.w
    c = model.c
    d = model.d
    p = model.p

    mu = 0.5

    o = zeros(1,n)
    ci = zeros(1,n)
    wi = zeros(1,n)
    hub_idx = zeros(1,n)
    
    for i=1:n
        o[i] = sum(w[i,:])
        ci[i] = sum(c[i,:]+c[:,i])
        wi[i] = o[i]+d[i]
    end
    
    for i=1:n
        hub_idx[i] = (wi[i]/sum(wi))-(ci[i]/sum(ci))
    end
    
    b = sortperm(vec(hub_idx))
    
    max_e1::Int = max(2,floor(mu*n))
    
    poten_hubs = b[n-max_e1+1:n]
    
    poten_hub_prob = zeros(1,max_e1)
    
    for i=1:max_e1
        poten_hub_prob[i] = (2*i)/(max_e1*(max_e1+1))
    end

    C=cumsum(poten_hub_prob,dims=2)

    c_all = model.c

    hub = zeros(Int,n)
    
    hubs = zeros(Int,p)

    i = 1

    while count(!iszero, hubs) != p
        
        r = rand()
        j = findfirst(r .<= C)

        j = j[2]
        
        if isempty(findall(x -> x == poten_hubs[j], hubs))
            hubs[i] = poten_hubs[j]
            i=i+1
        end
    
    end

    for i = 1:n
        if i in hubs
            hub[i] = i
        else
            min0 = Inf
            min_j = 0
            for j = 1:p
                if c_all[i, hubs[j]] < min0
                    min0 = c_all[i, hubs[j]]
                    min_j = hubs[j]
                end
            end
            hub[i] = min_j
        end
    end

    route = nearest(hub,model)

    return Sol(hub,route)

end