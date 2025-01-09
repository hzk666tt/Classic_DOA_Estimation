close all; clear all; clc;
% ADC Parameters
snr = 5; % input SNR (dB)
snapshot = 128; % 快拍数

d_lambda = 0.5; % 阵元间距波长比
target_theta = [-1.1 9.9]; % 目标角度
target_theta_rad = deg2rad(target_theta); % 转为弧度
target_num = length(target_theta_rad); % 目标角度数
RX_num = 8; % 阵元数
RX_set = 0:1:RX_num - 1; % 阵列排列

phi_start = -90; % 定义角区间起点
phi_end = 90; % 定义角区间终点
phi_step = 0.1;
Phi_set = phi_start:phi_step:phi_end; % 定义叫区间

% generate signal
Signal = randn(target_num, snapshot) + 1j * randn(target_num, snapshot); % 产生target_num*snapshot的随机信号
A = exp(-1j * 2 * pi * RX_set' * d_lambda * sin(target_theta_rad)); % 导向矩阵
X = A * Signal;
X = awgn(X, snr, 'measured'); % 加白噪声

% DOA estimation
result_LTS_ESPRIT_degree = LTS_ESPRIT_DOA(X, target_num);
plot(result_LTS_ESPRIT_degree, 0, 'o', 'Color', 'b'); hold on;
xline(target_theta(1), '--', 'Color', 'k'); hold on;
xline(target_theta(2), '--', 'Color', 'k'); hold on;
xlabel('\theta(\circ)'); ylabel('Normalized Spatial Spectrum(dB)');
legend('LTS-ESPRIT', '', '-1.1\circ/9.9\circ', 'Color', 'none');
set(gca, 'color', 'none', 'FontName', 'Times New Roman', 'LooseInset', get(gca, 'TightInset'));
ax = gca;
copygraphics(ax, 'ContentType', 'vector', 'BackgroundColor', 'none');
