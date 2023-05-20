function noise = Octaves(x, y, z, width, depth, height, scaleX, scaleY, scaleZ, count)
    if depth == 1
        noise = zeros(height, width);
    else
        noise = zeros(height, depth, width);
    end
    scale = 1;
    for i = 1 : count % 每次循环频率减半，振幅加倍
        xScaled = mod(x * scale * scaleX, 16777216);
        yScaled = mod(y * scale * scaleY, 16777216);
        zScaled = mod(z * scale * scaleZ, 16777216);
        mulScaleX = scaleX * scale;
        mulScaleY = scaleY * scale;
        mulScaleZ = scaleZ * scale;
        noise = Improved(noise, xScaled, yScaled, zScaled, width, depth, height, mulScaleX, mulScaleY, mulScaleZ, scale);
        scale = scale / 2;
    end
end