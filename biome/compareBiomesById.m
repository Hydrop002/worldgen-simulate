function b = compareBiomesById(p1, p2)
    if p1 == p2 || p1 == 38 && p2 == 39 || p1 == 39 && p2 == 38
        b = 1;
    else
        b = 0;
    end
end