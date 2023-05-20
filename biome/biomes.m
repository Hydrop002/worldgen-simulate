rng('shuffle');
% rng(0);
global useSeed;
global seed;
global debug;
useSeed = true;
seed = randi(2 ^ 32) - 1;
debug = false;
if debug
    dbstop in biomes at 217 if debug;
    dbstop in biomes at 294 if debug;
    dbstop in biomes at 312 if debug;
    dbstop in biomes at 413 if debug;
    dbstop in biomes at 427 if debug;
end

map = [0, 0, 112; % Ocean
    141, 179, 96; % Plains
    250, 148, 24; % Desert
    96, 96, 96; % Extreme Hills
    5, 102, 33; % Forest
    11, 102, 89; % Taiga
    7, 249, 178; % Swampland
    0, 0, 255; % River
    zeros(3, 3);
    160, 160, 255; % FrozenRiver
    255, 255, 255; % Ice Plains
    160, 160, 160; % Ice Mountains
    255, 0, 255; % MushroomIsland
    160, 0, 255; % MushroomIslandShore
    250, 222, 85; % Beach
    210, 95, 18; % DesertHills
    34, 85, 28; % ForestHills
    22, 57, 51; % TaigaHills
    114, 120, 154; % Extreme Hills Edge
    83, 123, 9; % Jungle
    44, 66, 5; % JungleHills
    98, 139, 23; % JungleEdge
    0, 0, 48; % Deep Ocean
    162, 162, 132; % Stone Beach
    250, 240, 192; % Cold Beach
    48, 116, 68; % Birch Forest
    31, 95, 50; % Birch Forest Hills
    64, 81, 26; % Roofed Forest
    49, 85, 74; % Cold Taiga
    36, 63, 54; % Cold Taiga Hills
    89, 102, 81; % Mega Taiga
    69, 79, 62; % Mega Taiga Hills
    80, 112, 80; % Extreme Hills+
    189, 178, 95; % Savanna
    167, 157, 100; % Savanna Plateau
    217, 69, 21; % Mesa
    176, 151, 101; % Mesa Plateau F
    202, 140, 101; % Mesa Plateau
    zeros(89, 3);
    141, 179, 96; % Sunflower Plains
    125, 74, 12; % Desert M
    48, 48, 48; % Extreme Hills M
    2, 51, 16; % Flower Forest
    5, 51, 44; % Taiga M
    3, 124, 89; % Swampland M
    zeros(5, 3);
    105, 127, 127; % Ice Plains Spikes
    zeros(8, 3);
    41, 61, 4; % Jungle M
    zeros(1, 3);
    49, 69, 11; % JungleEdge M
    zeros(3, 3);
    24, 58, 34; % Birch Forest M
    15, 47, 25; % Birch Forest Hills M
    32, 40, 13; % Roofed Forest M
    24, 42, 37; % Cold Taiga M
    zeros(1, 3);
    44, 51, 40; % Mega Spruce Taiga
    34, 39, 31; % Mega Taiga Hills M
    40, 56, 40; % Extreme Hills+ M
    94, 89, 47; % Savanna M
    83, 78, 50; % Savanna Plateau M
    108, 34, 10; % Mesa (Bryce)
    88, 75, 50; % Mesa Plateau F M
    101, 70, 50; % Mesa Plateau M
    0, 0, 0] / 255;
colormap(map);

CX = 0;
CZ = 0;
CW = 512;
CH = 512;
UW = 4;
UH = 4;
global WorldType;
WorldType = 0; % 0:default,1:flat,2:largeBiomes,3:amplified,8:default_1_1

[~, voronoi_zoom_para] = VoronoiZoom([], CX * 16, CZ * 16, CW, CH, 0);

% [~, river_mix_para, river_mix_para1] = RiverMix([], [], -64, -64, 129, 129, 0);
% [~, river_mix_para, river_mix_para1] = RiverMix([], [], CX * 4 - 2, CZ * 4 - 2, CW / UW + 6, CH / UH + 6, 0);
[~, river_mix_para, river_mix_para1] = RiverMix([], [], voronoi_zoom_para(1), voronoi_zoom_para(2), voronoi_zoom_para(3), voronoi_zoom_para(4), 0);

