clc; clear;

% 定义参数
T = 20; % 周期，单位：秒
f = 1/T; % 频率，单位：Hz
N = 8; % 周期数

% 增加时间分辨率
t = linspace(0, N*T, 10000); % 时间轴，单位：秒

% 生成正弦信号（包含谐波）
y = sin(2*pi*f*t) + 1 ;
%y = sin(2*pi*f*t) + 1 + 0.04*sin(2*3*pi*f*t+pi/6) + 0.015*sin(2*5*pi*f*t+pi/3);

% figure;
% plot(t, y)
% xlabel('时间 (秒)');
% ylabel('幅值');
% title('原始信号');
% grid on;

% 定义积分区间（单位：秒）
% 原始区间 [0, 20/3] 中的20/3≈6.667，如果单位是0.1秒，则相当于0.6667秒
% 这里假设您想要的是T/30 ≈ 6.667秒的区间
interval_length = T/2; % ~6.667秒
ddx = T/7.5;
ddx2 = 2*T/7.5;



% 定义五组积分区间（单位：秒）
intervals = [0, interval_length         ;   T,     T+interval_length    ;  2*T,      2*T+interval_length;      3*T,      3*T+interval_length     ; 4*T, 4*T+interval_length;
%             ddx+0, ddx+interval_length ;  ddx+T,  ddx+T+interval_length;  ddx+2*T,  ddx+2*T+interval_length;  ddx+3*T,  ddx+3*T+interval_length ; ddx+4*T, ddx+4*T+interval_length;
%             ddx2+0, ddx2+interval_length; ddx2+T, ddx2+T+interval_length; ddx2+2*T, ddx2+2*T+interval_length; ddx2+3*T, ddx2+3*T+interval_length; ddx2+4*T, ddx2+4*T+interval_length;
             ];

% 定义偏移量 d（单位：秒）
d_values = 0:0.001:40; % 从0秒偏移到4秒，步长0.001秒
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

% 第二组积分区间（单位：秒）
%ddx+
intervals1 = [T/4, T/4+interval_length; T+T/4, T+T/4+interval_length; 2*T+T/4, 2*T+T/4+interval_length; 3*T+T/4, 3*T+T/4+interval_length; 4*T+T/4, 4*T+T/4+interval_length;
%    ddx+T/4, ddx+T/4+interval_length; ddx+T+T/4, ddx+T+T/4+interval_length; ddx+2*T+T/4, ddx+2*T+T/4+interval_length; ddx+3*T+T/4, ddx+3*T+T/4+interval_length; ddx+4*T+T/4, ddx+4*T+T/4+interval_length;
%    ddx2+T/4, ddx2+T/4+interval_length; ddx2+T+T/4, ddx2+T+T/4+interval_length; ddx2+2*T+T/4, ddx2+2*T+T/4+interval_length; ddx2+3*T+T/4, ddx2+3*T+T/4+interval_length; ddx2+4*T+T/4, ddx2+4*T+T/4+interval_length
    ];

% 定义偏移量 d1（单位：秒）
d_values1 = 0:0.001:40; % 从0秒偏移到4秒，步长0.001秒
total_integrals1 = zeros(length(d_values1), 1);

for j = 1:length(d_values1)
    d1 = d_values1(j); % d1 的单位是秒
    
    % 计算每个偏移量 d 对应的积分和
    integrals1 = zeros(size(intervals1, 1), 1);
    for i = 1:size(intervals1, 1)
        % 获取当前区间并加上偏移量 d
        x11 = intervals1(i, 1) + d1;
        x22 = intervals1(i, 2) + d1;
        
        % 使用逻辑掩码获得更精确的积分
        mask = (t >= x11) & (t <= x22);
        if any(mask)
            integrals1(i) = trapz(t(mask), y(mask));
        else
            integrals1(i) = 0;
        end
    end
    
    % 计算当前偏移量 d 下的积分和
    total_integrals1(j) = sum(integrals1);
end




