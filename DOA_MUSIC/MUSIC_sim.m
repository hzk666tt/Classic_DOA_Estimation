close all; clear all; clc;

% CBF
% ADC Parameters
snr = 20; % input SNR (dB)
snapshot = 24; % 快拍数

d_lambda = 0.5; % 阵元间距波长比
target_theta = [0 10]; % 目标角度
target_num = length(target_theta); % 目标角度数
RX_num = 8; % 阵元数
RX_set = (0:RX_num - 1) + 0 * randn(1, RX_num); % 阵列排列

phi_start = -90; % 定义角区间起点
phi_end = 90; % 定义角区间终点
Phi_set = phi_start:phi_end; % 定义叫区间

% generate signal
Signal = randn(target_num, snapshot); % 产生target_num*snapshot的随机信号
A = exp(-1j * 2 * pi * RX_set' * d_lambda * sind(target_theta)); % 导向矩阵
X = A * Signal;
X = awgn(X, snr, 'measured'); % 加白噪声

% DOA estimation
plot(Phi_set, result_MUSIC, '-', 'Color', 'r'); hold on;
xlabel('Degree/°'); ylabel('Normalized power amplitude');
legend('MUSIC', 'Color', 'none');
set(gca, 'color', 'none', 'FontName', 'Times New Roman', 'LooseInset', get(gca, 'TightInset'));
ax = gca;
copygraphics(ax, 'ContentType', 'vector', 'BackgroundColor', 'none');
