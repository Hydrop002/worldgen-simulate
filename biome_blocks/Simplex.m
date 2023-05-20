function noise = Simplex(noise, x, z, width, height, mulScaleX, mulScaleZ, mul)
    seedX = rand() * 256;
    seedZ = rand() * 256;
    rperm = randperm(256);
    rperm = [rperm, rperm];
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
    ];
    K = (3 - sqrt(3)) / 6;
    K_inverse = (sqrt(3) - 1) / 2;
    for i = 1 : height
        rz = (z + i - 1) * mulScaleZ + seedZ;
        for j = 1 : width
            rx = (x + j - 1) * mulScaleX + seedX;
            add = (rz + rx) * K_inverse;
            rxSq = floor(rx + add); % 原正方形晶格格点
            rzSq = floor(rz + add);
            subtract = (rxSq + rzSq) * K;
            rxTri = rxSq - subtract; % 当前三角晶格格点
            rzTri = rzSq - subtract;
            dx1 = rx - rxTri; % 左下距离向量（x右z上）
            dz1 = rz - rzTri;
            if dx1 > dz1 % 右下三角形
                xdiff = 1;
                zdiff = 0;
            else % 左上三角形
                xdiff = 0;
                zdiff = 1;
            end
            dx2 = dx1 - xdiff + K; % 右下/左上距离向量
            dz2 = dz1 - zdiff + K;
            dx3 = dx1 - 1 + 2 * K; % 右上距离向量
            dz3 = dz1 - 1 + 2 * K;
            rxi = mod(rxSq, 256);
            rzi = mod(rzSq, 256);
            ri1 = mod(rperm(rperm(rzi + 1) + rxi), 12) + 1;
            ri2 = mod(rperm(rperm(rzi + zdiff + 1) + rxi + xdiff), 12) + 1;
            ri3 = mod(rperm(rperm(rzi + 2) + rxi + 1), 12) + 1;
            w1 = 0.5 - dx1 * dx1 - dz1 * dz1;
            if w1 < 0
                dp1 = 0;
            else
                dp1 = w1 ^ 4 * (vec3pool(ri1, 1 : 2) * [dx1; dz1]);
            end
            w2 = 0.5 - dx2 * dx2 - dz2 * dz2;
            if w2 < 0
                dp2 = 0;
            else
                dp2 = w2 ^ 4 * (vec3pool(ri2, 1 : 2) * [dx2; dz2]);
            end
            w3 = 0.5 - dx3 * dx3 - dz3 * dz3;
            if w3 < 0
                dp3 = 0;
            else
                dp3 = w3 ^ 4 * (vec3pool(ri3, 1 : 2) * [dx3; dz3]);
            end
            noise(i, j) = noise(i, j) + 70 * (dp1 + dp2 + dp3) * mul;
        end
    end
end