function [max_loc, azimuth_deg, takeoff_deg] = visualize_Green_wavefield_energy_snapshots(Gnt, x, y, z, tlist, t_play, climval)
% 可视化能量快照 + 最大值方向箭头
% 输出：
%   max_loc = [x_max, y_max, z_max]
%   azimuth_deg: 相对原点的方位角 (北为0°，顺时针)
%   takeoff_deg: 起飞角 (0=向下)

% --- 时间索引 ---
t_idx = find(tlist == t_play);
if isempty(t_idx)
    error('时间 %.2f 不在 tlist 中', t_play);
end

% --- 计算三分量能量和 ---
G_energy = sum(Gnt(:,:,:,:,1).^2 + Gnt(:,:,:,:,2).^2 + Gnt(:,:,:,:,3).^2, 5);  % [y,x,z,t]

% --- 最大值索引与坐标 ---
[G_max, linear_idx] = max(G_energy(:,:,:,t_idx), [], 'all', 'linear');
[yi_max, xi_max, zi_max] = ind2sub(size(G_energy(:,:,:,t_idx)), linear_idx);
x_max = x(xi_max); y_max = y(yi_max); z_max = z(zi_max);
max_loc = [x_max, y_max, z_max];

% --- 计算方位角与起飞角 ---
[azimuth_deg, takeoff_deg] = compute_azimuth_takeoff(x_max, y_max, z_max);

% --- 提取剖面 ---
G_xy = squeeze(G_energy(:,:,zi_max,t_idx))';     % [x, y]
G_xz = squeeze(G_energy(:,yi_max,:,t_idx))';     % [x, z]
G_yz = squeeze(G_energy(xi_max,:,:,t_idx))';     % [y, z]

% --- 可视化 ---
figure('Position', [100, 100, 1500, 500]);
tiledlayout(1,3, 'Padding', 'compact', 'TileSpacing', 'compact');

% --- XY ---
nexttile;
imagesc(x, y, G_xy);
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Y (km)');
title(sprintf('Energy (XY @ z = %.2f km)', z_max));
caxis([-climval, climval]); colorbar; colormap(jet);
hold on;
quiver(0, 0, x_max, y_max, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
plot(x_max, y_max, 'rx', 'MarkerSize', 10, 'LineWidth', 2);

% --- XZ ---
nexttile;
imagesc(x, z, G_xz);
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Z (km)');
title(sprintf('Energy (XZ @ y = %.2f km)', y_max));
caxis([-climval, climval]); colorbar; colormap(jet);
hold on;
quiver(0, 0, x_max, z_max, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
plot(x_max, z_max, 'rx', 'MarkerSize', 10, 'LineWidth', 2);

% --- YZ ---
nexttile;
imagesc(y, z, G_yz);
axis xy; axis equal tight;
xlabel('Y (km)'); ylabel('Z (km)');
title(sprintf('Energy (YZ @ x = %.2f km)', x_max));
caxis([-climval, climval]); colorbar; colormap(jet);
hold on;
quiver(0, 0, y_max, z_max, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
plot(y_max, z_max, 'rx', 'MarkerSize', 10, 'LineWidth', 2);

% --- 输出信息 ---
fprintf('Max energy at (x=%.2f km, y=%.2f km, z=%.2f km)\n', x_max, y_max, z_max);
fprintf('Azimuth: %.2f°, Take-off angle: %.2f°\n', azimuth_deg, takeoff_deg);

function [azimuth_deg, takeoff_deg] = compute_azimuth_takeoff(x, y, z)
% 从原点指向 (x,y,z) 的方位角（以北为0°，顺时针）和起飞角（与垂直方向夹角）

azimuth_deg = mod(atan2(x, y) * 180/pi, 360);
r = sqrt(x^2 + y^2 + z^2);
takeoff_deg = acos(-z / r) * 180/pi;
end


end
