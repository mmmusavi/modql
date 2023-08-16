include("insertion_intra.jl")
include("insertion_inter.jl")
include("swap_intra.jl")
include("swap_inter.jl")
include("reversion_intra.jl")
include("reversion_inter.jl")
include("swap_veh.jl")
include("swap_hub.jl")

function perturb(q, k)
    
    if k == 1

        qnew = insertion_intra(q)

    elseif k == 2

        qnew = insertion_inter(q)

    elseif k == 3

        qnew = swap_intra(q)

    elseif k == 4

        qnew = swap_inter(q)

    elseif k == 5

        qnew = reversion_intra(q)

    elseif k == 6

        qnew = reversion_inter(q)

    elseif k == 7

        qnew = swap_hub(q)

    end

    return qnew

end