chain1 = {
    @Hills
    @RareBiome
    @Zoom
    @AddIsland
    @Zoom
    @Shore
    @Zoom
    @Zoom
    @Smooth
};
if WorldType == 2
    chain1{end + 2} = chain1{end};
    chain1{end - 2} = @Zoom;
    chain1{end - 1} = @Zoom;
end
chain1_para = zeros(length(chain1), 4);
chain1_seed = [
    2331047808 % 1000 -> 5692911206796425088
    2783856325 % 1001 -> 5852781679691581125
    2331047808 % 1000 -> 5692911206796425088
    659628085 % 3 -> 7590731853067264053
    2783856325 % 1001 -> 5852781679691581125
    2331047808 % 1000 -> 5692911206796425088
    1788026328 % 1002 -> 1827289100522298840
    849357397 % 1003 -> -4039966243449460139
    2331047808 % 1000 -> 5692911206796425088
];
if WorldType == 2
    chain1_seed(end + 2) = chain1_seed(end);
    chain1_seed(end - 2) =  3951586976; % 1004 -> -1816691421893595488
    chain1_seed(end - 1) = 3465476085; % 1005 -> -6132030474114107403
end
for k = length(chain1) : -1 : 1
    if k == length(chain1)
        chain1_para(k, :) = river_mix_para;
    else
        [~, chain1_para(k, :)] = chain1{k + 1}([], chain1_para(k + 1, 1), chain1_para(k + 1, 2), chain1_para(k + 1, 3), chain1_para(k + 1, 4), 0);
    end
    if useSeed
        chain1_seed(k) = initWorldGenSeed(chain1_seed(k));
    end
end

[~, hills_para, hills_para1] = Hills([], [], chain1_para(1, 1), chain1_para(1, 2), chain1_para(1, 3), chain1_para(1, 4), 0);

chain11 = {
    @Island
    @Zoom
    @AddIsland
    @Zoom
    @AddIsland
    @AddIsland
    @AddIsland
    @RemoveTooMuchOcean
    @AddSnow
    @AddIsland
    @EdgeCoolWarm
    @EdgeHeatIce
    @EdgeSpecial
    @Zoom
    @Zoom
    @AddIsland
    @AddMushroomIsland
    @DeepOcean
    @Biome
    @Zoom
    @Zoom
    @BiomeEdge
};
chain11_para = zeros(length(chain11), 4);
chain11_seed = [
    350566693 % 1 -> 3107951898966440229
    2924686336 % 2000 -> -8774101820360152064
    350566693 % 1 -> 3107951898966440229
    322921317 % 2001 -> 229918546094678885
    3408164312 % 2 -> -5014677998924433960
    805358296 % 50 -> -1473395045552829736
    4174982008 % 70 -> 7231908362866731896
    3408164312 % 2 -> -5014677998924433960
    3408164312 % 2 -> -5014677998924433960
    659628085 % 3 -> 7590731853067264053
    3408164312 % 2 -> -5014677998924433960
    3408164312 % 2 -> -5014677998924433960
    659628085 % 3 -> 7590731853067264053
    2013715672 % 2002 -> 837738509879401688
    1548681589 % 2003 -> 3006835321906069877
    2292490144 % 4 -> 5360640171528462240
    3709068245 % 5 -> -7479281634960481323
    2292490144 % 4 -> 5360640171528462240
    4160755584 % 200 -> 3038466749335869312
    2331047808 % 1000 -> 5692911206796425088
    2783856325 % 1001 -> 5852781679691581125
    2331047808 % 1000 -> 5692911206796425088
];
for k = length(chain11) : -1 : 1
    if k == length(chain11)
        chain11_para(k, :) = hills_para;
    else
        [~, chain11_para(k, :)] = chain11{k + 1}([], chain11_para(k + 1, 1), chain11_para(k + 1, 2), chain11_para(k + 1, 3), chain11_para(k + 1, 4), 0);
    end
    if useSeed
        chain11_seed(k) = initWorldGenSeed(chain11_seed(k));
    end
end
for k = 1 : length(chain11)
    if k == 1
        % Island
        aint = chain11{k}(chain11_para(k, 1), chain11_para(k, 2), chain11_para(k, 3), chain11_para(k, 4), chain11_seed(k));
    else
        [aint, ~] = chain11{k}(aint, chain11_para(k, 1), chain11_para(k, 2), chain11_para(k, 3), chain11_para(k, 4), chain11_seed(k));
    end
    if debug
        image(aint + 1);
        axis equal;
        set(gca, 'Visible', 'off');
        set(gca, 'DataAspectRatioMode', 'manual');
    end
