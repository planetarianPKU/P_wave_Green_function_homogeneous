function plot_dynamic_energy_from_multiple_G(G_list, x, y, z, tlist, slice_depth)
% G_list: cell array of G_vec(y,x,z,t,n), 每个震源的三分量动态波场
% tlist: 时间轴向量
% source_depth: 用于选取 z 切面

Nt = length(tlist);
[Ny, Nx, Nz, ~, ~] = size(G_list{1});
Energy = zeros(Ny, Nx, Nz, Nt);  % [y,x,z,t]

% 累加所有源波场
for i = 1:length(G_list)
    G = G_list{i};
    for n = 1:3
        Energy = Energy + G(:,:,:,:,n).^2;
    end
end

% 提取切片索引
[~, z_src_idx] = min(abs(z - slice_depth));
[~, y0_idx] = min(abs(y));
[~, x0_idx] = min(abs(x));

% 可视化动态帧
figure('Position', [100, 100, 1500, 500]);
tiledlayout(1,3, 'Padding', 'compact', 'TileSpacing', 'compact');

for t = 1:Nt
    Energy_xy = squeeze(Energy(:,:,z_src_idx,t))';
    Energy_xz = squeeze(Energy(:,y0_idx,:,t))';
    Energy_yz = squeeze(Energy(x0_idx,:,:,t))';

    nexttile(1);
    imagesc(x, y, log10(Energy_xy));
    axis xy; axis equal tight;
    xlabel('X (km)'); ylabel('Y (km)');
    title(sprintf('XY @ z=%.1f km, t=%.2fs', z(z_src_idx), tlist(t)));
    colormap(jet); colorbar;

    nexttile(2);
    imagesc(x, z, log10(Energy_xz));
    axis xy; axis equal tight;
    xlabel('X (km)'); ylabel('Z (km)');
    title('XZ @ y = 0');
    colormap(jet); colorbar;

    nexttile(3);
    imagesc(y, z, log10(Energy_yz));
    axis xy; axis equal tight;
    xlabel('Y (km)'); ylabel('Z (km)');
    title('YZ @ x = 0');
    colormap(jet); colorbar;

    drawnow;
    pause(0.05);  % 控制播放速度
end
end
