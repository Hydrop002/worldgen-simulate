rng('shuffle');
% rng(0);

height = [
    -1, 0.1; % Ocean
    0.125, 0.05; % Plains
    0.125, 0.05; % Desert
    1, 0.5; % Extreme Hills
    0.1, 0.2; % Forest
    0.2, 0.2; % Taiga
    -0.2, 0.1; % Swampland
    -0.5, 0; % River
    zeros(3, 2);
    -0.5, 0; % FrozenRiver
    0.125, 0.05; % Ice Plains
    0.45, 0.3; % Ice Mountains
    0.2, 0.3; % MushroomIsland
    0, 0.025; % MushroomIslandShore
    0, 0.025; % Beach
    0.45, 0.3; % DesertHills
    0.45, 0.3; % ForestHills
    0.45, 0.3; % TaigaHills
    0.8, 0.3; % Extreme Hills Edge
    0.1, 0.2; % Jungle
    0.45, 0.3; % JungleHills
    0.1, 0.2; % JungleEdge
    -1.8, 0.1; % Deep Ocean
    0.1, 0.8; % Stone Beach
    0, 0.025; % Cold Beach
    0.1, 0.2; % Birch Forest
    0.45, 0.3; % Birch Forest Hills
    0.1, 0.2; % Roofed Forest
    0.2, 0.2; % Cold Taiga
    0.45, 0.3; % Cold Taiga Hills
    0.2, 0.2; % Mega Taiga
    0.45, 0.3; % Mega Taiga Hills
    1, 0.5; % Extreme Hills+
    0.125, 0.05; % Savanna
    1.5, 0.025; % Savanna Plateau
    0.1, 0.2; % Mesa
    1.5, 0.025; % Mesa Plateau F
    1.5, 0.025; % Mesa Plateau
    zeros(89, 2);
    0.125, 0.05; % Sunflower Plains
    0.225, 0.25; % Desert M
    1, 0.5; % Extreme Hills M
    0.1, 0.4; % Flower Forest
    0.3, 0.4; % Taiga M
    -0.1, 0.3; % Swampland M
    zeros(5, 2);
    0.525, 0.55; % Ice Plains Spikes
    zeros(8, 2);
    0.2, 0.4; % Jungle M
    zeros(1, 2);
    0.2, 0.4; % JungleEdge M
    zeros(3, 2);
    0.2, 0.4; % Birch Forest M
    0.55, 0.5; % Birch Forest Hills M
    0.2, 0.4; % Roofed Forest M
    0.3, 0.4; % Cold Taiga M
    zeros(1, 2);
    0.2, 0.2; % Mega Spruce Taiga
    0.45, 0.3; % Mega Taiga Hills M
    1, 0.5; % Extreme Hills+ M
    0.3625, 1.225; % Savanna M
    1.05, 1.2125; % Savanna Plateau M
    0.1, 0.2; % Mesa (Bryce)
    0.45, 0.3; % Mesa Plateau F M
    0.45, 0.3; % Mesa Plateau M
];
map = [
    240, 240, 240 % air
    112, 112, 112 % stone
    zeros(7, 3)
    64, 64, 255 % water
] / 255;

CX = 0;
CZ = 0;
CW = 512;
CH = 512;
CD = 256;
UW = 4;
UH = 4;
UD = 8;
global WorldType;
WorldType = 0; % 0:default,1:flat,2:largeBiomes,3:amplified,8:default_1_1
seaLevel = 64;

mapWidth = CW / UW + 1;
mapHeight = CH / UH + 1;
mapDepth = CD / UD + 1;
if ~exist('aint', 'var')
    aint = zeros(mapHeight + 5, mapWidth + 5);
end

if ~exist('depthNoise', 'var')
    depthNoise = Octaves(CX * 4, 10, CZ * 4, mapWidth, 1, mapHeight, 200, 1, 200, 16) / 8000; % [-8.191875,8.191875]
    mainNoise = Octaves(CX * 4, 0, CZ * 4, mapWidth, mapDepth, mapHeight, 8.55515, 4.277575, 8.55515, 8) / 20 + 0.5; % [-13.25,13.25]
    minNoise = Octaves(CX * 4, 0, CZ * 4, mapWidth, mapDepth, mapHeight, 684.412, 684.412, 684.412, 16) / 512; % [-127.998046875,127.998046875]
    maxNoise = Octaves(CX * 4, 0, CZ * 4, mapWidth, mapDepth, mapHeight, 684.412, 684.412, 684.412, 16) / 512; % [-127.998046875,127.998046875]
end
biomeWeight = zeros(5, 5); % 用于生物群系间高度过渡的权重图
for i = -2 : 2
    for j = -2 : 2
        biomeWeight(i + 3, j + 3) = 10 / sqrt(i ^ 2 + j ^ 2 + 0.2);
    end
