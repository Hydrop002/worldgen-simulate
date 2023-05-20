function [aint1, para] = RareBiome(aint, x1, z1, width1, height1, worldGenSeed)
    global useSeed;
    x = x1 - 1;
    z = z1 - 1;
    width = width1 + 2;
    height = height1 + 2;
    if isempty(aint)
        aint1 = [];
        para = [x, z, width, height];
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
            cen = aint(k + 1, l + 1);
            aint1(k, l) = cen;
            if randi(57) == 1 && cen == 1
                aint1(k, l) = cen + 128;
            end
        end
    end
end