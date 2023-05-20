function biome = getWeightedBiome(type)
    switch type
        case 'DESERT'
            r = randi(6);
            if r <= 3
                biome = 2;
            elseif r <= 5
                biome = 35;
            else
                biome = 1;
            end
        case 'WARM'
            r = randi(6);
            if r == 1
                biome = 4;
            elseif r == 2
                biome = 29;
            elseif r == 3
                biome = 3;
            elseif r == 4
                biome = 1;
            elseif r == 5
                biome = 27;
            else
                biome = 6;
            end
        case 'COOL'
            r = randi(4);
            if r == 1
                biome = 4;
            elseif r == 2
                biome = 3;
            elseif r == 3
                biome = 5;
            else
                biome = 1;
            end
        case 'ICY'
            r = randi(4);
            if r <= 3
                biome = 12;
            else
                biome = 30;
            end
    end
end