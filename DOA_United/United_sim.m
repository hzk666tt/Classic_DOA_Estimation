close all; clear all; clc;

snr = 5; % 信噪比
snapshot = 128; % 快拍数

target_theta = [-1.1 9.9]; % 目标角度
target_theta_rad = deg2rad(target_theta); % 转为弧度
target_num = length(target_theta_rad); % 目标角度数

Tx_num = 2;
Rx_num = 4;

MIMO_Ant_num = Tx_num * Rx_num; % MIMO阵元数
MIMO_Ant_set = 0:1:MIMO_Ant_num - 1; % MIMO阵列排列

Virtual_Ant_num = Tx_num + Rx_num - 1; % 降维阵元数
Virtual_Ant_set = 0:1:Virtual_Ant_num - 1; % 降维阵列排列

phi_start = -90; % 定义角区间起点
phi_end = 90; % 定义角区间终点
phi_step = 0.1; %定义网格步长
phi_set = phi_start:phi_step:phi_end; % 定义角区间

% generate signal
S = randn(target_num, snapshot) + 1j * randn(target_num, snapshot); % 产生target_num*snapshot的随机信号
A = exp(-1j * pi * MIMO_Ant_set' * sin(target_theta_rad)); % 导向矩阵
X = A * S;
X_N = awgn(X, snr, 'measured'); % 加白噪声

G = exp(-1j * pi * Virtual_Ant_set' * sin(target_theta_rad)); % 降维导向矩阵
S_N = awgn(S, snr, 'measured');

% DOA estimation
[result_CBF_wave, result_CBF_degree] = CBF_DOA(X_N, MIMO_Ant_num, target_num, phi_step, phi_set);
[result_MVDR_wave, result_MVDR_degree] = MVDR_DOA(X_N, MIMO_Ant_num, snapshot, target_num, phi_step, phi_set);
[result_MUSIC_wave, result_MUSIC_degree] = MUSIC_DOA(X_N, MIMO_Ant_num, snapshot, target_num, phi_step, phi_set);
result_LTS_ESPRIT_degree = LTS_ESPRIT_DOA(X_N, MIMO_Ant_num, snapshot, target_num);
result_Root_MUSIC_degree = Root_MUSIC_DOA(X_N, MIMO_Ant_num, snapshot, target_num);
result_RD_LTS_ESPRIT_degree = RD_LTS_ESPRIT_DOA(S_N, G, Tx_num, Rx_num, snapshot, target_num);
%Linewidth = 1.5;
%plot(Phi_set, result_CBF, '--', 'Linewidth', Linewidth); hold on;
plot(phi_set, result_CBF_wave, '--', 'Color', 'r'); hold on; % 虚线，洋红
plot(phi_set, result_MVDR_wave, '-.', 'Color', 'b'); hold on; % 实线，蓝色
plot(phi_set, result_MUSIC_wave, '-', 'Color', 'r'); hold on; % 实线，红色
plot(result_LTS_ESPRIT_degree, 0, 'db ', 'MarkerFaceColor', 'b'); hold on; % 圆圈，蓝色
plot(result_Root_MUSIC_degree, 0, 'sg', 'MarkerFaceColor', 'g'); hold on; % 圆圈，绿色
plot(result_RD_LTS_ESPRIT_degree, 0, 'bx', 'MarkerFaceColor', 'b'); % 叉，蓝色

xline(target_theta(1), '--', 'Color', 'k'); hold on;
xline(target_theta(2), '--', 'Color', 'k'); hold on;
xlabel('\theta(\circ)', 'FontSize', 11); ylabel('Normalized Spectrum(dB)', 'FontSize', 11); % 横轴角度，纵轴归一化功率谱
grid on;

title('\fontname{宋体}经典\fontname{Times new roman}DOA\fontname{宋体}算法性能对比');
legend('CBF', 'MVDR', 'MUSIC', 'LTS-ESPRIT', '', 'Root-MUSIC', '', 'RD-LTS-ESPRIT', '' ...
    , ['Real \theta (', num2str(target_theta(1)), '\circ, ', num2str(target_theta(2)), '\circ)'], ...
    '', 'Color', 'none', 'FontSize', 6); % 图例
%legend('CBF', 'MVDR', 'MUSIC', 'LTS-ESPRIT', '', ...
%    ['Real: ',num2str(target_theta(1)),'\circ/',num2str(target_theta(2)),'\circ'], '', 'Color', 'none'); % 图例
%legend(['CBF: ',num2str(result_CBF_degree)], ['MVDR: ',num2str(result_MVDR_degree)], ...
%    ['MUSIC: ',num2str(result_MUSIC_degree)],['LTS-ESPRIT: ',num2str(result_LTS_ESPRIT_degree')], ...
%    '',['Real:  ',num2str(target_theta(1)),'\circ/',num2str(target_theta(2)),'\circ'],'','Color', 'none'); % 图例
set(gca, 'XTick', phi_start:15:phi_end, 'FontSize', 11); %设置横轴10°为间隔
xlim([-45 45]);
set(gca, 'color', 'none', 'FontName', 'Times New Roman', 'LooseInset', get(gca, 'TightInset')); % 设置背景为透明，字体为新罗马，图窗铺满窗口
ax = gca;
copygraphics(ax, 'ContentType', 'vector', 'BackgroundColor', 'none'); % 复制透明背景位图到剪切板