%第三组
% 定义五组积分区间（单位：秒）
intervals2 = [T/2, T/2+interval_length; T+T/2, T+T/2+interval_length; 2*T+T/2, 2*T+T/2+interval_length; 3*T+T/2, 3*T+T/2+interval_length; 4*T+T/2, 4*T+T/2+interval_length;
%    ddx+T/4, ddx+T/4+interval_length; ddx+T+T/4, ddx+T+T/4+interval_length; ddx+2*T+T/4, ddx+2*T+T/4+interval_length; ddx+3*T+T/4, ddx+3*T+T/4+interval_length; ddx+4*T+T/4, ddx+4*T+T/4+interval_length;
%    ddx2+T/4, ddx2+T/4+interval_length; ddx2+T+T/4, ddx2+T+T/4+interval_length; ddx2+2*T+T/4, ddx2+2*T+T/4+interval_length; ddx2+3*T+T/4, ddx2+3*T+T/4+interval_length; ddx2+4*T+T/4, ddx2+4*T+T/4+interval_length
    ];

% 定义偏移量 d（单位：秒）
d_values2 = 0:0.001:40; % 从0秒偏移到4秒，步长0.001秒
total_integrals2 = zeros(length(d_values2), 1);

for j = 1:length(d_values2)
    d = d_values2(j); % d 的单位是秒
    
    integrals2 = zeros(size(intervals2, 1), 1);
    for i = 1:size(intervals2, 1)
        % 获取当前区间并加上偏移量 d
        x1 = intervals2(i, 1) + d;
        x2 = intervals2(i, 2) + d;
        
        % 使用逻辑掩码获得更精确的积分
        mask = (t >= x1) & (t <= x2);
        if any(mask)
            integrals2(i) = trapz(t(mask), y(mask));
        else
            integrals2(i) = 0;
        end
    end
    
    total_integrals2(j) = sum(integrals2);
end

% 第四组积分区间（单位：秒）
%ddx+
intervals3 = [3*T/4, 3*T/4+interval_length; T+3*T/4, T+3*T/4+interval_length; 2*T+3*T/4, 2*T+3*T/4+interval_length; 3*T+3*T/4, 3*T+3*T/4+interval_length; 4*T+3*T/4, 4*T+3*T/4+interval_length;
%    ddx+T/4, ddx+T/4+interval_length; ddx+T+T/4, ddx+T+T/4+interval_length; ddx+2*T+T/4, ddx+2*T+T/4+interval_length; ddx+3*T+T/4, ddx+3*T+T/4+interval_length; ddx+4*T+T/4, ddx+4*T+T/4+interval_length;
%    ddx2+T/4, ddx2+T/4+interval_length; ddx2+T+T/4, ddx2+T+T/4+interval_length; ddx2+2*T+T/4, ddx2+2*T+T/4+interval_length; ddx2+3*T+T/4, ddx2+3*T+T/4+interval_length; ddx2+4*T+T/4, ddx2+4*T+T/4+interval_length
    ];

% 定义偏移量 d1（单位：秒）
d_values3 = 0:0.001:40; % 从0秒偏移到4秒，步长0.001秒
total_integrals3 = zeros(length(d_values1), 1);

for j = 1:length(d_values3)
    d1 = d_values3(j); % d1 的单位是秒
    
    % 计算每个偏移量 d 对应的积分和
    integrals3 = zeros(size(intervals3, 1), 1);
    for i = 1:size(intervals3, 1)
        % 获取当前区间并加上偏移量 d
        x11 = intervals3(i, 1) + d1;
        x22 = intervals3(i, 2) + d1;
        
        % 使用逻辑掩码获得更精确的积分
        mask = (t >= x11) & (t <= x22);
        if any(mask)
            integrals3(i) = trapz(t(mask), y(mask));
        else
            integrals3(i) = 0;
        end
    end
    
    % 计算当前偏移量 d 下的积分和
    total_integrals3(j) = sum(integrals3);
end




figure;
plot(d_values , total_integrals,'LineWidth', 1.5); % 将秒转换为微米 (假设1秒=100000微米)
hold on;
plot(d_values, total_integrals1, 'LineWidth', 1.5);
hold on;
plot(d_values, total_integrals2, 'LineWidth', 1.5);
hold on;
plot(d_values, total_integrals3, 'LineWidth', 1.5);
% xlabel('Position(μm)');
% ylabel('S_1,S_2,S_3,S_4');
% legend('S_1', 'S_2','S_3','S_4');
xlabel('Position (μm)', 'FontName', 'Palatino Linotype', 'FontSize', 14);
ylabel('{\it S}_1, {\it S}_2, {\it S}_3, {\it S}_4 (a.u.)', 'FontName', 'Palatino Linotype', 'FontSize', 14);
legend('{\it S}_1', '{\it S}_2', '{\it S}_3', '{\it S}_4', 'FontName', 'Palatino Linotype', 'FontSize', 14);
%title('积分值随相对位移变化图');
grid on;
exportgraphics(gcf, 'figure6a.png', 'Resolution', 1200); 

