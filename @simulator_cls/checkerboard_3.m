function checkerboard_3(L,xmin,xmax)
x = xmin:L:xmax;
y = xmin:L:xmax;
[x,y] = meshgrid(x,y);
% Checkerboard values
if mod(size(x,1),2)
    val = ones(size(x));
    val(1:2:end) = 2;
else
    val = ones(size(x,1)+1,size(x,2));
    val(1:2:end) = 2;
    val = val(1:end-1,:);
end
% Coordinates of a box, relative to lower left corner
xref = [-L/2 -L/2 L/2 L/2 0];
yref = [-L/2 L/2 L/2 -L/2 -L/2];
% Add to get coordinates of each box
xbox = bsxfun(@plus, x(:), xref);
ybox = bsxfun(@plus, y(:), yref);
% Plot using patch with RGB cdata
cmap = [0 0 0; 1 1 1];
col = permute(cmap(val(:), :), [3 1 2]);
h = patch(xbox', ybox', col);
h.FaceAlpha=0.2;
h.EdgeColor='none';
end



