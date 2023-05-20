rng('shuffle');
global seed;
seed = randi(2 ^ 32) - 1;
rs = RandStream('mt19937ar', 'Seed', seed);
RandStream.setGlobalStream(rs);

temperature = [
    0.5; % Ocean
    0.8; % Plains
    2; % Desert
    0.2; % Extreme Hills
    0.7; % Forest
    0.25; % Taiga
    0.8; % Swampland
    0.5; % River
    zeros(3, 1);
    0; % FrozenRiver
    0; % Ice Plains
    0; % Ice Mountains
    0.9; % MushroomIsland
    0.9; % MushroomIslandShore
    0.8; % Beach
    2; % DesertHills
    0.7; % ForestHills
    0.25; % TaigaHills
    0.2; % Extreme Hills Edge
    0.95; % Jungle
    0.95; % JungleHills
    0.95; % JungleEdge
    0.5; % Deep Ocean
    0.2; % Stone Beach
    0.05; % Cold Beach
    0.6; % Birch Forest
    0.6; % Birch Forest Hills
    0.7; % Roofed Forest
    -0.5; % Cold Taiga
    -0.5; % Cold Taiga Hills
    0.3; % Mega Taiga
    0.3; % Mega Taiga Hills
    0.2; % Extreme Hills+
    1.2; % Savanna
    1; % Savanna Plateau
    2; % Mesa
    2; % Mesa Plateau F
    2; % Mesa Plateau
    zeros(89, 1);
    0.8; % Sunflower Plains
    2; % Desert M
    0.2; % Extreme Hills M
    0.7; % Flower Forest
    0.25; % Taiga M
    0.8; % Swampland M
    zeros(5, 1);
    0; % Ice Plains Spikes
    zeros(8, 1);
    0.95; % Jungle M
    zeros(1, 1);
    0.95; % JungleEdge M
    zeros(3, 1);
    0.6; % Birch Forest M
    0.6; % Birch Forest Hills M
    0.7; % Roofed Forest M
    -0.5; % Cold Taiga M
    zeros(1, 1);
    0.25; % Mega Spruce Taiga
    0.3; % Mega Taiga Hills M
    0.2; % Extreme Hills+ M
    1.1; % Savanna M
    1; % Savanna Plateau M
    2; % Mesa (Bryce)
    2; % Mesa Plateau F M
    2; % Mesa Plateau M
];
biomeBlock = [
    2, 3; % Ocean
    2, 3; % Plains
    12, 12; % Desert
    2, 3; % Extreme Hills
    2, 3; % Forest
    2, 3; % Taiga
    2, 3; % Swampland
    2, 3; % River
    zeros(3, 2);
    2, 3; % FrozenRiver
    2, 3; % Ice Plains
    2, 3; % Ice Mountains
    110, 3; % MushroomIsland
    110, 3; % MushroomIslandShore
    12, 12; % Beach
    12, 12; % DesertHills
    2, 3; % ForestHills
    2, 3; % TaigaHills
    2, 3; % Extreme Hills Edge
    2, 3; % Jungle
    2, 3; % JungleHills
    2, 3; % JungleEdge
    2, 3; % Deep Ocean
    1, 1; % Stone Beach
    12, 12; % Cold Beach
    2, 3; % Birch Forest
    2, 3; % Birch Forest Hills
    2, 3; % Roofed Forest
    2, 3; % Cold Taiga
    2, 3; % Cold Taiga Hills
    2, 3; % Mega Taiga
    2, 3; % Mega Taiga Hills
    2, 3; % Extreme Hills+
    2, 3; % Savanna
    2, 3; % Savanna Plateau
    12.01, 159; % Mesa
    12.01, 159; % Mesa Plateau F
    12.01, 159; % Mesa Plateau
    zeros(89, 2);
    2, 3; % Sunflower Plains
    12, 12; % Desert M
    2, 3; % Extreme Hills M
    2, 3; % Flower Forest
    2, 3; % Taiga M
    2, 3; % Swampland M
    zeros(5, 2);
    80, 3; % Ice Plains Spikes
    zeros(8, 2);
    2, 3; % Jungle M
    zeros(1, 2);
    2, 3; % JungleEdge M
    zeros(3, 2);
    2, 3; % Birch Forest M
    2, 3; % Birch Forest Hills M
    2, 3; % Roofed Forest M
    2, 3; % Cold Taiga M
    zeros(1, 2);
    2, 3; % Mega Spruce Taiga
    2, 3; % Mega Taiga Hills M
    2, 3; % Extreme Hills+ M
    2, 3; % Savanna M
    2, 3; % Savanna Plateau M
    12.01, 159; % Mesa (Bryce)
    12.01, 159; % Mesa Plateau F M
    12.01, 159; % Mesa Plateau M
];
map = [
    240, 240, 240 % air
    112, 112, 112 % stone
    127, 178, 56 % grass
    183, 106, 47 % dirt
    zeros(3, 3)
    112 / 2, 112 / 2, 112 / 2 % bedrock
    zeros(1, 3)
    64, 64, 255 % water
    zeros(2, 3)
    247, 233, 163 % sand
    247, 233, 163 % gravel
    zeros(10, 3)
    112, 112, 112 % sandstone
    zeros(54, 3)
    160, 160, 255 % ice
    255, 255, 255 % snow
    zeros(29, 3)
    127, 178, 56 % mycelium
    zeros(48, 3)
    255, 255, 255 % stained_hardened_clay
    zeros(12, 3)
    112, 112, 112 % hardened_clay
] / 255;

