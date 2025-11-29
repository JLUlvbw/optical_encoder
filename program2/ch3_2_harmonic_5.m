clc; clear; close all;

% 创建正弦信号
t = linspace(0, 2*pi, 1000);
y = sin(t);
yy = 0.015*sin(5*t);  % 周期为2π的正弦信号

% 绘制图形
figure;
plot(t, y, 'r-', 'LineWidth', 2);
hold on;
plot(t, yy, 'b-', 'LineWidth', 2)
grid on;

% 设置自定义横坐标刻度（以d/10为间隔）
d = 2*pi;
xticks(0:d/10:d);  % 所有刻度位置：每d/10

% 简化标签显示
xtick_labels = {'0', '', 'd/5', '', '2d/5', '', '3d/5', '', '4d/5', '', 'd'};
xticklabels(xtick_labels);

% 设置坐标轴标签
%xlabel('Phase');
xlabel('Position','FontName','Palatino Linotype', 'FontSize', 14);     % 纵坐标标签
ylabel('Amplitude (a.u.)','FontName','Palatino Linotype', 'FontSize', 14);     % 纵坐标标签
%title('Sinusoidal Signal with Period 2π');
legend('Fundamental order', 'Harmonic order 5th','FontName','Palatino Linotype', 'FontSize', 14)
% 美化图形
%set(gca, 'FontSize', 12, 'Box', 'on');
xlim([0, d]);
exportgraphics(gcf, 'figure10c.png', 'Resolution', 1200); 