end
heightMap = zeros(mapHeight, mapDepth, mapWidth); % 3维密度图
for i = 1 : mapWidth
    for j = 1 : mapHeight
        cenBiome = aint(j + 2, i + 2);
        averageHeightVariation = 0; % 周围群系高度变化的加权平均
        averageHeight = 0; % 周围群系高度加权平均后应用深度噪声
        weightSum = 0; % 权重和
        for m = -2 : 2
            for n = -2 : 2
                nearBiome = aint(j + n + 2, i + m + 2);
                nearHeight = height(nearBiome + 1, 1);
                nearHeightVariation = height(nearBiome + 1, 2);
                if WorldType == 3 && nearHeight > 0 % 放大化世界的陆地高度翻倍，高度变化翻4倍
                    nearHeight = nearHeight * 2 + 1;
                    nearHeightVariation = nearHeightVariation * 4 + 1;
                end
                weight = biomeWeight(m + 3, n + 3) / (nearHeight + 2);
                if height(nearBiome + 1, 1) > height(cenBiome + 1, 1) % 群系高度大于中心群系高度时进一步降低其权重
                    weight = weight / 2;
                end
                averageHeightVariation = averageHeightVariation + nearHeightVariation * weight;
                averageHeight = averageHeight + nearHeight * weight;
                weightSum = weightSum + weight;
            end
        end
        averageHeightVariation = averageHeightVariation / weightSum * 0.9 + 0.1;
        averageHeight = averageHeight / weightSum * 0.5 - 0.125;
        depth = depthNoise(j, i); % [-1/14,1/40]
        if depth < 0
            depth = -depth * 0.3;
        end
        depth = depth * 3 - 2;
        if depth < 0
            depth = depth / 2;
            if depth < -1
                depth = -1;
            end
            depth = depth / 14;
        else
            if depth > 1
                depth = 1;
            end
            depth = depth / 40;
        end
        averageHeight = (averageHeight + depth) * 4.25 + 8.5;
        for k = 1 : mapDepth
            base = (averageHeight - k + 1) * 6 / averageHeightVariation;
            if base > 0 % 高度越高基密度越小，高度变化越大基密度越小
                base = base * 4;
            end
            a = minNoise(j, k, i);
            b = maxNoise(j, k, i);
            t = mainNoise(j, k, i);
            final = a + (b - a) * max(0, min(t, 1)) + base;
            if k > mapDepth - 3 % 接近高度上限的的位置密度大幅降低，最后一层固定为-10
                t1 = (k - mapDepth + 3) / 3;
                final = final * (1 - t1) - 10 * t1;
            end
            heightMap(j, k, i) = final;
        end
    end
end

ablock = zeros(CH, CD, CW); % 方块数组
for i = 1 : CW / UW
    for j = 1 : CH / UH
        for k = 1 : CD / UD
            nw = heightMap(j, k, i);
            sw = heightMap(j + 1, k, i);
            ne = heightMap(j, k, i + 1);
            se = heightMap(j + 1, k, i + 1);
            nwStep = (heightMap(j, k + 1, i) - nw) / UD;
            swStep = (heightMap(j + 1, k + 1, i) - sw) / UD;
            neStep = (heightMap(j, k + 1, i + 1) - ne) / UD;
            seStep = (heightMap(j + 1, k + 1, i + 1) - se) / UD;
            for subDepth = 1 : UD % 层插值
                y = (k - 1) * UD + subDepth;
                n = nw;
                s = sw;
                nStep = (ne - nw) / UW;
                sStep = (se - sw) / UW;
                for subWidth = 1 : UW % 列插值
                    x = (i - 1) * UW + subWidth;
                    final = n;
                    step = (s - n) / UH;
                    for subHeight = 1 : UH % 行插值
                        z = (j - 1) * UH + subHeight;
                        if final > 0
                            ablock(z, y, x) = 1; % stone
                        elseif y < 64
                            ablock(z, y, x) = 9; % water
%                         else
%                             ablock(z, y, x) = 0; % air
                        end
                        final = final + step;
                    end
                    n = n + nStep;
                    s = s + sStep;
                end
                nw = nw + nwStep;
                sw = sw + swStep;
                ne = ne + neStep;
                se = se + seStep;
            end
        end
    end
end

% colormap(map);
% imageSlice = @(source, event) ShowImage(ablock, round(source.Value));
% ShowImage(ablock, seaLevel);
% uicontrol('Style', 'slider', ...
%     'Min', 1, ...
%     'Max', CD, ...
%     'Value', seaLevel, ...
%     'SliderStep', [1 / (CD - 1), 16 / (CD - 1)], ...
%     'Units', 'normalized', ...
%     'Position', [0.032 0.048 0.936 0.048], ...
%     'Callback', imageSlice);

colormap jet;
atop = zeros(CH, CW);
for i = 1 : CW
    for j = 1 : CH
        for k = CD : -1 : 1
            if ablock(j, k, i) == 1
                atop(j, i) = k;
                break;
            end
        end
    end
end
gcg = surf(1 : CH, 1 : CW, atop');
axis equal;
set(gca, 'CameraViewAngleMode', 'manual');
set(gca, 'Box', 'on');
set(gca, 'Projection', 'perspective');
set(gca, 'XGrid', 'off');
set(gca, 'YGrid', 'off');
set(gca, 'ZGrid', 'off');
set(gca, 'XTickMode', 'manual');
set(gca, 'YTickMode', 'manual');
set(gca, 'ZTickMode', 'manual');
set(gcg, 'LineStyle', 'none');

function ShowImage(ablock, y)
    mapSize = size(ablock);
    image(reshape(ablock(:, y, :), [mapSize(1), mapSize(3)]) + 1);
    axis equal;
    set(gca, 'Visible', 'off');
    set(gca, 'DataAspectRatioMode', 'manual');
end