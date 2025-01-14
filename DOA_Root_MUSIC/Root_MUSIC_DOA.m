function Root_MUSIC_output_degree = Root_MUSIC_DOA(X, target_num)
    % X: 输入信号
    % target_num: 信源数
    % Root_MUSIC_output_degree: 估计角度

    tic %计时开始

    row = size(X, 1); %阵元数
    column = size(X, 2); %快拍数
    R = X * X' / column; %计算协方差矩阵

    [R_Vector, ~] = eig(R); %计算特征向量并保存
    Un = R_Vector(:, 1:row - target_num);
    Gn = Un * Un';

    coe = zeros(1, 2 * row - 1); %提取多项式系数并对多项式求根

    for i =- (row - 1):(row - 1)
        coe(-i +row) = sum(diag(Gn, i)); %对角线元素对应的系数和
    end

    r = roots(coe); %利用roots函数求多项式的根
    r = r(abs(r) < 1); %找出在单位圆里的根
    [~, I] = sort(abs(abs(r) - 1)); %挑选出最接近单位圆的K个根
    Theta = r(I(1:target_num));
    Root_MUSIC_output_degree = rad2deg(asin(-angle(Theta) / pi));

    toc %计时结束

    Root_MUSIC_output_degree = sort(Root_MUSIC_output_degree);
    disp(['Root_MUSIC估计结果：', newline, num2str(Root_MUSIC_output_degree'), newline]);
    %disp(MUSIC_output_degree);

end
