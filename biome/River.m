function [aint1, para] = River(aint, x1, z1, width1, height1, ~)
%     global useSeed
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
            n = riverFilter(aint(k, l + 1));
            w = riverFilter(aint(k + 1, l));
            e = riverFilter(aint(k + 1, l + 2));
            s = riverFilter(aint(k + 2, l + 1));
            cen = riverFilter(aint(k + 1, l + 1));
            if cen == n && cen == w && cen == e && cen == s
                aint1(k, l) = -1;
            else
                aint1(k, l) = 7;
            end
        end
    end
end 