function [aint1, para] = AddIsland(aint, x1, z1, width1, height1, worldGenSeed)
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
            if cen == 0 && (nw ~= 0 || ne ~= 0 || sw ~= 0 || se ~= 0)
                aint1(k, l) = cen;
                t = 1;
                if nw ~= 0
                    if randi(t) == 1
                        r = nw;
                    end
                    t = t + 1;
                end
                if ne ~= 0
                    if randi(t) == 1
                        r = ne;
                    end
                    t = t + 1;
                end
                if sw ~= 0
                    if randi(t) == 1
                        r = sw;
                    end
                    t = t + 1;
                end
                if se ~= 0
                    if randi(t) == 1
                        r = se;
                    end
                    t = t + 1;
                end
                if randi(3) == 1 || r == 4
                    aint1(k, l) = r;
                end
            elseif cen > 0 && (nw == 0 || ne == 0 || sw == 0 || se == 0)
                aint1(k, l) = cen;
                if randi(5) == 1 && cen ~= 4
                    aint1(k, l) = 0;
                end
            else
                aint1(k, l) = cen;
            end
        end
    end
end