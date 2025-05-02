function visualize_Green_wavefield_3planes(Gnt, x, y, z, tlist, t_play, obs_dir, climval)
% 可视化 Gnt(x,y,z,t,n) 在给定时间 t_play 的三张主切面图 (XY, XZ, YZ)
% Gnt: [Ny, Nx, Nz, Nt, 3]
% obs_dir: 观测方向 (n = 1, 2, 3)
% climval: 色标上下限（对称）

% 找时间帧索引
t_idx = find(tlist == t_play);
if isempty(t_idx)
    error('t_play = %.2f 不在 tlist 中', t_play);
end

% 找 z=0, y=0, x=0 索引
[~, z0_idx] = min(abs(z - 0));
[~, y0_idx] = min(abs(y - 0));
[~, x0_idx] = min(abs(x - 0));

% 提取三个切面
G_xy = squeeze(Gnt(:,:,z0_idx,t_idx,obs_dir))';     % [x, y]
G_xz = squeeze(Gnt(:,y0_idx,:,t_idx,obs_dir))';     % [x, z]
G_yz = squeeze(Gnt(x0_idx,:,:,t_idx,obs_dir))';     % [y, z]

% 绘图
figure('Position', [100, 100, 1500, 500]);
tiledlayout(1,3, 'Padding', 'compact', 'TileSpacing', 'compact');

% XY
nexttile;
imagesc(x, y, G_xy);
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Y (km)');
title(sprintf('XY plane (z = 0), t = %.2f s', tlist(t_idx)));
caxis([-climval, climval]); colorbar; colormap(seismic());

% XZ
nexttile;
imagesc(x, z, G_xz);
axis xy; axis equal tight;
xlabel('X (km)'); ylabel('Z (km)');
title('XZ plane (y = 0)');
caxis([-climval, climval]); colorbar; colormap(seismic());

% YZ
nexttile;
imagesc(y, z, G_yz);
axis xy; axis equal tight;
xlabel('Y (km)'); ylabel('Z (km)');
title('YZ plane (x = 0)');
caxis([-climval, climval]); colorbar; colormap(seismic());

end
