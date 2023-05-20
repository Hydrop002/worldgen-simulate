function value = GetPerlinValue(x, z, count, seed)
    rng(seed);
    value = 0;
    scale = 1;
    for i = 1 : count
        value = value + GetSimplexValue(x * scale, z * scale) / scale;
        scale = scale / 2;
    end
end