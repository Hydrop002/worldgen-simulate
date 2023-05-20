function [aint1, para] = Biome(aint, x1, z1, width1, height1, worldGenSeed)
    global useSeed;
    if isempty(aint)
        aint1 = [];
        para = [x1, z1, width1, height1];
        return;
    else
        para = [];
    end
    aint1 = zeros(height1, width1);
    for k = 1 : height1
        for l = 1 : width1
            if useSeed
                chunkSeed = initChunkSeed(x1 + l, z1 + k, worldGenSeed);
                rng(chunkSeed);
            end
            cen = aint(k, l);
            r = floor(cen / 256);
            cen = mod(cen, 256);
            if isBiomeOceanic(cen) || cen == 14
                aint1(k, l) = cen;
            elseif cen == 1
                if r > 0
                    if randi(3) == 1
                        aint1(k, l) = 39;
                    else
                        aint1(k, l) = 38;
                    end
                else
                    aint1(k, l) = getWeightedBiome('DESERT');
                end
            elseif cen == 2
                if r > 0
                    aint1(k, l) = 21;
                else
                    aint1(k, l) = getWeightedBiome('WARM');
                end
            elseif cen == 3
                if r > 0
                    aint1(k, l) = 32;
                else
                    aint1(k, l) = getWeightedBiome('COOL');
                end
            elseif cen == 4
                aint1(k, l) = getWeightedBiome('ICY');
            else
                aint1(k, l) = 14;
            end
        end
    end
end