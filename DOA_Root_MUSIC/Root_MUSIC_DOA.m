function Root_MUSIC_output_degree = Root_MUSIC_DOA(X_N, MIMO_Ant_num, snapshot, target_num)
    % X: 输入信号
    % target_num: 信源数
    % Root_MUSIC_output_degree: 估计角度

    tic %计时开始

    R = X_N * X_N' / snapshot; %计算协方差矩阵

    [R_Vector, ~] = eig(R); %计算特征向量并保存
    Un = R_Vector(:, 1:MIMO_Ant_num - target_num);
    Gn = Un * Un';

    coe = zeros(1, 2 * MIMO_Ant_num - 1); %提取多项式系数并对多项式求根

    for i =- (MIMO_Ant_num - 1):(MIMO_Ant_num - 1)
        coe(-i +MIMO_Ant_num) = sum(diag(Gn, i)); %对角线元素对应的系数和
    end

    r = roots(coe); %利用roots函数求多项式的根
    r = r(abs(r) < 1); %找出在单位圆里的根
    [~, I] = sort(abs(abs(r) - 1)); %挑选出最接近单位圆的K个根
    Theta = r(I(1:target_num));
    Root_MUSIC_output_degree = rad2deg(asin(-angle(Theta) / pi));

    toc %计时结束

    Root_MUSIC_output_degree = sort(Root_MUSIC_output_degree);
    disp(['Root_MUSIC估计结果：', newline, num2str(Root_MUSIC_output_degree'), newline]);

end
