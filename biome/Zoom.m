function [aint2, para] = Zoom(aint, x2, z2, width2, height2, worldGenSeed)
    global useSeed;
    x = floor(x2 / 2);
    z = floor(z2 / 2);
    width = floor(width2 / 2) + 2;
    height = floor(height2 / 2) + 2;
    if isempty(aint)
        aint2 = [];
        para = [x, z, width, height];
        return;
    else
        para = [];
    end
    width1 = (width - 1) * 2;
    height1 = (height - 1) * 2;
    aint1 = zeros(height1, width1);
    for k = 1 : height - 1
        for l = 1 : width - 1
            if useSeed
                chunkSeed = initChunkSeed((x + l) * 2, (z + k) * 2, worldGenSeed);
                rng(chunkSeed);
            end
            nw = aint(k, l);
            ne = aint(k, l + 1);
            sw = aint(k + 1, l);
            se = aint(k + 1,l + 1);
            aint1(2 * k - 1, 2 * l - 1) = nw;
            aint1(2 * k - 1, 2 * l) = selectRandom([nw, ne]);
            aint1(2 * k, 2 * l - 1) = selectRandom([nw, sw]);
            aint1(2 * k, 2 * l) = selectMoreOrRandom(nw, ne, sw, se);
        end
    end
    aint2 = aint1((1 : height2) + mod(z2, 2), (1 : width2) + mod(x2, 2));
end