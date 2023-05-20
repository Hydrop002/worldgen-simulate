function [aint1, para] = EdgeCoolWarm(aint, x1, z1, width1, height1, ~)
%     global useSeed;
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
%             if useSeed
%                 chunkSeed = initChunkSeed(x1 + l, z1 + k, worldGenSeed);
%                 rng(chunkSeed);
%             end
            cen = aint(k + 1, l + 1);
            aint1(k, l) = cen;
            if cen == 1
                n = aint(k, l + 1);
                w = aint(k + 1, l);
                e = aint(k + 1, l + 2);
                s = aint(k + 2, l + 1);
                if n == 3 || w == 3 || e == 3 || s == 3 || n == 4 || w == 4 || e == 4 || s == 4
                    aint1(k, l) = 2;
                end
            end
        end
    end
end