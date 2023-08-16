function deltadom(a, b)
    delta = 1
    for i in 1:length(a.Cost)
        delta *= abs(a.Cost[i] - b.Cost[i])
    end
    return delta
end
