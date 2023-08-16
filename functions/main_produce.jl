include("checkdomination.jl")
include("deltadom.jl")
include("isinarchive.jl")
include("cluster.jl")

function main_produce(x, xnew, archive, t, SL,HL)

    archive_out = deepcopy(archive)
    x_out = deepcopy(x)
    newdominates = checkdomination(xnew.Cost, x.Cost)
    olddominates = checkdomination(x.Cost, xnew.Cost)
    k = length(archive)
    case_a = Int[]
    case_c = Int[]
    
    for i in 1:k
        if checkdomination(archive[i].Cost, xnew.Cost) == 1
            push!(case_a, i)
        end
        if checkdomination(xnew.Cost, archive[i].Cost) == 1
            push!(case_c, i)
        end
    end
    
    case_b = length(case_a) + length(case_c)
    
    if olddominates == 1
        sumi = 0
        for i in case_a
            sumi += deltadom(archive[i], xnew)
        end
        
        deltadomavg = (sumi + deltadom(x, xnew)) / (length(case_a) + 1)
        p = 1 / (1 + exp(deltadomavg * t))
        
        if rand() <= p
            x_out = xnew
        end
    elseif newdominates == 1
        if length(case_a) > 0
            minavg = Inf
            mincorr = 0
            
            for i in case_a
                avg = deltadom(archive[i], xnew)
                if avg < minavg
                    minavg = avg
                    mincorr = i
                end
            end
            
            p = 1 / (1 + exp(-minavg))
            
            if rand() <= p
                x_out = archive[mincorr]
            else
                x_out = xnew
            end
        elseif case_b == 0
            x_out = xnew
            push!(archive_out, xnew)
            
            if length(archive_out) > SL
                archive_out = cluster(archive_out,HL)
            end
            
            output, ii = isinarchive(x, archive)
            if output == 1
                deleteat!(archive_out, ii)
            end
        elseif length(case_c) > 0
            deleteat!(archive_out, case_c)
            x_out = xnew
            push!(archive_out, xnew)
        end
    else
        if length(case_a) > 0
            sumi = 0
            for i in case_a
                sumi += deltadom(archive[i], xnew)
            end
            
            p = 1 / (1 + exp(sumi * t / length(case_a)))
            
            if rand() <= p
                x_out = xnew
            end
        elseif case_b == 0
            x_out = xnew
            push!(archive_out, xnew)
            if length(archive_out) > SL
                archive_out = cluster(archive_out,HL)
            end
        elseif length(case_c) > 0
            deleteat!(archive_out, case_c)
            x_out = xnew
            push!(archive_out, xnew)
        end
    end
    
    return x_out, archive_out
end