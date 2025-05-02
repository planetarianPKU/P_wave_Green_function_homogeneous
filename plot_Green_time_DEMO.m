clear

[x, y, z] = deal(linspace(-20,20,400), linspace(-20,20,400), linspace(-10,10,60));
tlist = 0:0.1:5;
source_xyz = [0, 0, 0];
p_vec = [0, 0, 1];  % 点力方向 X 1 Y 2 Z 3

[G_vec, x, y, z, tlist] = compute_Green_tensor_time_weighted(source_xyz, {x, y, z}, p_vec, tlist);
%%
[~, z0_idx] = min(abs(z - 0));  % z=0 平面
n = 1;  % 观测方向 Z
t_play=5;
visualize_Green_wavefield_xy_snapshots(G_vec(:,:,:,:,:), x, y, z, tlist, t_play,n,z0_idx, 1e-5);
%%
[~, z0_idx] = min(abs(z - 0));  % z=0 平面
[~, x0_idx] = min(abs(x - 0));  % z=0 平面
[~, y0_idx] = min(abs(y - 0));  % z=0 平面

n = 1;  % 观测方向 Z
t_play=2;
visualize_Green_wavefield_xyz_snapshots(G_vec(:,:,:,:,:), x, y, z, tlist, t_play,n,x0_idx,y0_idx,z0_idx, 0.5);
%%
% 选择平面索引
[~, z0_idx] = min(abs(z));
[~, y0_idx] = min(abs(y));
[~, x0_idx] = min(abs(x));

% 可视化某个时刻的能量切片图
visualize_Green_wavefield_energy_snapshots(G_vec, x, y, z, tlist, 5.0, x0_idx, y0_idx, z0_idx, 1);
%%


%%
[maxloc, az, to] = visualize_Green_wavefield_energy_snapshots_maxpos(G_vec, x, y, z, tlist, 1.0, 1);



%%


visualize_Green_wavefield_xy(G_vec(:,:,:,:,:), x, y, z, tlist, n,z0_idx, 1e-5);

%%



