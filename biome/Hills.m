function [aint2, para, para1] = Hills(aint, aint1, x2, z2, width2, height2, worldGenSeed)
    global useSeed;
    x = x2 - 1;
    z = z2 - 1;
    width = width2 + 2;
    height = height2 + 2;
    if isempty(aint) || isempty(aint1)
        aint2 = [];
        para = [x, z, width, height];
        para1 = [x, z, width, height];
        return;
    else
        para = [];
        para1 = [];
    end
    M = [129 : 134, 140, 149, 151, 155 : 158, 160 : 167];
    aint2 = zeros(height2, width2);
    for k = 1 : height2
        for l = 1 : width2
            if useSeed
                chunkSeed = initChunkSeed(x2 + l, z2 + k, worldGenSeed);
                rng(chunkSeed);
            end
            cen = aint(k + 1, l + 1);
            cen1 = aint1(k + 1, l + 1);
            if cen ~= 0 && cen < 128 && cen1 >= 2 && mod(cen1 - 2, 29) == 1
                if any(M == cen + 128)
                    aint2(k, l) = cen + 128;
                else
                    aint2(k, l) = cen;
                end
            elseif randi(3) ~= 1 && mod(cen1 - 2, 29) ~= 0
                aint2(k, l) = cen;
            else
                h = cen;
                if cen == 2
                    h = 17;
                elseif cen == 4
                    h = 18;
                elseif cen == 27
                    h = 28;
                elseif cen == 29
                    h = 1;
                elseif cen == 5
                    h = 19;
                elseif cen == 32
                    h = 33;
                elseif cen == 30
                    h = 31;
                elseif cen == 1
                    if randi(3) == 1
                        h = 18;
                    else
                        h = 4;
                    end
                elseif cen == 12
                    h = 13;
                elseif cen == 21
                    h = 22;
                elseif cen == 0
                    h = 24;
                elseif cen == 3
                    h = 34;
                elseif cen == 35
                    h = 36;
                elseif compareBiomesById(cen, 38)
                    h = 37;
                elseif cen == 24 && randi(3) == 1
                    if randi(2) == 1
                        h = 1;
                    else
                        h = 4;
                    end
                end
                if mod(cen1 - 2, 29) == 0 && h ~= cen
                    if any(M == h + 128)
                        h = h + 128;
                    else
                        h = cen;
                    end
                end
                if h == cen
                    aint2(k, l) = cen;
                else
                    n = aint(k, l + 1);
                    w = aint(k + 1, l);
                    e = aint(k + 1, l + 2);
                    s = aint(k + 2, l + 1);
                    t = 0;
                    if compareBiomesById(n, cen)
                        t = t + 1;
                    end
                    if compareBiomesById(w, cen)
                        t = t + 1;
                    end
                    if compareBiomesById(e, cen)
                        t = t + 1;
                    end
                    if compareBiomesById(s, cen)
                        t = t + 1;
                    end
                    if t >= 3
                        aint2(k, l) = h;
                    else
                        aint2(k, l) = cen;
                    end
                end
            end
        end
    end
end