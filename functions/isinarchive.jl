function isinarchive(x, archive)
    ii = 0
    output = false
    for i in 1:length(archive)
        output = isequal(archive[i], x)
        if output == true
            ii = i
            break
        end
    end
    return output, ii
end