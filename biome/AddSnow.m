function [aint1, para] = AddSnow(aint, x1, z1, width1, height1, worldGenSeed)
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
            if cen ~= 0
                r = randi(6);
                if r == 1
                    aint1(k, l) = 4;
                elseif r == 2
                    aint1(k, l) = 3;
                else
                    aint1(k, l) = 1;
                end
            end
        end
    end
end