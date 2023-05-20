function aint = Island(x, z, width, height, worldGenSeed)
    global useSeed;
    aint = zeros(height, width);
    for k = 1 : height
        for l = 1 : width
            if useSeed
                chunkSeed = initChunkSeed(x + l, z + k, worldGenSeed);
                rng(chunkSeed);
            end
            if randi(10) == 1
                aint(k, l) = 1;
            else
                aint(k, l) = 0;
            end
        end
    end
    if x > -width && x <= 0 && z > -height && z <= 0
        aint(-z + 1, -x + 1) = 1;
    end
end