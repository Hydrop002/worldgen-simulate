function [aint1, para] = Smooth(aint, x1, z1, width1, height1, worldGenSeed)
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
            n = aint(k, l + 1);
            w = aint(k + 1, l);
            e = aint(k + 1, l + 2);
            s = aint(k + 2, l + 1);
            cen = aint(k + 1, l + 1);
            aint1(k, l) = cen;
            if n == s && w == e
                if randi(2) == 1
                    aint1(k, l) = w;
                else
                    aint1(k, l) = n;
                end
            else
                if w == e
                    aint1(k, l) = w;
                end
                if n == s
                    aint1(k, l) = n;
                end
            end
        end
    end
end