rng('shuffle');
global seed;
seed = randi(2 ^ 32) - 1;
rs = RandStream('mt19937ar', 'Seed', seed);
RandStream.setGlobalStream(rs);

global biomeBlock;
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
    255, 0, 0 % flowing_lava
    255, 0, 0 % lava
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

global CW;
global CH;
global CD;
CX = 0;
CZ = 0;
CW = 512;
CH = 512;
CD = 256;
chunkRange = 8; % 默认为8，一个区块内的洞穴、峡谷、结构会受到周围17*17个区块影响

global aint;
if ~exist('aint', 'var')
    aint = zeros(CH, CW);
end
if ~exist('ablock', 'var')
    ablock = zeros(CH, CD, CW);
end

rx = randi(2 ^ 32) - 1;
rz = randi(2 ^ 32) - 1;
for i = CX - chunkRange : CX + chunkRange
    for j = CZ - chunkRange : CZ + chunkRange
        seedX = mod(i * rx, 4294967296); % 确保不同的中心区块遍历到同一个区块时拥有相同的种子
        seedZ = mod(j * rz, 4294967296);
        rng(bitxor(bitxor(seedX, seedZ), seed));
        ablock = GenerateCave(i, j, CX, CZ, ablock);
        rng(bitxor(bitxor(seedX, seedZ), seed));
        ablock = GenerateRavine(i, j, CX, CZ, ablock);
    end
end

global topView;
global xRay;
topView = 0;
xRay = 0;
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
toggleXRay = @(source, event) ShowXRay(ablock, round(hSlider.Value), source.Value);
uicontrol('Style', 'togglebutton', ...
    'String', 'X-Ray', ...
    'Units', 'normalized', ...
    'Position', [0.904, 0.24, 0.064, 0.048], ...
    'Callback', toggleXRay);

function ShowImage(ablock, y)
    global topView;
    global xRay;
    mapSize = size(ablock);
    if topView
        atop = zeros(mapSize(1), mapSize(3));
        for i = 1 : mapSize(1)
            for j = 1 : mapSize(3)
                state = 0;
                for k = y : -1 : 1
                    block = ablock(i, k, j);
                    if xRay
                        if k == y && block ~= 0
                            state = 1;
                        end
                        if state == 0 && block ~= 0
                            atop(i, j) = block;
                            break;
                        elseif state == 1 && block == 0
                            state = 2;
                        elseif state == 2 && block ~= 0
                            atop(i, j) = block;
                            break;
                        end
                    else
                        if block ~= 0
                            atop(i, j) = block;
                            break;
                        end
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
function ShowXRay(ablock, y, state)
    global xRay;
    xRay = state;
    ShowImage(ablock, y);
end