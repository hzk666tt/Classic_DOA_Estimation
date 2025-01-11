function [MVDR_output_wave, MVDR_output_degree] = MVDR_DOA(X, target_num, d_lambda, phi_step, Phi_set)
    % X:                    输入信号
    % target_num:           信源数
    % d_lambda:             阵元间距波长比
    % Phi_set:              角度区间
    % MVDR_output_wave:     DOA估计谱
    % MVDR_output_degree:   估计角度

    tic %计时开始

    row = size(X, 1);
    column = size(X, 2);
    R = X * X' / column;
    %R = X * X';
    MVDR = zeros(1, length(Phi_set)); %初始化
    max_loc = zeros(1, target_num);

    for i = 1:length(Phi_set)
        A_vector = exp(-1j * 2 * pi * (0:row -1)' * d_lambda * sind(Phi_set(i)));
        MVDR(i) = 1 / abs(A_vector' * R ^ (-1) * A_vector);
    end

    MVDR_normal = MVDR / max(MVDR);

    [pks, locs] = findpeaks(MVDR_normal); %寻找全部谱峰及索引
    %[pks, id] = sort(pks);
    %locs = locs(id(end - target_num + 1:end)) - 1;
    %MVDR_output_degree = locs * phi_step - 90;

    for j = 1:target_num
        [~, id] = max(pks);
        max_loc(:, j) = locs(id) -1;
        pks(id) = -inf;
    end %寻找前target_num个最大值及其索引并保存

    MVDR_output_degree = max_loc * phi_step - (length(Phi_set) - 1) * phi_step / 2;

    toc %计时结束

    MVDR_output_wave = log10(MVDR_normal);
    MVDR_output_degree = sort(MVDR_output_degree);
    disp(['MVDR估计结果：', newline, num2str(MVDR_output_degree), newline]);
    %disp(MVDR_output_degree);
end
