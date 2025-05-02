function plot_Gnp_Pwave(n, p)
% plot_Gnp_Pwave(n, p)
% 画出指定观测方向 n 和 点力方向 p 的 Green函数P波部分正负分布图和幅值图
% n, p = 1 (X) / 2 (Y) / 3 (Z)

% 网格设置
x = linspace(-50,50,1000); % 东西方向 (km)
y = linspace(-50,50,1000); % 南北方向 (km)
[X, Y] = meshgrid(x, y);

z_source = -3; % 震源深度 (km)，设定固定为3 km
Z = zeros(size(X)); % 地表 z=0 km

% 震源位置
xs = 0; ys = 0; zs = z_source; 

% 计算传播向量
r_total = sqrt((X - xs).^2 + (Y - ys).^2 + (Z - zs).^2);

% 避免除0
r_total(r_total==0) = 1e-6;

gamma_x = (X - xs) ./ r_total;
gamma_y = (Y - ys) ./ r_total;
gamma_z = (Z - zs) ./ r_total;

% 选取观测方向n
switch n
    case 1
        gamma_n = gamma_x;
    case 2
        gamma_n = gamma_y;
    case 3
        gamma_n = gamma_z;
    otherwise
        error('n must be 1 (X), 2 (Y), or 3 (Z)');
end

% 选取点力方向p
switch p
    case 1
        gamma_p = gamma_x;
    case 2
        gamma_p = gamma_y;
    case 3
        gamma_p = gamma_z;
    otherwise
        error('p must be 1 (X), 2 (Y), or 3 (Z)');
end

% 计算Gnp^P
Gnp = gamma_n .* gamma_p./r_total;

% 绘制符号分布
figure;
subplot(1,2,1);
imagesc(x, y, sign(Gnp));
axis xy; axis equal;
xlabel('East (km)');
ylabel('North (km)');
title(['Sign of G_{' num2str(n) num2str(p) '} (P-wave)']);
colorbar;
caxis([-1 1]);
colormap([0 0 1; 1 1 1; 1 0 0]); % 蓝白红：负，零，正

% 绘制幅值分布
subplot(1,2,2);
imagesc(x, y, abs(Gnp));
axis xy; axis equal;
xlabel('East (km)');
ylabel('North (km)');
title(['Amplitude of G_{' num2str(n) num2str(p) '} (P-wave)']);
colorbar;
colormap(jet);

sgtitle(['Green function component G_{' num2str(n) num2str(p) '}']);



% 计算三分量能量分布（Gnp^2 和）
Gnp1 = gamma_x .* gamma_p./ (r_total.^2);  % n = 1
Gnp2 = gamma_y .* gamma_p./ (r_total.^2);  % n = 2
Gnp3 = gamma_z .* gamma_p./ (r_total.^2);  % n = 3

Energy = Gnp1.^2 + Gnp2.^2 + Gnp3.^2;

% 绘制总能量分布图
figure;
imagesc(x, y, Energy);
axis xy; axis equal;
xlabel('East (km)');
ylabel('North (km)');
title(['Total P-wave Energy for point force in direction ' num2str(p)]);
colorbar;
colormap(jet);



% 单位传播方向余弦
gamma = cat(3, gamma_x, gamma_y, gamma_z); % size: [Ny, Nx, 3]

% 初始化总能量
Energy_total = zeros(size(X));

% 遍历 n = 1:3, p = 1:3
for n = 1:3
    for p = 1:3
        Gnp = gamma(:,:,n) .* gamma(:,:,p)./ (r_total.^2);;
        Energy_total = Energy_total + Gnp.^2;
    end
end

% 绘图
figure;
imagesc(x, y, Energy_total);
axis xy; axis equal;
xlabel('East (km)');
ylabel('North (km)');
title('Total P-wave Energy (sum over all G_{np}^2)');
colorbar;
colormap(jet);


end
