close all; clear all; clc;

% CBF
% ADC Parameters
snr = 20; % input SNR (dB)
snapshot = 24; % 快拍数

d_lambda = 0.5; % 阵元间距波长比
target_theta = [0 6.9]; % 目标角度
target_num = length(target_theta); % 目标角度数
RX_num = 8; % 阵元数
RX_set = (0:RX_num - 1) + 0 * randn(1, RX_num); % 阵列排列

phi_start = -90; % 定义角区间起点
phi_end = 90; % 定义角区间终点
phi_step = 0.1;
Phi_set = phi_start:phi_step:phi_end; % 定义叫区间

% generate signal
Signal = randn(target_num, snapshot) + 1j * randn(target_num, snapshot); % 产生target_num*snapshot的随机信号
A = exp(-1j * 2 * pi * RX_set' * d_lambda * sind(target_theta)); % 导向矩阵
X = A * Signal;
X = awgn(X, snr, 'measured'); % 加白噪声

% DOA estimation
[result_CBF_wave, result_CBF_degree] = CBF_DOA(X, target_num, d_lambda, phi_step, Phi_set);
[result_MVDR_wave, result_MVDR_degree] = MVDR_DOA(X, target_num, d_lambda, phi_step, Phi_set);
[result_MUSIC_wave, result_MUSIC_degree] = MUSIC_DOA(X, target_num, d_lambda, phi_step, Phi_set);
%Linewidth = 1.5;
%plot(Phi_set, result_CBF, '--', 'Linewidth', Linewidth); hold on;
plot(Phi_set, result_CBF_wave, '--', 'Color', 'm'); hold on; % 虚线，洋红
plot(Phi_set, result_MVDR_wave, '-', 'Color', 'b'); hold on; % 实线，蓝色
plot(Phi_set, result_MUSIC_wave, '-', 'Color', 'r'); hold on; % 实线，红色
xlabel('\theta(\circ)'); ylabel('Normalized Spatial Spectrum(dB)'); % 横轴角度，纵轴归一化功率谱
legend('CBF', 'MVDR', 'MUSIC', 'Color', 'none'); % 图例
set(gca, 'color', 'none', 'FontName', 'Times New Roman', 'LooseInset', get(gca, 'TightInset')); % 设置背景为透明，字体为新罗马，图窗铺满窗口
ax = gca;
copygraphics(ax, 'ContentType', 'vector', 'BackgroundColor', 'none'); % 复制透明背景位图到剪切板
