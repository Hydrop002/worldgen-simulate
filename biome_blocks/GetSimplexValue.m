function value = GetSimplexValue(xScaled, zScaled)
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
    add = (xScaled + zScaled) * K_inverse;
    xSq = floor(xScaled + add);
    zSq = floor(zScaled + add);
    subtract = (xSq + zSq) * K;
    xTri = xSq - subtract;
    zTri = zSq - subtract;
    dx1 = xScaled - xTri;
    dz1 = zScaled - zTri;
    if dx1 > dz1
        xdiff = 1;
        zdiff = 0;
    else
        xdiff = 0;
        zdiff = 1;
    end
    dx2 = dx1 - xdiff + K;
    dz2 = dz1 - zdiff + K;
    dx3 = dx1 - 1 + 2 * K;
    dz3 = dz1 - 1 + 2 * K;
    xi = mod(xSq, 256);
    zi = mod(zSq, 256);
    ri1 = mod(rperm(rperm(zi + 1) + xi), 12) + 1;
    ri2 = mod(rperm(rperm(zi + zdiff + 1) + xi + xdiff), 12) + 1;
    ri3 = mod(rperm(rperm(zi + 2) + xi + 1), 12) + 1;
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
    value = 70 * (dp1 + dp2 + dp3);
end