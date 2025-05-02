function visualize_Green_wavefield_energy_snapshots(Gnt, x, y, z, tlist, t_play, x_plane_idx, y_plane_idx, z_plane_idx, climval)
% 可视化波场的能量 (三分量平方和)，在 XY、XZ、YZ 三个切面
% Gnt: [Ny, Nx, Nz, Nt, 3]
% t_play: 要显示的时间（秒）
% x/y/z_plane_idx: 要切的三个平面索引
% climval: caxis 上限（自动对称）

% 找时间索引
t_idx = find(tlist == t_play);
if isempty(t_idx)
    error('指定时间 t_play = %.2f 不在 tlist 中', t_play);
end

% 计算总能量（所有方向平方和）
G_energy = sum(Gnt(:,:,:,:,1).^2 + Gnt(:,:,:,:,2).^2 + Gnt(:,:,:,:,3).^2, 5);  % [y,x,z,t]

% 提取三张切面
G_xy = squeeze(G_energy(:,:,z_plane_idx,t_idx))';     % [x, y]
G_xz = squeeze(G_energy(:,y_plane_idx,:,t_idx))';     % [x, z]
G_yz = squeeze(G_energy(x_plane_idx,:,:,t_idx))';     % [y, z]

% 绘图（合成一张大图）
figure('Position', [100, 100, 1500, 500]);
tiledlayout(1,3, 'Padding', 'compact', 'TileSpacing', 'compact');

% XY
nexttile;
imagesc(x, y, (G_xy));
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Y (km)');
title(sprintf(' Energy (XY @ z = %.2f km)', z(z_plane_idx)));
caxis([-climval, climval]); colorbar; colormap(jet);

% XZ
nexttile;
imagesc(x, z, (G_xz));
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Z (km)');
title(' Energy (XZ @ y = 0)');
caxis([-climval, climval]); colorbar; colormap(jet);

% YZ
nexttile;
imagesc(y, z, (G_yz));
axis xy; axis equal tight;
xlabel('Y (km)'); ylabel('Z (km)');
title(' Energy (YZ @ x = 0)');
caxis([-climval, climval]); colorbar; colormap(jet);
end
