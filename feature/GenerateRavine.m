function ablock = GenerateRavine(nearChunkX, nearChunkZ, chunkX, chunkZ, ablock)
    global CW;
    global CH;
    if randi(50) == 1
        x = nearChunkX * CW + randi(CW) - 1; % 峡谷生成起始坐标
        y = randi(randi([8, 47])) + 19;
        z = nearChunkZ * CH + randi(CH) - 1;
        yaw = rand() * pi * 2;
        pitch = (rand() - 0.5) / 4;
        radius = (rand() * 2 + rand()) * 2;
        ablock = AddRavineTunnel(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z, radius, yaw, pitch, 0, 0, 3);
    end
end