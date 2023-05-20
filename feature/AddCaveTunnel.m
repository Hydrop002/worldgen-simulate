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
    if count <= 0 % ��Ѩ�����ھ������Ӱ�춴Ѩ�ĳ���
        count = randi([85, 112]);
    end
    isRoom = 0;
    if index == -1 % ����ӳ��ȵ�һ�뿪ʼ���ɣ�����ƫ���ʼλ�ù�Զ��
        index = fix(count / 2);
        isRoom = 1;
    end
    fork = randi(fix(count / 2)) - 1 + fix(count / 4); % �ֲ�㣬λ�ڶ�Ѩ����1/4-3/4�ڵ����λ��
    while index < count
        horRadius = 1.5 + sin(index / count * pi) * radius; % ʵ�ʰ뾶�ڳ�ʼ�뾶�Ļ������浱ǰ���ȱ仯���м����ͷխ
        verRadius = horRadius * heightFactor; % ����ĸ߶�Ϊ��ȵ�һ��
        x = x + cos(yaw) * cos(pitch); % �ھ�λ�ó���ָ�������ƶ�һ����λ����
        y = y + sin(pitch);
        z = z + sin(yaw) * cos(pitch);
        if randi(6) == 1 % ���Ƹ����ǣ����������ֱ��Ѩ
            pitch = pitch * 0.92;
        else
            pitch = pitch * 0.7;
        end
        pitch = pitch + pitchDiff * 0.1;
        yaw = yaw + yawDiff * 0.1;
        pitchDiff = pitchDiff * 0.9 + (rand() - rand()) * rand() * 2;
        yawDiff = yawDiff * 0.75 + (rand() - rand()) * rand() * 4;
        if (~isRoom && index == fork && radius > 1) % ��ʼ�뾶�ϴ�Ķ�Ѩ�ڷֲ�㴦�ֲ棬�ֲ��ĳ�ʼ�뾶��С�������һ���ֲ棩�������µ�ƫ���Ƿֱ���ԭƫ���Ǵ�ֱ�������ǳ���3
            ablock = AddCaveTunnel(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z, rand() * 0.5 + 0.5, yaw - pi / 2, pitch / 3, index, count, 1);
            ablock = AddCaveTunnel(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z, rand() * 0.5 + 0.5, yaw + pi / 2, pitch / 3, index, count, 1);
            break;
        end
        if isRoom || randi(4) ~= 1 % ����ض����ɣ�ͨ����3/4��������
            offsetX = x - centerX;
            offsetZ = z - centerZ;
            rest = count - index; % ʣ�೤��ԽСԽ����ֹͣ����
            dist = radius + 2 + CW; % ��ʼ�뾶ԽСԽ����ֹͣ����
            if offsetX ^ 2 + offsetZ ^ 2 > rest ^ 2 + dist ^ 2 % �ھ�λ�����������ĵľ������ʱֹͣ�Ը����������
                break;
            end
            if offsetX >= -CW - horRadius * 2 && offsetZ >= -CH - horRadius * 2 && offsetX <= CW + horRadius * 2 && offsetZ <= CH + horRadius * 2 % ��һ�������ھ�λ�ã����������һ��ѭ��
                minOffsetX = max(floor(x - horRadius) - chunkX * CW - 1, 0); % ���������С������
                maxOffsetX = min(floor(x + horRadius) - chunkX * CW, CW - 1);
                minOffsetY = max(floor(y - verRadius) - 1, 1);
                maxOffsetY = min(floor(y + verRadius) + 1, 248);
                minOffsetZ = max(floor(z - horRadius) - chunkZ * CH - 1, 0);
                maxOffsetZ = min(floor(z + horRadius) - chunkZ * CH, CH - 1);
                detectWater = 0;
                for i = minOffsetX : maxOffsetX % ��ⷽ�κеı߽��Ƿ����ˮ
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
                            if k ~= minOffsetY - 1 && i ~= minOffsetX && i ~= maxOffsetX && j ~= minOffsetZ && j ~= maxOffsetZ % ����ⷽ�κ��ڲ�
                                k = minOffsetY;
                            end
                            k = k - 1;
                        end
                    end
                end
                if ~detectWater % ��⵽ˮʱ������
                    for i = minOffsetX : maxOffsetX
                        worldX = chunkX * CW + i;
                        offsetRatioX = (worldX + 0.5 - x) / horRadius;
                        for j = minOffsetZ : maxOffsetZ
                            worldZ = chunkZ * CH + j;
                            offsetRatioZ = (worldZ + 0.5 - z) / horRadius;
                            if offsetRatioX ^ 2 + offsetRatioZ ^ 2 < 1 % �Ż�����
                                foundTop = 0;
                                for k = maxOffsetY : -1 : minOffsetY + 1
                                    offsetRatioY = (k - 0.5 - y) / verRadius;
                                    if offsetRatioY > -0.7 && offsetRatioX ^ 2 + offsetRatioY ^ 2 + offsetRatioZ ^ 2 < 1 % ȡ���κе������򲢽�ȥһ���ֵײ���ʹ��Ѩ�ĵ������ƽ̹
                                        block = ablock(j + 1, k + 1, i + 1);
                                        if worldX >= 0 && worldZ >= 0 && worldX < CW && worldZ < CH
                                            biome = aint(worldZ + 1, worldX + 1);
                                        else
                                            biome = 0;
                                        end
                                        if biome == 14 || biome == 16 || biome == 2 % Ģ������ɳ̲��ɳĮ�ر�����ֶ�Ѩ���
                                            topBlock = 2; % �ݷ���
                                            fillerBlock = 3; % ����
                                        else
                                            topBlock = biomeBlock(biome + 1, 1);
                                            fillerBlock = biomeBlock(biome + 1, 2);
                                        end
                                        if block == topBlock
                                            foundTop = 1;
                                        end
                                        if block == 1 || block == fillerBlock || block == topBlock % ��Ѩ���滻ʯͷ������Ͷ��㷽��
                                            if k <= 10 % ��Ѩy<=10��λ�������ҽ�
                                                ablock(j + 1, k + 1, i + 1) = 11;
                                            else
                                                ablock(j + 1, k + 1, i + 1) = 0;
                                                if foundTop && ablock(j + 1, k, i + 1) == fillerBlock % ��Ѩ�����˶��㷽�飬���·������㷽���滻Ϊ���㷽��
                                                    ablock(j + 1, k, i + 1) = topBlock;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if isRoom % ����ֻ�ھ�һ��
                        break;
                    end
                end
            end
        end
        index = index + 1;
    end
end