end

chain12 = {
    @Island
    @Zoom
    @AddIsland
    @Zoom
    @AddIsland
    @AddIsland
    @AddIsland
    @RemoveTooMuchOcean
    @AddSnow
    @AddIsland
    @EdgeCoolWarm
    @EdgeHeatIce
    @EdgeSpecial
    @Zoom
    @Zoom
    @AddIsland
    @AddMushroomIsland
    @DeepOcean
    @RiverInit
    @Zoom
    @Zoom
};
chain12_para = zeros(length(chain12), 4);
chain12_seed = [
    350566693 % 1 -> 3107951898966440229
    2924686336 % 2000 -> -8774101820360152064
    350566693 % 1 -> 3107951898966440229
    322921317 % 2001 -> 229918546094678885
    3408164312 % 2 -> -5014677998924433960
    805358296 % 50 -> -1473395045552829736
    4174982008 % 70 -> 7231908362866731896
    3408164312 % 2 -> -5014677998924433960
    3408164312 % 2 -> -5014677998924433960
    659628085 % 3 -> 7590731853067264053
    3408164312 % 2 -> -5014677998924433960
    3408164312 % 2 -> -5014677998924433960
    659628085 % 3 -> 7590731853067264053
    2013715672 % 2002 -> 837738509879401688
    1548681589 % 2003 -> 3006835321906069877
    2292490144 % 4 -> 5360640171528462240
    3709068245 % 5 -> -7479281634960481323
    2292490144 % 4 -> 5360640171528462240
    2595270048 % 100 -> 5723240131506253216
    2331047808 % 1000 -> 5692911206796425088
    2783856325 % 1001 -> 5852781679691581125
];
for k = length(chain12) : -1 : 1
    if k == length(chain12)
        chain12_para(k, :) = hills_para1;
    else
        [~, chain12_para(k, :)] = chain12{k + 1}([], chain12_para(k + 1, 1), chain12_para(k + 1, 2), chain12_para(k + 1, 3), chain12_para(k + 1, 4), 0);
    end
    if useSeed
        chain12_seed(k) = initWorldGenSeed(chain12_seed(k));
    end
end
if debug
    figure(2);
    colormap(map);
end
for k = 1 : length(chain12)
    if k == 1
        % Island
        aint1 = chain12{k}(chain12_para(k, 1), chain12_para(k, 2), chain12_para(k, 3), chain12_para(k, 4), chain12_seed(k));
    else
        [aint1, ~] = chain12{k}(aint1, chain12_para(k, 1), chain12_para(k, 2), chain12_para(k, 3), chain12_para(k, 4), chain12_seed(k));
    end
    if debug
        figure(2);
        image(aint1 + 1);
        axis equal;
        set(gca, 'Visible', 'off');
        set(gca, 'DataAspectRatioMode', 'manual');
    end
end
if debug
    close(2);
end

for k = 1 : length(chain1)
    if k == 1
        % Hills
        [aint, ~, ~] = chain1{k}(aint, aint1, chain1_para(k, 1), chain1_para(k, 2), chain1_para(k, 3), chain1_para(k, 4), chain1_seed(k));
    else
        [aint, ~] = chain1{k}(aint, chain1_para(k, 1), chain1_para(k, 2), chain1_para(k, 3), chain1_para(k, 4), chain1_seed(k));
    end
    if debug
        image(aint + 1);
        axis equal;
        set(gca, 'Visible', 'off');
        set(gca, 'DataAspectRatioMode', 'manual');
    end
end

chain2 = {
    @Island
    @Zoom
    @AddIsland
    @Zoom
    @AddIsland
    @AddIsland
    @AddIsland
    @RemoveTooMuchOcean
    @AddSnow
    @AddIsland
    @EdgeCoolWarm
    @EdgeHeatIce
    @EdgeSpecial
    @Zoom
    @Zoom
    @AddIsland
    @AddMushroomIsland
    @DeepOcean
    @RiverInit
    @Zoom
    @Zoom
    @Zoom
    @Zoom
    @Zoom
    @Zoom
    @River
    @Smooth
};
if WorldType == 2
    chain2{end + 2} = chain2{end};
    chain2{end - 1} = chain2{end - 3};
    chain2{end - 3} = @Zoom;
    chain2{end - 2} = @Zoom;
