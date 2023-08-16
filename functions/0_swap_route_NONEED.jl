function Swap(q)
    n = length(q)
    i = rand(1:n, 2)
    i1, i2 = i[1], i[2]
    qnew = copy(q)
    qnew[[i1, i2]] = q[[i2, i1]]
    return qnew
end

function Reversion(q)
    n = length(q)
    i = sort(rand(1:n, 2))
    i1, i2 = i[1], i[2]
    qnew = copy(q)
    qnew[i1:i2] = reverse(q[i1:i2])
    return qnew
end

function Insertion(q)
    n = length(q)
    i = randperm(n)[1:2]
    i1, i2 = i[1], i[2]
    if i1 < i2
        qnew = [q[1:i1-1]; q[i1+1:i2]; q[i1]; q[i2+1:end]]
    else
        qnew = [q[1:i2]; q[i1]; q[i2+1:i1-1]; q[i1+1:end]]
    end
    return qnew
end