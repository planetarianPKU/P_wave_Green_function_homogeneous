function [G_vec, x, y, z, tlist] = compute_Green_tensor_time_weighted(source_xyz, grid_xyz, p_vec, tlist)
% 计算施加方向为 p_vec 的点力激发的动态 Green 函数波场
% 输出 G_vec(y,x,z,t,n): 每个观测方向 n 的动态波场

% 固定波速
v = 3;  % km/s

% 网格
x = grid_xyz{1}; y = grid_xyz{2}; z = grid_xyz{3};
[xs, ys, zs] = deal(source_xyz(1), source_xyz(2), source_xyz(3));
[X, Y, Z] = meshgrid(x, y, z);

% 距离和方向余弦
dx = X - xs;
dy = Y - ys;
dz = Z - zs;
r_total = sqrt(dx.^2 + dy.^2 + dz.^2);
r_total(r_total == 0) = 1e-6;

gamma = zeros([size(X), 3]);
gamma(:,:,:,1) = dx ./ r_total;
gamma(:,:,:,2) = dy ./ r_total;
gamma(:,:,:,3) = dz ./ r_total;

% 时间设置
Nt = length(tlist);
dt = tlist(2) - tlist(1);
t_arrival = r_total / v;

% 输出初始化
G_vec = zeros([size(X), Nt, 3]);  % [y,x,z,t,n]

% 构造每个方向 n 的波场分量
for n = 1:3
    Gsum = zeros(size(X));
    for p = 1:3
        Gnp = gamma(:,:,:,n) .* gamma(:,:,:,p);
        Gsum = Gsum + p_vec(p) * Gnp;
    end

    % 时间延迟赋值：Gsum --> G_vec(:,:,:,:,n)
    for i = 1:numel(X)
        ta = t_arrival(i);
        idx = round((ta - tlist(1)) / dt) + 1;
        if idx >= 1 && idx <= Nt
            [iy, ix, iz] = ind2sub(size(X), i);
            G_vec(iy, ix, iz, idx, n) = Gsum(iy, ix, iz);
        end
    end
end
end
