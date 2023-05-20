function clayBand = GenerateClayBand()
    clayBand = ones(1, 64) * 16;  % Ӳ��ճ��
    index = 1;
    while index <= 64
        index = index + randi([1, 5]);
        if index <= 64
            clayBand(index) = 1; % ��ɫӲ��ճ��
        end
        index = index + 1;
    end
    tries = randi([2, 5]);
    for i = 1 : tries
        count = randi([1, 3]);
        index = randi(64);
        j = 0;
        while index + j <= 64 && j < count
            clayBand(index + j) = 4; % ��ɫӲ��ճ��
            j = j + 1;
        end
    end
    tries = randi([2, 5]);
    for i = 1 : tries
        count = randi([2, 4]);
        index = randi(64);
        j = 0;
        while index + j <= 64 && j < count
            clayBand(index + j) = 12; % ��ɫӲ��ճ��
            j = j + 1;
        end
    end
    tries = randi([2, 5]);
    for i = 1 : tries
        count = randi([1, 3]);
        index = randi(64);
        j = 0;
        while index + j <= 64 && j < count
            clayBand(index + j) = 14; % ��ɫӲ��ճ��
            j = j + 1;
        end
    end
    tries = randi([3, 5]);
    index = 1;
    for i = 1 : tries
        index = index + randi([4, 19]);
        if index <= 64
            clayBand(index) = 0; % ��ɫӲ��ճ��
            if index >= 2 && randi(2) == 1
                clayBand(index - 1) = 8; % ����ɫӲ��ճ��
            end
            if index <= 63 && randi(2) == 1
                clayBand(index + 1) = 8;
            end
        end
    end
end