function [aint1, para] = EdgeSpecial(aint, x1, z1, width1, height1, worldGenSeed)
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
            aint1(k, l) = cen;
            if cen ~= 0 && randi(13) == 1
                aint1(k, l) = randi(15) * 256 + cen;
            end
        end
    end
end