function checkdomination(x1, x2)
    output = 0
    if all(x1 .<= x2) && any(x1 .< x2)
        output = 1
        return output
    end
    return output
end