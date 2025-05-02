function plot_Gnp_Pwave_with_comb(n, p, p_vec)
% plot_Gnp_Pwave_with_comb(n, p, a_vec)
% 可视化指定 G_np 分量的正负、幅值、总能量图
% 并展示自定义组合（a1, a2, a3）加权叠加的波场
%
% 输入：
%   n     - 观测方向（1=X, 2=Y, 3=Z）用于 sign 和 amp 图
%   p     - 点力方向（1=X, 2=Y, 3=Z）
%   a_vec - 三分量的组合权重 [a1, a2, a3]，对应 X/Y/Z 方向的强度与极性

% 网格设置
x = linspace(-50,50,1000); % 东西方向 (km)
y = linspace(-50,50,1000); % 南北方向 (km)
[X, Y] = meshgrid(x, y);

z_source = 0; % 震源深度 (km)
Z = zeros(size(X)); % 地表 z=0 km

% 震源位置
xs = 0; ys = 0; zs = z_source;

% 传播向量和单位方向
r_total = sqrt((X - xs).^2 + (Y - ys).^2 + (Z - zs).^2);
r_total(r_total == 0) = 1e-6;  % 避免除零
gamma_x = (X - xs) ./ r_total;
gamma_y = (Y - ys) ./ r_total;
gamma_z = (Z - zs) ./ r_total;
gamma = cat(3, gamma_x, gamma_y, gamma_z);

% 选取观测方向 gamma_n
switch n
    case 1, gamma_n = gamma_x;
    case 2, gamma_n = gamma_y;
    case 3, gamma_n = gamma_z;
    otherwise, error('n must be 1, 2, or 3');
end

% 选取点力方向 gamma_p
switch p
    case 1, gamma_p = gamma_x;
    case 2, gamma_p = gamma_y;
    case 3, gamma_p = gamma_z;
    otherwise, error('p must be 1, 2, or 3');
end

% ===== 三分量能量图（固定 p）=====
G1 = gamma_x .* gamma_p;
G2 = gamma_y .* gamma_p;
G3 = gamma_z .* gamma_p;

Energy_p = G1.^2 + G2.^2 + G3.^2;

figure;
imagesc(x, y, Energy_p);
axis xy; axis equal;
xlabel('East (km)'); ylabel('North (km)');
title(['Total P-wave Energy for point force in direction ' num2str(p)]);
colorbar; colormap(jet);

% ===== 全方向能量 G_np 所有 n,p =====
Energy_weighted = zeros(size(X));
for n1 = 1:3
    G_custom = zeros(size(X));  % 每个 p1 下自定义组合 G
    for p1 = 1:3
        Gnp_tmp = gamma(:,:,n1) .* gamma(:,:,p1);
         G_custom = G_custom + p_vec(n1) * Gnp_tmp;
        
    end
     Energy_weighted = Energy_weighted + G_custom.^2;
end

% 绘图
figure;
imagesc(x, y, Energy_weighted);
axis xy; axis equal;
xlabel('East (km)'); ylabel('North (km)');
title(['Weighted Total Energy (a = [' num2str(p_vec) '])']);
colorbar; colormap(jet);

% ===== 自定义组合 Gnp = a1*G_{1p} + a2*G_{2p} + a3*G_{3p} =====
G1 = gamma(:,:,1) .* gamma_p;
G2 = gamma(:,:,2) .* gamma_p;
G3 = gamma(:,:,3) .* gamma_p;

G_custom = p_vec(1)*G1 + p_vec(2)*G2 + p_vec(3)*G3;

figure;
subplot(1,3,1);
imagesc(x, y, sign(G_custom));
axis xy; axis equal;
xlabel('East (km)'); ylabel('North (km)');
title('Sign of Custom G_{np}');
colorbar; caxis([-1 1]);
colormap([0 0 1; 1 1 1; 1 0 0]);

subplot(1,3,2);
imagesc(x, y, abs(G_custom));
axis xy; axis equal;
xlabel('East (km)'); ylabel('North (km)');
title('Amplitude of Custom G_{np}');
colorbar; colormap(jet);

subplot(1,3,3);
imagesc(x, y, G_custom.^2);
axis xy; axis equal;
xlabel('East (km)'); ylabel('North (km)');
title('Energy of Custom G_{np}');
colorbar; colormap(jet);

sgtitle(['Custom Combined G_{np}, p = ' num2str(p) ', weights = [' num2str(p_vec) ']']);






% ===== 设置空间网格（加 z 方向）=====
x = linspace(-50, 50, 200);
y = linspace(-50, 50, 200);
z = linspace(-20, 20, 200);  % z 向上下延展
[X, Y, Z] = meshgrid(x, y, z);

xs = 0; ys = 0; zs = -3;

r_total = sqrt((X - xs).^2 + (Y - ys).^2 + (Z - zs).^2);
r_total(r_total == 0) = 1e-6;

gamma_x = (X - xs) ./ r_total;
gamma_y = (Y - ys) ./ r_total;
gamma_z = (Z - zs) ./ r_total;
gamma = cat(4, gamma_x, gamma_y, gamma_z);  % [Ny, Nx, Nz, 3]

% ===== Energy_weighted 计算（p_vec 加权） =====
Energy_weighted = zeros(size(X));
for n1 = 1:3
    G_custom = zeros(size(X));
    for p1 = 1:3
        Gnp_tmp = gamma(:,:,:,n1) .* gamma(:,:,:,p1);  % G_{np}
        G_custom = G_custom + p_vec(p1) * Gnp_tmp;
    end
    Energy_weighted = Energy_weighted + G_custom.^2;
end

% ===== 提取 xz 平面（固定 y=0）和 yz 平面（固定 x=0） =====
% ===== 找切面索引 =====
[~, z_src_idx] = min(abs(z - zs));   % z = zs（震源深度）处
[~, y0_idx]    = min(abs(y));        % y = 0
[~, x0_idx]    = min(abs(x));        % x = 0

% ===== 提取三个切面 =====
Energy_xy = squeeze(Energy_weighted(:, :, z_src_idx))';  % [x, y] 面
Energy_xz = squeeze(Energy_weighted(:, y0_idx, :))';     % [x, z] 面
Energy_yz = squeeze(Energy_weighted(x0_idx, :, :))';     % [y, z] 面

% ===== 三个切面统一画图 =====
% 创建更合理的图布局
figure('Position', [100, 100, 1400, 500]);  % 宽大窗口

tiledlayout(1,3, 'Padding', 'compact', 'TileSpacing', 'compact');

% XY 切片
nexttile;
imagesc(x, y, (Energy_xy));
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Y (km)');
title(' Energy (XY plane @ Z = source depth)');
colorbar; colormap(jet);

% XZ 切片
nexttile;
imagesc(x, z, (Energy_xz));
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Z (km)');
title(' Energy (XZ plane @ Y = 0)');
colorbar; colormap(jet);

% YZ 切片
nexttile;
imagesc(y, z, (Energy_yz));
axis xy; axis equal tight;
xlabel('Y (km)'); ylabel('Z (km)');
title(' Energy (YZ plane @ X = 0)');
colorbar; colormap(jet);





end
