function [aint1, para] = AddMushroomIsland(aint, x1, z1, width1, height1, worldGenSeed)
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
            nw = aint(k, l);
            ne = aint(k, l + 2);
            sw = aint(k + 2, l);
            se = aint(k + 2, l + 2);
            cen = aint(k + 1, l + 1);
            aint1(k, l) = cen;
            if nw == 0 && ne == 0 && sw == 0 && se == 0 && cen == 0 && randi(100) == 1
               aint1(k, l) = 14; 
            end
        end
    end
end