max_y = max(total_integrals1);
min_y = min(total_integrals1);
yy1 = (max_y - min_y)/2 * sin(2*pi*f*d_values) + (max_y + min_y)/2;
yy2 = (max_y - min_y)/2 * cos(2*pi*f*d_values) + (max_y + min_y)/2;

figure
plot(total_integrals(1:80:end), total_integrals1(1:80:end), 's-', 'LineWidth', 0.8, 'MarkerSize', 7);
hold on;
plot(total_integrals2(2:50:end), total_integrals3(2:50:end), '*-', 'LineWidth', 1, 'MarkerSize', 8);
hold on;
plot(yy1, yy2,'LineWidth', 2);


% figure;
% plot(total_integrals, total_integrals1, 'X', 'LineWidth', 1.2);
% hold on;
% plot(total_integrals2, total_integrals3, 'O', 'LineWidth', 0.4);
% hold on;
%plot(yy1, yy2,'LineWidth', 0.8);
legend('{\it S}_1,{\it S}_2 Lissajous plot', '{\it S}_3,{\it S}_4 Lissajous plot','Standard circle', 'FontName', 'Palatino Linotype', 'FontSize', 14);
xlabel('{\it S}_1,{\it S}_3 (a.u.)', 'FontName', 'Palatino Linotype', 'FontSize', 14);
ylabel('{\it S}_2,{\it S}_4 (a.u.)','FontName', 'Palatino Linotype', 'FontSize', 14), 
axis equal;
grid on;
exportgraphics(gcf, 'figure6b.png', 'Resolution', 1200); 
%title('李萨如图形');

