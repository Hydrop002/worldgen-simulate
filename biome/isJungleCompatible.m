function b = isJungleCompatible(biome)
    if biome == 21 || biome == 22 || biome == 23 || biome == 4 || biome == 5 || isBiomeOceanic(biome)
        b = 1;
    else
        b = 0;
    end
end