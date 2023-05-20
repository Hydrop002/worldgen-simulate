function ablock = GenerateCave(nearChunkX, nearChunkZ, chunkX, chunkZ, ablock)
    global CW;
    global CH;
    count = randi(randi(randi(15))) - 1;
    if randi(7) ~= 1
        count = 0;
    end
    for i = 1 : count % 1/7概率执行0-14次，次数大概率偏低
        x = nearChunkX * CW + randi(CW) - 1; % 洞穴生成起始坐标
        y = randi(randi([8, 127])) - 1; % 低海拔更容易生成洞穴
        z = nearChunkZ * CH + randi(CH) - 1;
        branch = 1;
        if randi(4) == 1 % 1/4概率生成房间，同时增加通道的分支数
            ablock = AddCaveRoom(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z);
            branch = branch + randi([0, 3]);
        end
        for j = 1 : branch
            yaw = rand() * pi * 2; % 随机初始水平方向
            pitch = (rand() - 0.5) / 4; % 随机初始垂直方向，较为平缓
            radius = rand() * 2 + rand(); % 随机初始半径
            if randi(10) == 1 % 1/10概率增加洞穴的初始半径
                radius = radius * (rand() * rand() * 3 + 1);
            end
            ablock = AddCaveTunnel(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z, radius, yaw, pitch, 0, 0, 1);
        end
    end
end