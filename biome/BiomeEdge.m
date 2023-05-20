function [aint1, para] = BiomeEdge(aint, x1, z1, width1, height1, worldGenSeed)
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
            if ~compareBiomesById(cen, 3) && cen ~= 38 && cen ~= 39 && cen ~= 32
                if cen == 2
                    if n ~= 12 && w ~= 12 && e ~= 12 && s ~= 12
                        aint1(k, l) = cen;
                    else
                        aint1(k, l) = 34;
                    end
                elseif cen == 6
                    if n ~= 2 && w ~= 2 && e ~= 2 && s ~= 2 && n ~= 30 && w ~= 30 && e ~= 30 && s ~= 30 && n ~= 12 && w ~= 12 && e ~= 12 && s ~= 12
                        if n ~= 21 && w ~= 21 && e ~= 21 && s ~= 21
                            aint1(k, l) = cen;
                        else
                            aint1(k, l) = 23;
                        end
                    else
                        aint1(k, l) = 1;
                    end
                else
                    aint1(k, l) = cen;
                end
            elseif compareBiomesById(cen, 3)
                if canBiomesBeNeighbors(n, 3) && canBiomesBeNeighbors(w, 3) && canBiomesBeNeighbors(e, 3) && canBiomesBeNeighbors(s, 3)
                    aint1(k, l) = cen;
                else
                    aint1(k, l) = 20;
                end
            elseif cen == 38
                if compareBiomesById(n, 38) && compareBiomesById(w, 38) && compareBiomesById(e, 38) && compareBiomesById(s, 38)
                    aint1(k, l) = cen;
                else
                    aint1(k, l) = 37;
                end
            elseif cen == 39
                if compareBiomesById(n, 39) && compareBiomesById(w, 39) && compareBiomesById(e, 39) && compareBiomesById(s, 39)
                    aint1(k, l) = cen;
                else
                    aint1(k, l) = 37;
                end
            else
                if compareBiomesById(n, 32) && compareBiomesById(w, 32) && compareBiomesById(e, 32) && compareBiomesById(s, 32)
                    aint1(k, l) = cen;
                else
                    aint1(k, l) = 5;
                end
            end
        end
    end
end