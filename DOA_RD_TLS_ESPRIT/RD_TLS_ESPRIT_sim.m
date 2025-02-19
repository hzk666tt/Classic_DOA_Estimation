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
result_RD_TLS_ESPRIT_degree = RD_TLS_ESPRIT_DOA(S_N, G, Tx_num, Rx_num, snapshot, target_num);
plot(result_RD_TLS_ESPRIT_degree, 0, 'o', 'Color', 'b'); hold on;
xline(target_theta(1), '--', 'Color', 'k'); hold on;
xline(target_theta(2), '--', 'Color', 'k'); hold on;
xlabel('\theta(\circ)'); ylabel('Normalized Spatial Spectrum(dB)');
legend('LTS-ESPRIT', '', '-1.1\circ/9.9\circ', 'Color', 'none');
set(gca, 'color', 'none', 'FontName', 'Times New Roman', 'LooseInset', get(gca, 'TightInset'));
ax = gca; copygraphics(ax, 'ContentType', 'vector', 'BackgroundColor', 'none');