CX = 0;
CZ = 0;
CW = 512;
CH = 512;
CD = 256;

if ~exist('aint', 'var')
    aint = zeros(CH, CW);
end
if ~exist('ablock', 'var')
    ablock = zeros(CH, CD, CW);
end

if ~exist('stoneNoise', 'var')
    stoneNoise = Perlin(CX * 16, CZ * 16, CW, CH, 0.0625, 0.0625, 1, 0.5, 4);
end
clayBand = GenerateClayBand();
hWaitBar = waitbar(0, '��Ů����...');
for i = 1 : CW
    waitbar(i / CW, hWaitBar);
    for j = 1 : CH %��ԭ�������ڷ������˳�����󣬵��»�ȡ�ķ�������������z=x�Խ��߷�ת��
        biome = aint(j, i);
        topBlock = biomeBlock(biome + 1, 1);
        fillerBlock = biomeBlock(biome + 1, 2);
        noiseF = stoneNoise(j, i); % [-8.25,8.25]
        noiseI = fix(noiseF / 3 + 3 + rand(rs) * 0.25); % [0,6]����
        if biome == 37 || biome == 38 || biome == 39 || biome == 165 || biome == 166 || biome == 167 % Mesa
            pillarHeight = 0;
            if biome == 165 % Mesa (Bryce)
                pillarNoise = min(abs(noiseF), GetPerlinValue(i * 0.25, j * 0.25, 4, 0)); % [-15,8.25]
                if pillarNoise > 0
                    pillarRoofNoise = ceil(abs(GetPerlinValue(i * 0.001953125, j * 0.001953125, 1, 0)) * 50) + 14; % [14,64]����
                    pillarHeight = min(pillarNoise ^ 2 * 2.5, pillarRoofNoise) + 64; % [64,128]
                end
            end
            noiseB = cos(noiseF / 3 * pi) > 0; % �ȸ��߻���
            clayBandNoise = round(GetPerlinValue(i / 512, j / 512, 1, seed) * 2); % [-2,2]������ԭ�����ճ������ʱδ����z���������º�������һЩ���ߣ�
            count = -1;
            hasTopBlock = 0;
            for k = 256 : -1 : 1
                if ablock(j, k, i) == 0 && k <= pillarHeight % ���ɲ���˹Ͽ�ȵļ��
                    ablock(j, k, i) = 1;
                end
                if k <= 5 && k <= randi(rs, 5)
                    ablock(j, k, i) = 7; % bedrock
                else
                    block = ablock(j, k, i);
                    if block ~= 0
                        if block == 1
                            if count == -1 % ���㷽��
                                hasTopBlock = 0;
                                if noiseI <= 0 % ��¶����ʯ
                                    fillerBlock = 1;
                                elseif k >= 60 && k <= 65
                                    fillerBlock = biomeBlock(biome + 1, 2);
                                end
                                count = noiseI + max(0, k - 64); % ���㷽����y=63��λ������Ӳ��ճ��������������0~6��Ӳ��ճ��
                                if k >= 63
                                    if (biome == 38 || biome == 166) && k > 87 + noiseI * 2 % F�汾��Ⱥϵ�ں��νϸ�ʱ����ɰ����ݷ���
                                        if noiseB
                                            ablock(j, k, i) = 3.01;
                                        else
                                            ablock(j, k, i) = 2;
                                        end
                                    elseif k > 67 + noiseI % ���δθ�ʱ���㷽�鲿������ΪδȾɫ��Ӳ��ճ��
                                        clay = 16;
                                        if k >= 65 && k <= 128
                                            if ~noiseB
                                                clay = clayBand(mod(k + clayBandNoise + 63, 64) + 1);
                                            end
                                        else
                                            clay = 1;
                                        end
                                        if clay < 16
                                            ablock(j, k, i) = 159 + clay / 100;
                                        else
                                            ablock(j, k, i) = 172;
                                        end
                                    else % ʣ�ຣƽ�����ϵĲ����Ժ�ɳ����
                                        ablock(j, k, i) = topBlock;
                                        hasTopBlock = 1;
                                    end
                                else % ��ƽ�����µĶ��㷽��Ϊ���㷽�飬ȾɫӲ��ճ��һ��Ϊ��ɫ
                                    if floor(fillerBlock) == 159
                                        ablock(j, k, i) = 159.01;
                                    else
                                        ablock(j, k, i) = fillerBlock;
                                    end
                                end
                            elseif count > 0 % ����
                                count = count - 1;
                                if hasTopBlock % ��ɳ�·���Ϊ��ɫӲ��ճ��
                                    ablock(j, k, i) = 159.01;
                                else %��ԭ�����ճ������ʱδ����z���������º�������һЩ���ߣ�
                                    clay = clayBand(mod(k + clayBandNoise + 63, 64) + 1);
                                    if clay < 16
                                        ablock(j, k, i) = 159 + clay / 100;
                                    else
                                        ablock(j, k, i) = 172; % hardened_clay
                                    end
                                end
                            end
                        end
                    else
                        count = -1;
                    end
                end
            end
        else
            if biome == 131 || biome == 162 % ExtremeHillsͻ��
                if noiseF < -1 || noiseF > 2
                    topBlock = 13; % gravel
                    fillerBlock = 13;
                end
            elseif biome == 3 || biome == 20 % ExtremeHills��plus��
                if noiseF > 1
                    topBlock = 1; % stone
                    fillerBlock = 1;
                end
            elseif biome == 163 || biome == 164 % Savannaͻ��
                if noiseF > 1.75
                    topBlock = 1;
                    fillerBlock = 1;
                elseif noiseF > -0.5
                    topBlock = 3.01; % ɰ��
                    fillerBlock = 3;
                end
            elseif biome == 32 || biome == 33 || biome == 160 || biome == 161 % MegaTaiga����ͻ��
                if noiseF > 1.75
                    topBlock = 3.01;
                    fillerBlock = 3;
                elseif noiseF > -0.95
                    topBlock = 3.02; % �һ���
                    fillerBlock = 3;
                end
            end
