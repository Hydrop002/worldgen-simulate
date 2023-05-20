function ablock = AddCaveTunnel(seed, chunkX, chunkZ, ablock, x, y, z, radius, yaw, pitch, index, count, heightFactor)
    global CW;
    global CH;
    global aint;
    global biomeBlock;
    rng(seed);
    centerX = chunkX * CW + CW / 2;
    centerZ = chunkZ * CH + CH / 2;
    yawDiff = 0;
    pitchDiff = 0;
    if count <= 0 % 洞穴尝试挖掘次数，影响洞穴的长度
        count = randi([85, 112]);
    end
    isRoom = 0;
    if index == -1 % 房间从长度的一半开始生成（避免偏离初始位置过远）
        index = fix(count / 2);
        isRoom = 1;
    end
    fork = randi(fix(count / 2)) - 1 + fix(count / 4); % 分叉点，位于洞穴长度1/4-3/4内的随机位置
    while index < count
        horRadius = 1.5 + sin(index / count * pi) * radius; % 实际半径在初始半径的基础上随当前长度变化，中间宽，两头窄
        verRadius = horRadius * heightFactor; % 房间的高度为宽度的一半
        x = x + cos(yaw) * cos(pitch); % 挖掘位置朝着指定方向移动一个单位长度
        y = y + sin(pitch);
        z = z + sin(yaw) * cos(pitch);
        if randi(6) == 1 % 限制俯仰角，避免大量竖直洞穴
            pitch = pitch * 0.92;
        else
            pitch = pitch * 0.7;
        end
        pitch = pitch + pitchDiff * 0.1;
        yaw = yaw + yawDiff * 0.1;
        pitchDiff = pitchDiff * 0.9 + (rand() - rand()) * rand() * 2;
        yawDiff = yawDiff * 0.75 + (rand() - rand()) * rand() * 4;
        if (~isRoom && index == fork && radius > 1) % 初始半径较大的洞穴在分叉点处分叉，分叉后的初始半径减小（不会进一步分叉），两个新的偏航角分别与原偏航角垂直，俯仰角除以3
            ablock = AddCaveTunnel(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z, rand() * 0.5 + 0.5, yaw - pi / 2, pitch / 3, index, count, 1);
            ablock = AddCaveTunnel(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z, rand() * 0.5 + 0.5, yaw + pi / 2, pitch / 3, index, count, 1);
            break;
        end
        if isRoom || randi(4) ~= 1 % 房间必定生成，通道有3/4概率生成
            offsetX = x - centerX;
            offsetZ = z - centerZ;
            rest = count - index; % 剩余长度越小越容易停止生成
            dist = radius + 2 + CW; % 初始半径越小越容易停止生成
            if offsetX ^ 2 + offsetZ ^ 2 > rest ^ 2 + dist ^ 2 % 挖掘位置与区块中心的距离过大时停止对该区块的生成
                break;
            end
            if offsetX >= -CW - horRadius * 2 && offsetZ >= -CH - horRadius * 2 && offsetX <= CW + horRadius * 2 && offsetZ <= CH + horRadius * 2 % 进一步限制挖掘位置，否则进入下一轮循环
                minOffsetX = max(floor(x - horRadius) - chunkX * CW - 1, 0); % 相对区块最小点坐标
                maxOffsetX = min(floor(x + horRadius) - chunkX * CW, CW - 1);
                minOffsetY = max(floor(y - verRadius) - 1, 1);
                maxOffsetY = min(floor(y + verRadius) + 1, 248);
                minOffsetZ = max(floor(z - horRadius) - chunkZ * CH - 1, 0);
                maxOffsetZ = min(floor(z + horRadius) - chunkZ * CH, CH - 1);
                detectWater = 0;
                for i = minOffsetX : maxOffsetX % 检测方形盒的边界是否存在水
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
                            if k ~= minOffsetY - 1 && i ~= minOffsetX && i ~= maxOffsetX && j ~= minOffsetZ && j ~= maxOffsetZ % 不检测方形盒内部
                                k = minOffsetY;
                            end
                            k = k - 1;
                        end
                    end
                end
                if ~detectWater % 检测到水时不生成
                    for i = minOffsetX : maxOffsetX
                        worldX = chunkX * CW + i;
                        offsetRatioX = (worldX + 0.5 - x) / horRadius;
                        for j = minOffsetZ : maxOffsetZ
                            worldZ = chunkZ * CH + j;
                            offsetRatioZ = (worldZ + 0.5 - z) / horRadius;
                            if offsetRatioX ^ 2 + offsetRatioZ ^ 2 < 1 % 优化性能
                                foundTop = 0;
                                for k = maxOffsetY : -1 : minOffsetY + 1
                                    offsetRatioY = (k - 0.5 - y) / verRadius;
                                    if offsetRatioY > -0.7 && offsetRatioX ^ 2 + offsetRatioY ^ 2 + offsetRatioZ ^ 2 < 1 % 取方形盒的内切球并截去一部分底部，使洞穴的地面更加平坦
                                        block = ablock(j + 1, k + 1, i + 1);
                                        if worldX >= 0 && worldZ >= 0 && worldX < CW && worldZ < CH
                                            biome = aint(worldZ + 1, worldX + 1);
                                        else
                                            biome = 0;
                                        end
                                        if biome == 14 || biome == 16 || biome == 2 % 蘑菇岛、沙滩、沙漠地表不会出现洞穴入口
                                            topBlock = 2; % 草方块
                                            fillerBlock = 3; % 泥土
                                        else
                                            topBlock = biomeBlock(biome + 1, 1);
                                            fillerBlock = biomeBlock(biome + 1, 2);
                                        end
                                        if block == topBlock
                                            foundTop = 1;
                                        end
                                        if block == 1 || block == fillerBlock || block == topBlock % 洞穴会替换石头、填充层和顶层方块
                                            if k <= 10 % 洞穴y<=10的位置生成岩浆
                                                ablock(j + 1, k + 1, i + 1) = 11;
                                            else
                                                ablock(j + 1, k + 1, i + 1) = 0;
                                                if foundTop && ablock(j + 1, k, i + 1) == fillerBlock % 洞穴穿过了顶层方块，将下方的填充层方块替换为顶层方块
                                                    ablock(j + 1, k, i + 1) = topBlock;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if isRoom % 房间只挖掘一次
                        break;
                    end
                end
            end
        end
        index = index + 1;
    end
end