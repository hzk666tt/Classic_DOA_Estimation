function LTS_ESPRIT_output_degree = LTS_ESPRIT_DOA(X_N, MIMO_Ant_num, snapshot, target_num)
    % X:                        输入信号
    % target_num:               信源数
    % LTS_ESPRIT_output_degree: 估计角度

    tic %计时开始

    R = X_N * X_N' / snapshot; %计算协方差矩阵
    [R_Vector, ~] = eig(R); %计算特征向量并保存
    %[R_Vector, R_lambda] = eig(R); %计算特征向量并保存
    %[R_lambda, ID_R_lambda] = sort(diag(R_lambda));
    %R_Vector = fliplr(R_Vector(:, ID_R_lambda));
    %Us = R_Vector(:, 1:target_num);

    Us = R_Vector(:, end - target_num + 1:end);
    Ux = Us(1:MIMO_Ant_num - 1, :);
    Uy = Us(2:MIMO_Ant_num, :);

    Uxy = [Ux, Uy];
    Uxy = Uxy' * Uxy;
    [Uxy_Vector, ~] = eig(Uxy);
    %[Uxy_Vector, Uxy_lambda] = eig(Uxy);
    %[Uxy_lambda, ID_Uxy_lambda] = sort(diag(Uxy_lambda));
    %F = fliplr(Uxy_Vector(:, ID_Uxy_lambda));
    %Fx = F(1:target_num, target_num + 1:2 * target_num);
    %Fy = F(target_num + 1:2 * target_num, target_num + 1:2 * target_num);
    Fx = Uxy_Vector(1:target_num, 1:target_num);
    Fy = Uxy_Vector(target_num + 1:2 * target_num, 1:target_num);
    Psi = -Fx / Fy;

    [~, Phi] = eig(Psi);
    LTS_ESPRIT_output_degree = rad2deg(asin(-angle(diag(Phi)) / pi));

    toc %计时结束

    LTS_ESPRIT_output_degree = sort(LTS_ESPRIT_output_degree);
    disp(['LTS_ESPRIT估计结果：', newline, num2str(LTS_ESPRIT_output_degree'), newline]);
end
