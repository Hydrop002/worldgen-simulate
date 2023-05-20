rng('shuffle');
global seed;
seed = randi(2 ^ 32) - 1;
rs = RandStream('mt19937ar', 'Seed', seed);
RandStream.setGlobalStream(rs);

width = 256;
height = 256;
originX = 128;
originZ = 128;
map = [
    240, 240, 240
    255, 127, 0 % Mineshaft
    0, 255, 0 % Village
    255, 0, 0 % Fortress
    127, 127, 127 % Stronghold
    255, 255, 0 % Temple
] / 255;

achunk = zeros(height, width);
for i = 1 : width
    chunkX = i - originX - 1;
    for j = 1 : height
        chunkZ = j - originZ - 1;
        if canSpawnMineshaft(chunkX, chunkZ)
            achunk(j, i) = 1;
        end
%         if canSpawnVillage(chunkX, chunkZ)
%             achunk(j, i) = 2;
%         end
%         if canSpawnFortress(chunkX, chunkZ)
%             achunk(j, i) = 3;
%         end
%         if canSpawnStronghold(chunkX, chunkZ)
%             achunk(j, i) = 4;
%         end
%         if canSpawnTemple(chunkX, chunkZ)
%             achunk(j, i) = 5;
%         end
    end
end

colormap(map);
image(achunk + 1);
axis equal;
set(gca, 'XLim', [0, width]);
set(gca, 'YLim', [0, height]);
set(gca, 'XGrid', 'on');
set(gca, 'YGrid', 'on');
xTick = 0 : 32 : width;
set(gca, 'XTick', xTick);
yTick = 0 : 32 : height;
set(gca, 'YTick', yTick);
xTickLabel = cell(1, length(xTick));
for i = 1 : length(xTick)
    xTickLabel{i} = num2str(xTick(i) - originX);
end
set(gca, 'XTickLabel', xTickLabel);
yTickLabel = cell(1, length(yTick));
for i = 1 : length(yTick)
    yTickLabel{i} = num2str(yTick(i) - originZ);
end
set(gca, 'YTickLabel', yTickLabel);
set(gca, 'DataAspectRatioMode', 'manual');

function flag = canSpawnMineshaft(chunkX, chunkZ)
    prob = 1; % 0.004
    if rand() < prob && randi(80) - 1 < max(abs(chunkX), abs(chunkZ))
        flag = true;
    else
        flag = false;
    end
end
function flag = canSpawnVillage(chunkX, chunkZ)
    prob = 1;
    maxDist = 32;
    minDist = 8;
    regionX = floor(chunkX / maxDist);
    regionZ = floor(chunkZ / maxDist);
    chunkX = chunkX - regionX * maxDist;
    chunkZ = chunkZ - regionZ * maxDist;
    if chunkX >= 0 && chunkX <= maxDist - minDist - 1 && chunkZ >= 0 && chunkZ <= maxDist - minDist - 1
        if rand() < prob
            flag = true;
        else
            flag = false;
        end
    else
        flag = false;
    end
end
function flag = canSpawnFortress(chunkX, chunkZ)
    prob = 1;
    regionX = floor(chunkX / 16);
    regionZ = floor(chunkZ / 16);
    chunkX = chunkX - regionX * 16;
    chunkZ = chunkZ - regionZ * 16;
    if chunkX >= 4 && chunkX <= 11 && chunkZ >= 4 && chunkZ <= 11
        if rand() < prob
            flag = true;
        else
            flag = false;
        end
    else
        flag = false;
    end
end
function flag = canSpawnStronghold(chunkX, chunkZ)
    prob = 1;
    dist = 32;
    radius = sqrt(chunkX ^ 2 + chunkZ ^ 2);
    if radius >= 1.25 * dist && radius <= 2.25 * dist
        if rand() < prob
            flag = true;
        else
            flag = false;
        end
    else
        flag = false;
    end
end
function flag = canSpawnTemple(chunkX, chunkZ)
    prob = 1;
    maxDist = 32;
    minDist = 8;
    regionX = floor(chunkX / maxDist);
    regionZ = floor(chunkZ / maxDist);
    chunkX = chunkX - regionX * maxDist;
    chunkZ = chunkZ - regionZ * maxDist;
    if chunkX >= 0 && chunkX <= maxDist - minDist - 1 && chunkZ >= 0 && chunkZ <= maxDist - minDist - 1
        if rand() < prob
            flag = true;
        else
            flag = false;
        end
    else
        flag = false;
    end
end