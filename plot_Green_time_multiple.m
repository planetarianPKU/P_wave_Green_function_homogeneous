%dynamic

[x, y, z] = deal(linspace(-20,20,200), linspace(-20,20,200), linspace(-10,10,30));
tlist = 0:0.1:10;
%%
% 准备动态 Green 函数波场
[G1, x, y, z, tlist] = compute_Green_tensor_time_weighted([-10,0,0], {x,y,z}, [0,0,1], tlist);
[G2, ~, ~, ~, ~] = compute_Green_tensor_time_weighted([10,0,0], {x,y,z}, [0,0,1], tlist);

% 可视化动态能量叠加传播
plot_dynamic_energy_from_multiple_G({G1, G2}, x, y, z, tlist, 0);
