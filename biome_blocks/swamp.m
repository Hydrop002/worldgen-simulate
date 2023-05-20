rng('shuffle');
global seed;
seed = randi(2 ^ 32) - 1;
rs = RandStream('mt19937ar', 'Seed', seed);
RandStream.setGlobalStream(rs);

map = [
    240, 240, 240 % air
    zeros(8, 3)
    64, 64, 255 % water
    zeros(101, 3)
    0, 124, 0 % waterlily
] / 255;

CW = 64;
CH = 64;

atop = zeros(CH, CW);
for i = 1 : CW
    for j = 1 : CH
        % Ë¯Á«
        plantNoise = GetPerlinValue(i * 0.25, j * 0.25, 1, 2345);
        if plantNoise > 0
            atop(j, i) = 9;
            if plantNoise < 0.12
                atop(j, i) = 111; % waterlily
            end
        end
    end
end

colormap(map);
image(atop + 1);
axis equal;
set(gca, 'Visible', 'off');
set(gca, 'DataAspectRatioMode', 'manual');