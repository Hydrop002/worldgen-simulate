function f = riverFilter(biome)
    if biome >= 2
        f = 2 + mod(biome, 2);
    else
        f = biome;
    end
end