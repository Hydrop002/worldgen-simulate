function ablock = AddRavineTunnel(seed, chunkX, chunkZ, ablock, x, y, z, radius, yaw, pitch, index, count, heightFactor)
    global CW;
    global CH;
    global aint;
    global biomeBlock;
    rng(seed);
    centerX = chunkX * CW + CW / 2;
    centerZ = chunkZ * CH + CH / 2;
    yawDiff = 0;
    pitchDiff = 0;
    if count <= 0
        count = randi([85, 112]);
    end
    r = 1;
    narrowFactor = zeros(256, 1);
    for i = 1 : 256
        if i == 1 || randi(3) == 1
            r = (1 + rand() * rand()) ^ 2; % [1,4]
        end
        narrowFactor(i) = r;
    end
    while index < count
        horRadius = 1.5 + sin(index / count * pi) * radius; % 中间宽，两头窄
        verRadius = horRadius * heightFactor;
        horRadius = horRadius * (rand() * 0.25 + 0.75);
        verRadius = verRadius * (rand() * 0.25 + 0.75);
        x = x + cos(yaw) * cos(pitch);
        y = y + sin(pitch);
        z = z + sin(yaw) * cos(pitch);
        pitch = pitch * 0.7 + pitchDiff * 0.05;
        yaw = yaw + yawDiff * 0.05;
        pitchDiff = pitchDiff * 0.8 + (rand() - rand()) * rand() * 2;
        yawDiff = yawDiff * 0.5 + (rand() - rand()) * rand() * 4;
        if randi(4) ~= 1
            offsetX = x - centerX;
            offsetZ = z - centerZ;
            rest = count - index;
            dist = radius + 2 + CW;
            if offsetX ^ 2 + offsetZ ^ 2 > rest ^ 2 + dist ^ 2
                break;
            end
            if offsetX >= -CW - horRadius * 2 && offsetZ >= -CH - horRadius * 2 && offsetX <= CW + horRadius * 2 && offsetZ <= CH + horRadius * 2
                minOffsetX = max(floor(x - horRadius) - chunkX * CW - 1, 0);
                maxOffsetX = min(floor(x + horRadius) - chunkX * CW, CW - 1);
                minOffsetY = max(floor(y - verRadius) - 1, 1);
                maxOffsetY = min(floor(y + verRadius) + 1, 248);
                minOffsetZ = max(floor(z - horRadius) - chunkZ * CH - 1, 0);
                maxOffsetZ = min(floor(z + horRadius) - chunkZ * CH, CH - 1);
                detectWater = 0;
                for i = minOffsetX : maxOffsetX
                    if detectWater
                        break;
                    end
                    for j = minOffsetZ : maxOffsetZ
                        if detectWater
                            break;
                        end
                        k = maxOffsetY + 1;
                        while ~detectWater && k >= minOffsetY - 1
                            block = ablock(j + 1, k + 1, i + 1);
                            if block == 8 || block == 9
                                detectWater = 1;
                            end
                            if k ~= minOffsetY - 1 && i ~= minOffsetX && i ~= maxOffsetX && j ~= minOffsetZ && j ~= maxOffsetZ
                                k = minOffsetY;
                            end
                            k = k - 1;
                        end
                    end
                end
                if ~detectWater
                    for i = minOffsetX : maxOffsetX
                        worldX = chunkX * CW + i;
                        offsetRatioX = (worldX + 0.5 - x) / horRadius;
                        for j = minOffsetZ : maxOffsetZ
                            worldZ = chunkZ * CH + j;
                            offsetRatioZ = (worldZ + 0.5 - z) / horRadius;
                            if offsetRatioX ^ 2 + offsetRatioZ ^ 2 < 1
                                foundTop = 0;
                                for k = maxOffsetY : -1 : minOffsetY + 1
                                    offsetRatioY = (k - 0.5 - y) / verRadius;
                                    if (offsetRatioX ^ 2 + offsetRatioZ ^ 2) * narrowFactor(k) + offsetRatioY ^ 2 / 6 < 1 % 截去顶部和底部的椭球
                                        block = ablock(j + 1, k + 1, i + 1);
                                        if worldX >= 0 && worldZ >= 0 && worldX < CW && worldZ < CH
                                            biome = aint(worldZ + 1, worldX + 1);
                                        else
                                            biome = 0;
                                        end
                                        if biome == 14 || biome == 16 || biome == 2
                                            topBlock = 2;
                                            fillerBlock = 3;
                                        else
                                            topBlock = biomeBlock(biome + 1, 1);
                                            fillerBlock = biomeBlock(biome + 1, 2);
                                        end
                                        if block == topBlock
                                            foundTop = 1;
                                        end
                                        if block == 1 || block == fillerBlock || block == topBlock
                                            if k <= 10 % 峡谷y<=10的位置生成流动岩浆
                                                ablock(j + 1, k + 1, i + 1) = 10;
                                            else
                                                ablock(j + 1, k + 1, i + 1) = 0;
                                                if foundTop && ablock(j + 1, k, i + 1) == fillerBlock
                                                    ablock(j + 1, k, i + 1) = topBlock;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        index = index + 1;
    end
end