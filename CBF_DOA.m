function CBF_output = CBF_DOA(X, target_num, d_lambda, Phi_set)
    % X: 输入信号
    % target_num: 信源数
    % d_lambda: 阵元间距波长比
    % Phi_set: 角度区间
    % CBF_output: DOA估计谱

    row = size(X, 1); % 阵列排列
    CBF = zeros(1, length(Phi_set)); %初始化

    for i = 1:length(Phi_set)
        Weight = exp(-1j * 2 * pi * (0:row -1)' * d_lambda * sind(Phi_set(i)));
        CBF(i) = abs(Weight' * (X * X') * Weight);
    end

    %log_CBF = log10(CBF / max(CBF));
    %CBF_output = (log_CBF - min(log_CBF)) / max(log_CBF - min(log_CBF));
    CBF_output = CBF / max(CBF);
end
