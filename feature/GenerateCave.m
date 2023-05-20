function ablock = GenerateCave(nearChunkX, nearChunkZ, chunkX, chunkZ, ablock)
    global CW;
    global CH;
    count = randi(randi(randi(15))) - 1;
    if randi(7) ~= 1
        count = 0;
    end
    for i = 1 : count % 1/7����ִ��0-14�Σ����������ƫ��
        x = nearChunkX * CW + randi(CW) - 1; % ��Ѩ������ʼ����
        y = randi(randi([8, 127])) - 1; % �ͺ��θ��������ɶ�Ѩ
        z = nearChunkZ * CH + randi(CH) - 1;
        branch = 1;
        if randi(4) == 1 % 1/4�������ɷ��䣬ͬʱ����ͨ���ķ�֧��
            ablock = AddCaveRoom(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z);
            branch = branch + randi([0, 3]);
        end
        for j = 1 : branch
            yaw = rand() * pi * 2; % �����ʼˮƽ����
            pitch = (rand() - 0.5) / 4; % �����ʼ��ֱ���򣬽�Ϊƽ��
            radius = rand() * 2 + rand(); % �����ʼ�뾶
            if randi(10) == 1 % 1/10�������Ӷ�Ѩ�ĳ�ʼ�뾶
                radius = radius * (rand() * rand() * 3 + 1);
            end
            ablock = AddCaveTunnel(randi(2 ^ 32) - 1, chunkX, chunkZ, ablock, x, y, z, radius, yaw, pitch, 0, 0, 1);
        end
    end
end