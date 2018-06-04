% Gornji levi
d3 = zeros(6, 6, 2);
d3(1, :, :) = [[54.0, 53.0],
               [54.0, 53.0],
               [55.0, 53.0],
               [56.0, 53.0],
               [56.0, 55.0],
               [57.0, 54.0]];
d3(2, :, :) = [[53.0, 56.0],
               [54.0, 56.0],
               [55.0, 56.0],
               [55.0, 56.0],
               [57.0, 56.0],
               [58.0, 55.0]];
d3(3, :, :) = [[52.0, 58.0],
               [55.0, 56.0],
               [55.0, 57.0],
               [55.0, 57.0],
               [56.0, 57.0],
               [56.0, 57.0]];
d3(4, :, :) = [[52.0, 58.0],
               [54.0, 57.0],
               [55.0, 57.0],
               [56.0, 57.0],
               [57.0, 57.0],
               [56.0, 58.0]];
d3(5, :, :) = [[52.0, 59.0],
               [54.0, 58.0],
               [54.0, 59.0],
               [56.0, 58.0],
               [56.0, 58.0],
               [57.0, 58.0]];
d3(6, :, :) = [[52.0, 59.0],
               [55.0, 58.0],
               [56.0, 58.0],
               [55.0, 59.0],
               [56.0, 59.0],
               [56.0, 59.0]];
z3 = zeros(6, 6);
for i = 1:6
  for j = 1:6
    z3(i, j) = abs(sqrt(d3(i, j, 1)^2 + d3(i, j, 2)^2) - sqrt((50 - (i-1) * (2.5 / 6))^2 + (50 - (j-1) * (2.5 / 6))^2));
  endfor
endfor
imagesc(z3);
colormap hot;
colorbar;