function [MUSIC_output_wave, MUSIC_output_degree] = MUSIC_DOA(X_N, MIMO_Ant_num, snapshot, target_num, phi_step, Phi_set)
    % X: 输入信号
    % target_num: 信源数
    % Phi_set: 角度区间
    % MUSIC_output_wave: DOA估计谱
    % MUSIC_output_degree: 估计角度

    tic %计时开始

    R = X_N * X_N' / snapshot; %计算协方差矩阵
    [R_Vector, ~] = eig(R); %计算特征向量并保存
    Un = R_Vector(:, 1:MIMO_Ant_num - target_num);
    MUSIC = zeros(1, length(Phi_set)); %初始化
    max_loc = zeros(1, target_num);

    for i = 1:length(Phi_set)
        A_vector = exp(-1j * pi * (0:MIMO_Ant_num -1)' * sind(Phi_set(i)));
        MUSIC(i) = 1 / abs((A_vector' * Un * Un' * A_vector));
    end

    MUSIC_normal = MUSIC / max(MUSIC);

    [pks, locs] = findpeaks(MUSIC_normal); %寻找全部谱峰及索引
    %[pks, id] = sort(pks);
    %locs = locs(id(end - target_num + 1:end)) - 1;
    %MUSIC_output_degree = locs * phi_step - 90;

    for j = 1:target_num
        [~, id] = max(pks);
        max_loc(:, j) = locs(id) -1;
        pks(id) = -inf;
    end %寻找前target_num个最大值及其索引并保存

    MUSIC_output_degree = max_loc * phi_step - (length(Phi_set) - 1) * phi_step / 2;

    toc %计时结束

    MUSIC_output_wave = 10 * log10(MUSIC_normal);
    MUSIC_output_degree = sort(MUSIC_output_degree);
    disp(['MUSIC估计结果：', newline, num2str(MUSIC_output_degree), newline]);
    %disp(MUSIC_output_degree);

end
