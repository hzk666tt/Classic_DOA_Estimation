function [CBF_output_wave, CBF_output_degree] = CBF_DOA(X, target_num, d_lambda, phi_step, Phi_set)
    % X: 输入信号
    % target_num: 信源数
    % d_lambda: 阵元间距波长比
    % Phi_set: 角度区间
    % CBF_output_wave: DOA估计谱
    % CBF_output_degree: DOA估计角度

    tic %计时开始

    row = size(X, 1); % 阵列排列
    CBF = zeros(1, length(Phi_set)); %初始化
    max_loc = zeros(1, target_num);

    for i = 1:length(Phi_set)
        Weight = exp(-1j * 2 * pi * (0:row -1)' * d_lambda * sind(Phi_set(i)));
        CBF(i) = abs(Weight' * (X * X') * Weight);
    end

    CBF_normal = CBF / max(CBF);

    [pks, locs] = findpeaks(CBF_normal); %寻找全部谱峰及索引
    %[pks, id] = sort(pks);
    %locs = locs(id(end - target_num + 1:end)) - 1;
    %CBF_output_degree = locs * phi_step - 90;

    for j = 1:target_num
        [~, id] = max(pks);
        max_loc(:, j) = locs(id) -1;
        pks(id) = -inf;
    end %寻找前target_num个最大值及其索引并保存

    CBF_output_degree = max_loc * phi_step - (length(Phi_set) - 1) / 2;

    toc %计时结束

    CBF_output_wave = log10(CBF_normal);
    CBF_output_degree = sort(CBF_output_degree);
    disp(['CBF估计结果：', newline, num2str(CBF_output_degree), newline]);
    %disp(CBF_output_degree);
end
