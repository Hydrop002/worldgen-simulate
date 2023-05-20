function noise = Perlin(x, z, width, height, scaleX, scaleZ, globalScaleFactor, scaleFactor, count)
    noise = zeros(height, width);
    globalScale = 1; % ��Ӱ�����
    scale = 1;
    for i = 1 : count % ÿ��ѭ��Ƶ�ʼ�С���������
        mulScaleX = scaleX * globalScale * scale;
        mulScaleZ = scaleZ * globalScale * scale;
        noise = Simplex(noise, x, z, width, height, mulScaleX, mulScaleZ, 0.55 / scale);
        globalScale = globalScale * globalScaleFactor;
        scale = scale * scaleFactor;
    end
end