function [aint2, para] = VoronoiZoom(aint, x2, z2, width2, height2, worldGenSeed)
    global useSeed;
    x2 = x2 - 2;
    z2 = z2 - 2;
    x = floor(x2 / 4);
    z = floor(z2 / 4);
    width = floor(width2 / 4) + 2;
    height = floor(height2 / 4) + 2;
    if isempty(aint)
        aint2 = [];
        para = [x, z, width, height];
        return;
    else
        para = [];
    end
    width1 = (width - 1) * 4;
    height1 = (height - 1) * 4;
    aint1 = zeros(height1, width1);
    for k = 1 : height - 1
        for l = 1 : width - 1
            nw = aint(k, l);
            ne = aint(k, l + 1);
            sw = aint(k + 1, l);
            se = aint(k + 1, l + 1);
            if useSeed
                chunkSeed = initChunkSeed((x + l) * 4, (z + k) * 4, worldGenSeed);
                rng(chunkSeed);
            end
            sex = ((randi(1024) - 1) / 1024 - 0.5) * 3.6;
            sez = ((randi(1024) - 1) / 1024 - 0.5) * 3.6;
            if useSeed
                chunkSeed = initChunkSeed((x + l + 1) * 4, (z + k) * 4, worldGenSeed);
                rng(chunkSeed);
            end
            swx = ((randi(1024) - 1) / 1024 - 0.5) * 3.6 + 4;
            swz = ((randi(1024) - 1) / 1024 - 0.5) * 3.6;
            if useSeed
                chunkSeed = initChunkSeed((x + l) * 4, (z + k + 1) * 4, worldGenSeed);
                rng(chunkSeed);
            end
            nex = ((randi(1024) - 1) / 1024 - 0.5) * 3.6;
            nez = ((randi(1024) - 1) / 1024 - 0.5) * 3.6 + 4;
            if useSeed
                chunkSeed = initChunkSeed((x + l + 1) * 4, (z + k + 1) * 4, worldGenSeed);
                rng(chunkSeed);
            end
            nwx = ((randi(1024) - 1) / 1024 - 0.5) * 3.6 + 4;
            nwz = ((randi(1024) - 1) / 1024 - 0.5) * 3.6 + 4;
            for m = 0 : 3
                for n = 0 : 3
                    sed = (n - sex) ^ 2 + (m - sez) ^ 2;
                    swd = (n - swx) ^ 2 + (m - swz) ^ 2;
                    ned = (n - nex) ^ 2 + (m - nez) ^ 2;
                    nwd = (n - nwx) ^ 2 + (m - nwz) ^ 2;
                    if sed < swd && sed < ned && sed < nwd
                        aint1(4 * k - 3 + m, 4 * l - 3 + n) = nw;
                    elseif swd < sed && swd < ned && swd < nwd
                        aint1(4 * k - 3 + m, 4 * l - 3 + n) = ne;
                    elseif ned < sed && ned < swd && ned < nwd
                        aint1(4 * k - 3 + m, 4 * l - 3 + n) = sw;
                    else
                        aint1(4 * k - 3 + m, 4 * l - 3 + n) = se;
                    end
                end
            end
        end
    end
    aint2 = aint1((1 : height2) + mod(z2, 4), (1 : width2) + mod(x2, 4));
end