function b = isBiomeOceanic(biome)
    if biome == 0 || biome == 10 || biome == 24
        b = 1;
    else
        b = 0;
    end
end