% %% 频谱分析和谐波占比计算
% Fs = 1/(t(2)-t(1)); % 采样频率
% L = length(y); % 信号长度
% 
% Y = fft(y);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% freq = Fs*(0:(L/2))/L;
% 
% % 找到基波频率位置
% fundamental_freq = f; % 0.001 Hz
% [~, fund_idx] = min(abs(freq - fundamental_freq));
% 
% % 找到三次谐波频率位置 (3*f)
% third_harmonic_freq = 3*f;
% [~, third_idx] = min(abs(freq - third_harmonic_freq));
% 
% % 找到五次谐波频率位置 (5*f)
% fifth_harmonic_freq = 5*f;
% [~, fifth_idx] = min(abs(freq - fifth_harmonic_freq));
% 
% % 计算谐波占比
% fundamental_amplitude = P1(fund_idx);
% third_harmonic_amplitude = P1(third_idx);
% fifth_harmonic_amplitude = P1(fifth_idx);
% 
% third_harmonic_ratio = (third_harmonic_amplitude / fundamental_amplitude) * 100;
% fifth_harmonic_ratio = (fifth_harmonic_amplitude / fundamental_amplitude) * 100;
% 
% %% 积分结果的谐波分析
% Fs_d = 1/(d_values(2)-d_values(1)); % d的采样频率
% L_d = length(total_integrals);
% 
% Y_int = fft(total_integrals - mean(total_integrals)); % 去除直流分量
% P2_int = abs(Y_int/L_d);
% P1_int = P2_int(1:L_d/2+1);
% P1_int(2:end-1) = 2*P1_int(2:end-1);
% freq_d = Fs_d*(0:(L_d/2))/L_d;
% 
% % 找到积分结果中的基波频率（主要频率成分）
% [~, main_freq_idx] = max(P1_int(2:end)); % 跳过直流分量
% main_freq_idx = main_freq_idx + 1;
% main_frequency = freq_d(main_freq_idx);
% 
% % 找到积分结果中的三次和五次谐波
% [~, third_int_idx] = min(abs(freq_d - 3*main_frequency));
% [~, fifth_int_idx] = min(abs(freq_d - 5*main_frequency));
% 
% % 计算积分结果的谐波占比
% main_amplitude_int = P1_int(main_freq_idx);
% third_amplitude_int = P1_int(third_int_idx);
% fifth_amplitude_int = P1_int(fifth_int_idx);
% 
% third_ratio_int = (third_amplitude_int / main_amplitude_int) * 100;
% fifth_ratio_int = (fifth_amplitude_int / main_amplitude_int) * 100;
% 
% %% 绘制频谱图并在图上显示谐波占比
% figure;
% plot(freq, P1, 'b', 'LineWidth', 1.5);
% hold on;
% plot(freq(fund_idx), fundamental_amplitude, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
% plot(freq(third_idx), third_harmonic_amplitude, 'go', 'MarkerSize', 8, 'LineWidth', 2);
% plot(freq(fifth_idx), fifth_harmonic_amplitude, 'mo', 'MarkerSize', 8, 'LineWidth', 2);
% 
% % 在图上添加谐波占比文本
% text(freq(fund_idx)+0.0005, fundamental_amplitude, '基波', 'FontSize', 10, 'Color', 'r');
% text(freq(third_idx)+0.0005, third_harmonic_amplitude, ...
%     sprintf('三次谐波: %.1f%%', third_harmonic_ratio), 'FontSize', 10, 'Color', 'g');
% text(freq(fifth_idx)+0.0005, fifth_harmonic_amplitude, ...
%     sprintf('五次谐波: %.1f%%', fifth_harmonic_ratio), 'FontSize', 10, 'Color', 'm');
% 
% xlabel('频率 (Hz)');
% ylabel('幅值');
% title('原始信号频谱 - 谐波分析');
% xlim([0, 0.03]);
% grid on;
% box on;
% 
% % 积分结果频谱
% figure;
% plot(freq_d, P1_int, 'r', 'LineWidth', 1.5);
% hold on;
% plot(freq_d(main_freq_idx), main_amplitude_int, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
% plot(freq_d(third_int_idx), third_amplitude_int, 'go', 'MarkerSize', 8, 'LineWidth', 2);
% plot(freq_d(fifth_int_idx), fifth_amplitude_int, 'mo', 'MarkerSize', 8, 'LineWidth', 2);
% % 在图上添加谐波占比文本
% text(freq_d(main_freq_idx)+0.0005, main_amplitude_int, '基频', 'FontSize', 10, 'Color', 'r');
% text(freq_d(third_int_idx)+0.0005, third_amplitude_int, ...
%     sprintf('三次谐波: %.1f%%', third_ratio_int), 'FontSize', 10, 'Color', 'g');
% text(freq_d(fifth_int_idx)+0.0005, fifth_amplitude_int, ...
%     sprintf('五次谐波: %.1f%%', fifth_ratio_int), 'FontSize', 10, 'Color', 'm');
% 
% xlabel('频率 (1/秒)');
% ylabel('幅值');
% title('积分结果频谱 - 谐波分析');
% xlim([0, 0.03]);
% grid on;
% box on;
% 
% %% 控制台输出详细结果
% fprintf('=== 原始信号谐波分析 ===\n');
% fprintf('基波频率: %.4f Hz, 幅值: %.4f\n', fundamental_freq, fundamental_amplitude);
% fprintf('三次谐波频率: %.4f Hz, 幅值: %.4f, 占比: %.2f%%\n', ...
%     third_harmonic_freq, third_harmonic_amplitude, third_harmonic_ratio);
% fprintf('五次谐波频率: %.4f Hz, 幅值: %.4f, 占比: %.2f%%\n', ...
%     fifth_harmonic_freq, fifth_harmonic_amplitude, fifth_harmonic_ratio);
% fprintf('========================\n\n');
% 
% fprintf('=== 积分结果谐波分析 ===\n');
% fprintf('主要频率: %.4f 1/秒, 幅值: %.4f\n', main_frequency, main_amplitude_int);
% fprintf('三次谐波频率: %.4f 1/秒, 幅值: %.4f, 占比: %.2f%%\n', ...
%     freq_d(third_int_idx), third_amplitude_int, third_ratio_int);
% fprintf('五次谐波频率: %.4f 1/秒, 幅值: %.4f, 占比: %.2f%%\n', ...
%     freq_d(fifth_int_idx), fifth_amplitude_int, fifth_ratio_int);
% fprintf('========================\n\n');