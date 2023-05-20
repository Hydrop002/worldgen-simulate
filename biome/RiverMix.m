function [aint2, para, para1] = RiverMix(aint, aint1, x2, z2, width2, height2, ~)
%     global useSeed;
    if isempty(aint) || isempty(aint1)
        aint2 = [];
        para = [x2, z2, width2, height2];
        para1 = [x2, z2, width2, height2];
        return;
    else
        para = [];
        para1 = [];
    end
    aint2 = zeros(height2, width2);
    for k = 1 : height2
        for l = 1 : width2
%             if useSeed
%                 chunkSeed = initChunkSeed(x2 + l, z2 + k, worldGenSeed);
%                 rng(chunkSeed);
%             end
            cen = aint(k, l);
            cen1 = aint1(k, l);
            aint2(k, l) = cen;
            if cen ~= 0 && cen ~= 24 && cen1 == 7
                if cen == 12
                    aint2(k, l) = 11;
                elseif cen ~= 14 && cen ~= 15
                    aint2(k, l) = cen1;
                else
                    aint2(k, l) = 15;
                end
            end
        end
    end
end