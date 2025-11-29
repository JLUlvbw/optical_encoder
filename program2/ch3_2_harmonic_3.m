clc; clear; close all;

% 创建正弦信号
t = linspace(0, 2*pi, 1000);  % 从0到2π
y = sin(t);  % 周期为2π的正弦信号
yy = 0.04*sin(3*t);  % 周期为2π的正弦信号

% 绘制图形
figure;
plot(t, y, 'r-', 'LineWidth', 2);
hold on;
plot(t, yy, 'g-', 'LineWidth', 2)
grid on;

% 设置自定义横坐标刻度
d = 2*pi;
xticks(0:d/6:d);  % 从0到d，步长为d/6

% 生成对应的标签
xtick_labels = {'0', 'd/6', 'd/3', 'd/2', '2d/3', '5d/6', 'd'};
xticklabels(xtick_labels);


xlim([0, 2*pi]);
% 设置坐标轴标签
xlabel('Position','FontName','Palatino Linotype', 'FontSize', 14);     % 纵坐标标签
ylabel('Amplitude (a.u.)','FontName','Palatino Linotype', 'FontSize', 14);     % 纵坐标标签
%title('Sinusoidal Signal with Period 2π');
legend('Fundamental order', 'Harmonic order 3rd','FontName','Palatino Linotype', 'FontSize', 14)
% 添加网格和美化图形
grid on;
%set(gca, 'FontSize', 12);
exportgraphics(gcf, 'figure10a.png', 'Resolution', 1200); 