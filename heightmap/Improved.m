function noise = Improved(noise, xScaled, yScaled, zScaled, width, depth, height, mulScaleX, mulScaleY, mulScaleZ, scale)
    seedX = rand() * 256; % 每次叠加晶格未必对齐
    seedY = rand() * 256;
    seedZ = rand() * 256;
    rperm = randperm(256);
    rperm = [rperm, rperm];
    vec2pool = [
        1, 0;
        -1, 0;
        1, 0;
        -1, 0;
        1, 1;
        -1, 1;
        1, -1;
        -1, -1;
        0, 1;
        0, 1;
        0, -1;
        0, -1;
        1, 0;
        -1, 0;
        0, 1;
        0, -1;
    ];
    vec3pool = [
        1, 1, 0;
        -1, 1, 0;
        1, -1, 0;
        -1, -1, 0;
        1, 0, 1;
        -1, 0, 1;
        1, 0, -1;
        -1, 0, -1;
        0, 1, 1;
        0, -1, 1;
        0, 1, -1;
        0, -1, -1;
        1, 1, 0;
        -1, 1, 0;
        0, -1, 1;
        0, -1, -1
    ];
    ease = @(t) ((6 * t - 15) * t + 10) * t ^ 3;
    lerp = @(t, a, b) a + t * (b - a);
    function dp = grad2(r, x, z)
        r = mod(r, 16) + 1;
        dp = vec2pool(r, :) * [x; z];
    end
    function dp = grad3(r, x, y, z)
        r = mod(r, 16) + 1;
        dp = vec3pool(r, :) * [x; y; z];
    end
    if depth == 1
        for i = 1 : width
            rx = xScaled + i * mulScaleX + seedX; %(x+i)*scaleX*scale+seedX
            rxi = mod(floor(rx), 256); % 同一个晶格内得出相同的值，用于确定格点向量
            dx = rx - floor(rx); % 距离向量
            tx = ease(dx);
            for j = 1 : height
                rz = zScaled + j * mulScaleZ + seedZ;
                rzi = mod(floor(rz), 256);
                dz = rz - floor(rz);
                tz = ease(dz);
                dp00 = grad2(rperm(rperm(rperm(rxi + 1)) + rzi), dx, dz);
                dp10 = grad2(rperm(rperm(rperm(rxi + 2)) + rzi), dx - 1, dz);
                dp01 = grad2(rperm(rperm(rperm(rxi + 1)) + rzi + 1), dx, dz - 1);
                dp11 = grad2(rperm(rperm(rperm(rxi + 2)) + rzi + 1), dx - 1, dz - 1);
                lerpx1 = lerp(tx, dp00, dp10);
                lerpx2 = lerp(tx, dp01, dp11);
                lerpz = lerp(tz, lerpx1, lerpx2);
                noise(j, i) = noise(j, i) + lerpz / scale;
            end
        end
    else
        pre = -1;
        lerpx1 = 0;
        lerpx2 = 0;
        lerpx3 = 0;
        lerpx4 = 0;
        for i = 1 : width
            rx = xScaled + i * mulScaleX + seedX;
            rxi = mod(floor(rx), 256);
            dx = rx - floor(rx);
            tx = ease(dx);
            for j = 1 : height
                rz = zScaled + j * mulScaleZ + seedZ;
                rzi = mod(floor(rz), 256);
                dz = rz - floor(rz);
                tz = ease(dz);
                for k = 1 : depth
                    ry = yScaled + k * mulScaleY + seedY;
                    ryi = mod(floor(ry), 256);
                    dy = ry - floor(ry);
                    ty = ease(dy);
                    if k == 1 || ryi ~= pre
                        pre = ryi;
                        dp000 = grad3(rperm(rperm(rperm(rxi + 1) + ryi) + rzi), dx, dy, dz);
                        dp100 = grad3(rperm(rperm(rperm(rxi + 2) + ryi) + rzi), dx - 1, dy, dz);
                        dp010 = grad3(rperm(rperm(rperm(rxi + 1) + ryi + 1) + rzi), dx, dy - 1, dz);
                        dp110 = grad3(rperm(rperm(rperm(rxi + 2) + ryi + 1) + rzi), dx - 1, dy - 1, dz);
                        dp001 = grad3(rperm(rperm(rperm(rxi + 1) + ryi) + rzi + 1), dx, dy, dz - 1);
                        dp101 = grad3(rperm(rperm(rperm(rxi + 2) + ryi) + rzi + 1), dx - 1, dy, dz - 1);
                        dp011 = grad3(rperm(rperm(rperm(rxi + 1) + ryi + 1) + rzi + 1), dx, dy - 1, dz - 1);
                        dp111 = grad3(rperm(rperm(rperm(rxi + 2) + ryi + 1) + rzi + 1), dx - 1, dy - 1, dz - 1);
                        lerpx1 = lerp(tx, dp000, dp100);
                        lerpx2 = lerp(tx, dp010, dp110);
                        lerpx3 = lerp(tx, dp001, dp101);
                        lerpx4 = lerp(tx, dp011, dp111);
                    end
                    lerpy1 = lerp(ty, lerpx1, lerpx2);
                    lerpy2 = lerp(ty, lerpx3, lerpx4);
                    lerpz = lerp(tz, lerpy1, lerpy2);
                    noise(j, k, i) = noise(j, k, i) + lerpz / scale;
                end
            end
        end
    end
end