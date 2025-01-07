function MUSIC_output = MUSIC_DOA(X, target_num, d_lambda, Phi_set)
    % X: 输入信号
    % target_num: 信源数
    % d_lambda: 阵元间距波长比
    % Phi_set: 角度区间
    % MVDR_output: DOA估计谱

    row = size(X, 1);
    %column = size(X, 2);
    %R = X * X' / column;
    R = X * X';
    [R_Vector, ~] = eig(R); %计算特征向量并保存
    Un = R_Vector(:, 1:row - target_num);
    MUSIC = zeros(1, length(Phi_set)); %初始化

    for i = 1:length(Phi_set)
        A_vector = exp(-1j * 2 * pi * (0:row -1)' * d_lambda * sind(Phi_set(i)));
        MUSIC(i) = abs((A_vector' * Un * Un' * A_vector) ^ (-1));
    end

    MUSIC_output = MUSIC / max(MUSIC);
end