%             temperatureNoise = GetPerlinValue(i * 0.125, j * 0.125, 1, 1234) * 4;
            count = -1;
            for k = 256 : -1 : 1
                if k <= 5 && k <= randi(rs, 5) % y=0~4��λ�����ɻ��ң�Խ�͸���Խ��
                    ablock(j, k, i) = 7; % bedrock
                else
                    block = ablock(j, k, i);
                    if block ~= 0
                        if block == 1
                            if count == -1 % ���㷽��
                                if noiseI <= 0 % С����ȥ����Ƥ��������¶����ʯ
                                    topBlock = 0;
                                    fillerBlock = 1;
                                elseif k >= 60 && k <= 65
                                    topBlock = biomeBlock(biome + 1, 1);
                                    fillerBlock = biomeBlock(biome + 1, 2);
                                end
                                if k < 64 && topBlock == 0 % ��ֹȥ����Ƥ��ر���ں�ƽ�棬��ˮ������
                                    if temperature(biome + 1) < 0.15
                                        topBlock = 79; % ice
                                    else
                                        topBlock = 9;
                                    end
                                end
                                count = noiseI;
                                if k >= 63
                                    ablock(j, k, i) = topBlock;
                                elseif k < 57 - noiseI % �ϵ͵ĺ��ζ��㷽��Ϊɳ��������Ϊʯͷ
                                    topBlock = 0;
                                    fillerBlock = 1;
                                    ablock(j, k, i) = 13;
                                else % �еȺ��ζ��㷽��Ϊ���㷽��
                                    ablock(j, k, i) = fillerBlock;
                                end
                            elseif count > 0 % ���㣬��������Ϊ0ʱ������ʯ��
                                count = count - 1;
                                ablock(j, k, i) = fillerBlock;
                                if count == 0 && fillerBlock == 12 % ɳ���·���y=63��λ������ɳʯ������������0~3��ɳʯ
                                    count = randi(rs, [0, 3]) + max(0, k - 64);
                                    fillerBlock = 24; % sandstone
                                end
                            end
                        end
                    else % �����������ü�����
                        count = -1;
                    end
                end
            end
        end
    end
