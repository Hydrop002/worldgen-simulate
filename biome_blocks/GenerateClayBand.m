function clayBand = GenerateClayBand()
    clayBand = ones(1, 64) * 16;  % 硬化粘土
    index = 1;
    while index <= 64
        index = index + randi([1, 5]);
        if index <= 64
            clayBand(index) = 1; % 橙色硬化粘土
        end
        index = index + 1;
    end
    tries = randi([2, 5]);
    for i = 1 : tries
        count = randi([1, 3]);
        index = randi(64);
        j = 0;
        while index + j <= 64 && j < count
            clayBand(index + j) = 4; % 黄色硬化粘土
            j = j + 1;
        end
    end
    tries = randi([2, 5]);
    for i = 1 : tries
        count = randi([2, 4]);
        index = randi(64);
        j = 0;
        while index + j <= 64 && j < count
            clayBand(index + j) = 12; % 棕色硬化粘土
            j = j + 1;
        end
    end
    tries = randi([2, 5]);
    for i = 1 : tries
        count = randi([1, 3]);
        index = randi(64);
        j = 0;
        while index + j <= 64 && j < count
            clayBand(index + j) = 14; % 红色硬化粘土
            j = j + 1;
        end
    end
    tries = randi([3, 5]);
    index = 1;
    for i = 1 : tries
        index = index + randi([4, 19]);
        if index <= 64
            clayBand(index) = 0; % 白色硬化粘土
            if index >= 2 && randi(2) == 1
                clayBand(index - 1) = 8; % 淡灰色硬化粘土
            end
            if index <= 63 && randi(2) == 1
                clayBand(index + 1) = 8;
            end
        end
    end
end