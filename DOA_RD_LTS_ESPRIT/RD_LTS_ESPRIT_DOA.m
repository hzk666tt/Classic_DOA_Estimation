function RD_LTS_ESPRIT_output_degree = RD_LTS_ESPRIT_DOA(S_N, G, Tx_num, Rx_num, snapshot, target_num)
    % S_N:                      输入信号
    % Tx_num:                   发射天线
    % Rx_num:                   接收天线
    % snapshot                  快拍数
    % target_num:               信源数
    % RD_LTS_ESPRIT_output_degree:  估计角度

    tic %计时开始

    B = [];

    for index = 0:Rx_num - 1
        C = [zeros(Tx_num, index), eye(Tx_num, Tx_num), zeros(Tx_num, Rx_num - 1 - index)];
        B = [B; C];
    end

    W = B' * B;
    W_sqrt = W ^ (0.5);
    Y = W_sqrt * G * S_N;

    R = Y * Y' / snapshot; %计算协方差矩阵
    [R_Vector, ~] = eig(R); %计算特征向量并保存

    Us = R_Vector(:, end - target_num + 1:end);
    U = W_sqrt ^ (-1) * Us;
    Ux = U(1:Tx_num + Rx_num - 2, :);
    Uy = U(2:Tx_num + Rx_num - 1, :);

    Uxy = [Ux, Uy];
    Uxy = Uxy' * Uxy;
    [Uxy_Vector, ~] = eig(Uxy);

    Fx = Uxy_Vector(1:target_num, 1:target_num);
    Fy = Uxy_Vector(target_num + 1:2 * target_num, 1:target_num);
    Psi = -Fx / Fy;

    [~, Phi] = eig(Psi);
    RD_LTS_ESPRIT_output_degree = rad2deg(asin(-angle(diag(Phi)) / pi));

    toc %计时结束

    RD_LTS_ESPRIT_output_degree = sort(RD_LTS_ESPRIT_output_degree);
    disp(['RD_LTS_ESPRIT估计结果：', newline, num2str(RD_LTS_ESPRIT_output_degree'), newline]);
end
