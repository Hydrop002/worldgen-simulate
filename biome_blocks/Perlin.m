function noise = Perlin(x, z, width, height, scaleX, scaleZ, globalScaleFactor, scaleFactor, count)
    noise = zeros(height, width);
    globalScale = 1; % 不影响振幅
    scale = 1;
    for i = 1 : count % 每次循环频率减小，振幅增加
        mulScaleX = scaleX * globalScale * scale;
        mulScaleZ = scaleZ * globalScale * scale;
        noise = Simplex(noise, x, z, width, height, mulScaleX, mulScaleZ, 0.55 / scale);
        globalScale = globalScale * globalScaleFactor;
        scale = scale * scaleFactor;
    end
end