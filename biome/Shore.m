function [aint1, para] = Shore(aint, x1, z1, width1, height1, worldGenSeed)
    global useSeed
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
            n = aint(k, l + 1);
            w = aint(k + 1, l);
            e = aint(k + 1, l + 2);
            s = aint(k + 2, l + 1);
            if cen == 14
                if n ~= 0 && w ~= 0 && e ~= 0 && s ~= 0
                    aint1(k, l) = cen;
                else
                    aint1(k, l) = 15;
                end
            elseif cen == 21 || cen == 22 || cen == 23
                if isJungleCompatible(n) && isJungleCompatible(w) && isJungleCompatible(e) && isJungleCompatible(s)
                    if ~isBiomeOceanic(n) && ~isBiomeOceanic(w) && ~isBiomeOceanic(e) && ~isBiomeOceanic(s)
                        aint1(k, l) = cen;
                    else
                        aint1(k, l) = 16;
                    end
                else
                    aint1(k, l) = 23;
                end
            elseif cen ~= 3 && cen ~= 20 && cen ~= 34
                if cen == 10 || cen == 11 || cen == 12 || cen == 13 || cen == 26 || cen == 30 || cen == 31
                    if isBiomeOceanic(cen) || ~isBiomeOceanic(n) && ~isBiomeOceanic(w) && ~isBiomeOceanic(e) && ~isBiomeOceanic(s)
                        aint1(k, l) = cen;
                    else
                        aint1(k, l) = 26;
                    end
                elseif cen ~= 37 && cen ~= 38
                    if cen ~= 0 && cen ~= 24 && cen ~= 7 && cen ~= 6 && (isBiomeOceanic(n) || isBiomeOceanic(w) || isBiomeOceanic(e) || isBiomeOceanic(s))
                        aint1(k, l) = 16;
                    else
                        aint1(k, l) = cen;
                    end
                else
                    if ~isBiomeOceanic(n) && ~isBiomeOceanic(w) && ~isBiomeOceanic(e) && ~isBiomeOceanic(s) && (~isMesa(n) || ~isMesa(w) || ~isMesa(e) || ~isMesa(s))
                        aint1(k, l) = 2;
                    else
                        aint1(k, l) = cen;
                    end
                end
            else
                if isBiomeOceanic(cen) || ~isBiomeOceanic(n) && ~isBiomeOceanic(w) && ~isBiomeOceanic(e) && ~isBiomeOceanic(s)
                    aint1(k, l) = cen;
                else
                    aint1(k, l) = 25;
                end
            end
        end
    end
end