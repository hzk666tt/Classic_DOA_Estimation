close all; clear all; clc;

snr = 5; % input SNR (dB)
snapshot = 128; % 快拍数

target_theta = [0 20]; % 目标角度
target_theta_rad = deg2rad(target_theta); % 转为弧度
target_num = length(target_theta_rad); % 目标角度数

Tx_num = 2;
Rx_num = 4;

MIMO_Ant_num = Tx_num * Rx_num; % MIMO阵元数
MIMO_Ant_set = 0:1:MIMO_Ant_num - 1; % MIMO阵列排列

phi_start = -90; % 定义角区间起点
phi_end = 90; % 定义角区间终点
phi_step = 0.1; %定义网格步长
phi_set = phi_start:phi_step:phi_end; % 定义角区间

% generate signal
Signal = randn(target_num, snapshot) + 1j * randn(target_num, snapshot); % 产生target_num*snapshot的随机信号
A = exp(-1j * pi * MIMO_Ant_set' * sin(target_theta_rad)); % 导向矩阵
X = A * Signal;
X_N = awgn(X, snr, 'measured'); % 加白噪声

% DOA estimation
[result_CBF_wave, result_CBF_degree] = CBF_DOA(X_N, MIMO_Ant_num, target_num, phi_step, phi_set);
plot(phi_set, result_CBF_wave, '--', 'Color', 'm'); hold on;
xlabel('\theta(\circ)'); ylabel('Normalized Spatial Spectrum(dB)');
legend('CBF', 'Color', 'none');
set(gca, 'color', 'none', 'FontName', 'Times New Roman', 'LooseInset', get(gca, 'TightInset'));
ax = gca;
copygraphics(ax, 'ContentType', 'vector', 'BackgroundColor', 'none');