end
close(hWaitBar);

global topView;
topView = 0;
colormap(map);
imageSlice = @(source, event) ShowImage(ablock, round(source.Value));
ShowImage(ablock, 64);
hSlider = uicontrol('Style', 'slider', ...
    'Min', 1, ...
    'Max', CD, ...
    'Value', 64, ...
    'SliderStep', [1 / (CD - 1), 16 / (CD - 1)], ...
    'Units', 'normalized', ...
    'Position', [0.032 0.048 0.936 0.048], ...
    'Callback', imageSlice);
toggleTopView = @(source, event) ShowTopView(ablock, round(hSlider.Value), source.Value);
uicontrol('Style', 'togglebutton', ...
    'String', 'Top View', ...
    'Units', 'normalized', ...
    'Position', [0.904, 0.144, 0.064, 0.048], ...
    'Callback', toggleTopView);

% colormap([
%     255, 255, 255 % ��
%     216, 127, 51 % ��
%     zeros(2, 3)
%     229, 229, 51 % ��
%     zeros(3, 3)
%     153, 153, 153 % ����
%     zeros(3, 3)
%     102, 76, 51 % ��
%     zeros(1, 3)
%     153, 51, 51 % ��
%     zeros(1, 3)
%     112, 112, 112 % δȾɫ
% ] / 255);
% image(clayBand' + 1);
% set(gca, 'Visible', 'off');
% set(gca, 'YDir', 'normal');

function ShowImage(ablock, y)
    global topView;
    mapSize = size(ablock);
    if topView
        atop = zeros(mapSize(1), mapSize(3));
        for i = 1 : mapSize(1)
            for j = 1 : mapSize(3)
                for k = y : -1 : 1
                    block = ablock(i, k, j);
                    if block ~= 0
                        atop(i, j) = block;
                        break;
                    end
                end
            end
        end
        image(atop + 1);
    else
        image(reshape(ablock(:, y, :), [mapSize(1), mapSize(3)]) + 1);
    end
    axis equal;
    set(gca, 'Visible', 'off');
    set(gca, 'DataAspectRatioMode', 'manual');
end
function ShowTopView(ablock, y, state)
    global topView;
    topView = state;
    ShowImage(ablock, y);
end