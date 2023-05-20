function b = canBiomesBeNeighbors(p1, p2)
    if strcmp(getTempCategory(p1), getTempCategory(p2)) || strcmp(getTempCategory(p1), 'MEDIUM') || strcmp(getTempCategory(p2), 'MEDIUM')
        b = 1;
    else
        b = 0;
    end
end