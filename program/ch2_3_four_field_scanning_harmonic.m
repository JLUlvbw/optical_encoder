clc; clear;

% 定义参数
T = 20; % 周期，单位：秒
f = 1/T; % 频率，单位：Hz
N = 8; % 周期数

% 增加时间分辨率
t = linspace(0, N*T, 10000); % 时间轴，单位：秒

% 生成正弦信号（包含谐波）
%y = sin(2*pi*f*t) + 1 ;
y = sin(2*pi*f*t) + 1 + 0.04*sin(2*3*pi*f*t+pi/5) + 0.015*sin(2*5*pi*f*t+pi/7);

% figure;
% plot(t, y)
% xlabel('时间 (秒)');
% ylabel('幅值');
% title('原始信号');
% grid on;

% ==================== 频谱分析和谐波占比计算 ====================
Fs = 1/(t(2)-t(1)); % 采样频率
L = length(y); % 信号长度


Y = fft(y-1);
%Y = fft(y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freq = Fs*(0:(L/2))/L;

% 找到基波频率位置
fundamental_freq = f; % 0.05 Hz
[~, fund_idx] = min(abs(freq - fundamental_freq));

% 找到三次谐波频率位置 (3*f)
third_harmonic_freq = 3*f;
[~, third_idx] = min(abs(freq - third_harmonic_freq));

% 找到五次谐波频率位置 (5*f)
fifth_harmonic_freq = 5*f;
[~, fifth_idx] = min(abs(freq - fifth_harmonic_freq));

% 计算谐波占比
fundamental_amplitude = P1(fund_idx);
third_harmonic_amplitude = P1(third_idx);
fifth_harmonic_amplitude = P1(fifth_idx);

third_harmonic_ratio = (third_harmonic_amplitude / fundamental_amplitude) * 100;
fifth_harmonic_ratio = (fifth_harmonic_amplitude / fundamental_amplitude) * 100;

% 显示原始信号谐波分析结果
fprintf('=== 原始信号谐波分析 ===\n');
fprintf('基波频率: %.4f Hz, 幅值: %.6f\n', fundamental_freq, fundamental_amplitude);
fprintf('三次谐波频率: %.4f Hz, 幅值: %.6f, 占比: %.2f%%\n', third_harmonic_freq, third_harmonic_amplitude, third_harmonic_ratio);
fprintf('五次谐波频率: %.4f Hz, 幅值: %.6f, 占比: %.2f%%\n', fifth_harmonic_freq, fifth_harmonic_amplitude, fifth_harmonic_ratio);

% ==================== 积分计算部分 ====================
% 定义积分区间（单位：秒）
interval_length = T/2; % ~6.667秒
ddx = T/7.5;
ddx2 = 2*T/7.5;

% 定义五组积分区间（单位：秒）
intervals = [0, interval_length         ;   T,     T+interval_length    ;  2*T,      2*T+interval_length;      3*T,      3*T+interval_length     ; 4*T, 4*T+interval_length;
%             ddx+0, ddx+interval_length ;  ddx+T,  ddx+T+interval_length;  ddx+2*T,  ddx+2*T+interval_length;  ddx+3*T,  ddx+3*T+interval_length ; ddx+4*T, ddx+4*T+interval_length;
%             ddx2+0, ddx2+interval_length; ddx2+T, ddx2+T+interval_length; ddx2+2*T, ddx2+2*T+interval_length; ddx2+3*T, ddx2+3*T+interval_length; ddx2+4*T, ddx2+4*T+interval_length;
             ];

% 定义偏移量 d（单位：秒）
d_values = 0:0.005:40; % 从0秒偏移到40秒，步长0.05秒
total_integrals = zeros(length(d_values), 1);

for j = 1:length(d_values)
    d = d_values(j); % d 的单位是秒
    
    integrals = zeros(size(intervals, 1), 1);
    for i = 1:size(intervals, 1)
        % 获取当前区间并加上偏移量 d
        x1 = intervals(i, 1) + d;
        x2 = intervals(i, 2) + d;
        
        % 使用逻辑掩码获得更精确的积分
        mask = (t >= x1) & (t <= x2);
        if any(mask)
            integrals(i) = trapz(t(mask), y(mask));
        else
            integrals(i) = 0;
        end
    end
    
    total_integrals(j) = sum(integrals);
end

% ==================== 积分结果的谐波分析 ====================
Fs_d = 1/(d_values(2)-d_values(1)); % d的采样频率
L_d = length(total_integrals);

Y_int = fft(total_integrals ); % 去除直流分量
%Y_int = fft(total_integrals - mean(total_integrals)); % 去除直流分量
P2_int = abs(Y_int/L_d);
P1_int = P2_int(1:L_d/2+1);
P1_int(2:end-1) = 2*P1_int(2:end-1);
freq_d = Fs_d*(0:(L_d/2))/L_d;

% 找到积分结果中的基波频率（主要频率成分）
[~, main_freq_idx] = max(P1_int(2:end)); % 跳过直流分量
main_freq_idx = main_freq_idx + 1;
main_frequency = freq_d(main_freq_idx);

% 找到积分结果中的三次和五次谐波
[~, third_int_idx] = min(abs(freq_d - 3*main_frequency));
[~, fifth_int_idx] = min(abs(freq_d - 5*main_frequency));

% 计算积分结果的谐波占比
main_amplitude_int = P1_int(main_freq_idx);
third_amplitude_int = P1_int(third_int_idx);
fifth_amplitude_int = P1_int(fifth_int_idx);

third_ratio_int = (third_amplitude_int / main_amplitude_int) * 100;
fifth_ratio_int = (fifth_amplitude_int / main_amplitude_int) * 100;

% 显示积分结果谐波分析结果
fprintf('\n=== 积分结果谐波分析 ===\n');
fprintf('主要频率: %.4f Hz, 幅值: %.6f\n', main_frequency, main_amplitude_int);
fprintf('三次谐波频率: %.4f Hz, 幅值: %.6f, 占比: %.2f%%\n', 3*main_frequency, third_amplitude_int, third_ratio_int);
fprintf('五次谐波频率: %.4f Hz, 幅值: %.6f, 占比: %.2f%%\n', 5*main_frequency, fifth_amplitude_int, fifth_ratio_int);

% ==================== 绘制频谱图并在图上显示谐波占比 ====================
% 原始信号频谱图
figure;
%subplot(2,1,1);
plot(freq, P1, 'b', 'LineWidth', 1.5);
hold on;
plot(freq(fund_idx), fundamental_amplitude, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
plot(freq(third_idx), third_harmonic_amplitude, 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(freq(fifth_idx), fifth_harmonic_amplitude, 'mo', 'MarkerSize', 8, 'LineWidth', 2);

% 在图上添加谐波占比文本
text(freq(fund_idx)+0.001, fundamental_amplitude, '基波', 'FontSize', 10, 'Color', 'r');
text(freq(third_idx)+0.001, third_harmonic_amplitude, ...
    sprintf('三次谐波: %.1f%%', third_harmonic_ratio), 'FontSize', 10, 'Color', 'g');
text(freq(fifth_idx)+0.001, fifth_harmonic_amplitude, ...
    sprintf('五次谐波: %.1f%%', fifth_harmonic_ratio), 'FontSize', 10, 'Color', 'm');

xlabel('harmonic order N');
%
ylabel('amplitude');
%ylabel('幅值');
%title('原始信号频谱 - 谐波分析');
xlim([0, 0.3]);
grid on;
box on;
%harmonic order N
%spectrum
legend('four-field spectrum', 'fundamental order', 'harmonic order 3rd', 'harmonic order 5th', 'Location', 'northeast');
%legend('频谱', '基波', '三次谐波', '五次谐波', 'Location', 'northeast');

% 积分结果频谱图
%subplot(2,1,2);
figure;
plot(freq_d, P1_int, 'r', 'LineWidth', 1.5);
hold on;
plot(freq_d(main_freq_idx), main_amplitude_int, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
plot(freq_d(third_int_idx), third_amplitude_int, 'bo', 'MarkerSize', 8, 'LineWidth', 2);
plot(freq_d(fifth_int_idx), fifth_amplitude_int, 'go', 'MarkerSize', 8, 'LineWidth', 2);

% 在图上添加谐波占比文本
%fundamental order
text(freq_d(main_freq_idx)-0.025, main_amplitude_int+2.5, 'Fundamental order', 'FontSize', 10, 'Color', 'r');


%text(freq_d(main_freq_idx)+0.01, main_amplitude_int, '基频', 'FontSize', 10, 'Color', 'r');
%harmonic order 3rd

text(freq_d(third_int_idx)-0.055, third_amplitude_int+3.5, ...
    sprintf('Harmonic order 3rd: %.2f%%', third_ratio_int), 'FontSize', 10, 'Color', 'b');
text(freq_d(fifth_int_idx)-0.055, fifth_amplitude_int+2.0, ...
    sprintf('Harmonic order 5th: %.2f%%', fifth_ratio_int), 'FontSize', 10, 'Color', 'g');

% text(freq_d(third_int_idx)+0.001, third_amplitude_int, ...
%     sprintf('三次谐波: %.1f%%', third_ratio_int), 'FontSize', 10, 'Color', 'g');
% text(freq_d(fifth_int_idx)+0.001, fifth_amplitude_int, ...
%     sprintf('五次谐波: %.1f%%', fifth_ratio_int), 'FontSize', 10, 'Color', 'm');

xlabel('Harmonic order N');
%
ylabel('Amplitude');
% xlabel('频率 (Hz)');
% ylabel('幅值');
% title('积分结果频谱 - 谐波分析');
xlim([0, 0.3]);
xticks(0.05:0.05:0.3);  % 从0.05到0.3，步长0.05
xticklabels({'1', '2', '3', '4', '5', '6'});  % 对应的标签
grid on;
box on;
legend('Four-field spectrum', 'Fundamental order', 'Harmonic order 3rd', 'Harmonic order 5th', 'Location', 'northeast');
%legend('频谱', '基频', '三次谐波', '五次谐波', 'Location', 'northeast');
exportgraphics(gcf, 'figure8a.png', 'Resolution', 1200); 


% ==================== 对比分析图 ====================
figure;
subplot(3,1,1);
plot(d_values, total_integrals, 'LineWidth', 1.5);
xlabel('偏移量 d (秒)');
ylabel('积分值');
title('积分结果随偏移量变化');
grid on;

% 频谱对比
subplot(3,1,2);
plot(freq, P1, 'b', 'LineWidth', 1.5);
hold on;
plot(freq_d, P1_int, 'r', 'LineWidth', 1.5);
xlabel('频率 (Hz)');
ylabel('幅值');
title('频谱对比 - 蓝色:原始信号, 红色:积分结果');
xlim([0, 0.3]);
grid on;
legend('原始信号', '积分结果');

% 谐波占比对比
subplot(3,1,3);
harmonics_original = [fundamental_amplitude, third_harmonic_amplitude, fifth_harmonic_amplitude];
harmonics_integral = [main_amplitude_int, third_amplitude_int, fifth_amplitude_int];
ratios_original = [100, third_harmonic_ratio, fifth_harmonic_ratio];
ratios_integral = [100, third_ratio_int, fifth_ratio_int];

bar([ratios_original; ratios_integral]');
set(gca, 'XTickLabel', {'基波', '三次谐波', '五次谐波'});
ylabel('相对占比 (%)');
title('谐波占比对比');
legend('原始信号', '积分结果');
grid on;

% ==================== 详细数据输出 ====================
fprintf('\n=== 详细对比分析 ===\n');
fprintf('频率成分对比:\n');
fprintf('                原始信号    积分结果\n');
fprintf('基波频率(Hz):   %.4f     %.4f\n', fundamental_freq, main_frequency);
fprintf('三次谐波(Hz):   %.4f     %.4f\n', third_harmonic_freq, 3*main_frequency);
fprintf('五次谐波(Hz):   %.4f     %.4f\n', fifth_harmonic_freq, 5*main_frequency);

fprintf('\n谐波占比变化:\n');
fprintf('                原始信号    积分结果    变化\n');
fprintf('三次谐波占比:   %.2f%%     %.2f%%     %+.2f%%\n', ...
    third_harmonic_ratio, third_ratio_int, third_ratio_int - third_harmonic_ratio);
fprintf('五次谐波占比:   %.2f%%     %.2f%%     %+.2f%%\n', ...
    fifth_harmonic_ratio, fifth_ratio_int, fifth_ratio_int - fifth_harmonic_ratio);