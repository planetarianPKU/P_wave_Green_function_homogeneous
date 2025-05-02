function visualize_Green_wavefield_xy_snapshots(Gnt, x, y, z, tlist,t_play, obs_dir, z_plane_idx, climval)
% 可视化 Green 函数波场在某个 z=const 平面上的随时间演化
% Gnt: [Ny, Nx, Nz, Nt, 3]
% obs_dir: 观测方向 n = 1, 2, 3 (X/Y/Z)
% z_plane_idx: z 索引位置（例如 z=0）
% climval: 色标范围上下限（例如 1e-5）

Nt = length(tlist);
[Xgrid, Ygrid] = meshgrid(x, y);

figure('Position', [100, 100, 600, 550]);
t=find(tlist==t_play);    
    % 提取当前时间帧的波场切片（XY 平面）
    G_slice = squeeze(Gnt(:,:,z_plane_idx,t,obs_dir))';

    imagesc(x, y, G_slice);
    axis xy; axis equal;
    xlabel('X (km)'); ylabel('Y (km)');
    title(sprintf('Time = %.2f s, Dir = %d', tlist(t), obs_dir));
    %colormap(seismic());  % 红蓝色标，需自定义或用默认
    caxis([-climval, climval]);
    colorbar;


end