end
chain2_para = zeros(length(chain2), 4);
chain2_seed = [
    350566693 % 1 -> 3107951898966440229
    2924686336 % 2000 -> -8774101820360152064
    350566693 % 1 -> 3107951898966440229
    322921317 % 2001 -> 229918546094678885
    3408164312 % 2 -> -5014677998924433960
    805358296 % 50 -> -1473395045552829736
    4174982008 % 70 -> 7231908362866731896
    3408164312 % 2 -> -5014677998924433960
    3408164312 % 2 -> -5014677998924433960
    659628085 % 3 -> 7590731853067264053
    3408164312 % 2 -> -5014677998924433960
    3408164312 % 2 -> -5014677998924433960
    659628085 % 3 -> 7590731853067264053
    2013715672 % 2002 -> 837738509879401688
    1548681589 % 2003 -> 3006835321906069877
    2292490144 % 4 -> 5360640171528462240
    3709068245 % 5 -> -7479281634960481323
    2292490144 % 4 -> 5360640171528462240
    2595270048 % 100 -> 5723240131506253216
    2331047808 % 1000 -> 5692911206796425088
    2783856325 % 1001 -> 5852781679691581125
    2331047808 % 1000 -> 5692911206796425088
    2783856325 % 1001 -> 5852781679691581125
    1788026328 % 1002 -> 1827289100522298840
    849357397 % 1003 -> -4039966243449460139
    350566693 % 1 -> 3107951898966440229
    2331047808 % 1000 -> 5692911206796425088
];
if WorldType == 2
    chain2_seed(end + 2) = chain2_seed(end);
    chain2_seed(end - 1) = chain2_seed(end - 3);
    chain2_seed(end - 3) = 3951586976; % 1004 -> -1816691421893595488
    chain2_seed(end - 2) = 3465476085; % 1005 -> -6132030474114107403
end
for k = length(chain2) : -1 : 1
    if k == length(chain2)
        chain2_para(k, :) = river_mix_para1;
    else
        [~, chain2_para(k, :)] = chain2{k + 1}([], chain2_para(k + 1, 1), chain2_para(k + 1, 2), chain2_para(k + 1, 3), chain2_para(k + 1, 4), 0);
    end
    if useSeed
        chain2_seed(k) = initWorldGenSeed(chain2_seed(k));
    end
end
if debug
    figure(2);
    colormap(map);
end
for k = 1 : length(chain2)
    if k == 1
        % Island
        aint1 = chain2{k}(chain2_para(k, 1), chain2_para(k, 2), chain2_para(k, 3), chain2_para(k, 4), chain2_seed(k));
    else
        [aint1, ~] = chain2{k}(aint1, chain2_para(k, 1), chain2_para(k, 2), chain2_para(k, 3), chain2_para(k, 4), chain2_seed(k));
    end
    if debug
        figure(2);
        image(aint1 + 1);
        axis equal;
        set(gca, 'Visible', 'off');
        set(gca, 'DataAspectRatioMode', 'manual');
    end
end
if debug
    close(2);
end

% [aint, ~, ~] = RiverMix(aint, aint1, -64, -64, 129, 129, initWorldGenSeed(2595270048));
% [aint, ~, ~] = RiverMix(aint, aint1, CX * 4 - 2, CZ * 4 - 2, CW / UW + 6, CH / UH + 6, initWorldGenSeed(2595270048));
[aint, ~, ~] = RiverMix(aint, aint1, voronoi_zoom_para(1), voronoi_zoom_para(2), voronoi_zoom_para(3), voronoi_zoom_para(4), initWorldGenSeed(2595270048));
if debug
    image(aint + 1);
    axis equal;
    set(gca, 'Visible', 'off');
    set(gca, 'DataAspectRatioMode', 'manual');
end

[aint, ~] = VoronoiZoom(aint, CX * 16, CZ * 16, CW, CH, initWorldGenSeed(1651461080));

image(aint + 1);
axis equal;
set(gca, 'Visible', 'off');
set(gca, 'DataAspectRatioMode', 'manual');

if debug
    dbclear in biomes;
end