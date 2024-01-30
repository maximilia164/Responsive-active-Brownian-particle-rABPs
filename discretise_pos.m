function binned_pos = discretise_pos(Np,lengtht,Struct,discrete)

%function to bin localisation heat maps based on number particles Np,
%number steps lengtht, the structure, and the discretisation step discrete

%initialise the arrays (good praxis)
x = zeros(Np,lengtht);
y = zeros(Np,lengtht);

%load the relevant data into the arrays initalised
x(:,:) = Struct.traj.x;
y(:,:) = Struct.traj.y;

Lx = Struct.L_box(2); %need to flip because it goes from left to right etc?
Ly = Struct.L_box(1);
period = Struct.gap;

% make the x and y of all particles into single column (x2)
pxpy_all = zeros(numel(x),2);

for i = 1:Np %inefficient if more particles than steps
    
    pxpy_all((1+(i-1)*lengtht):i*lengtht,1) = x(i,:);
    pxpy_all((1+(i-1)*lengtht):i*lengtht,2) = y(i,:);
    
    
end

gridsz = period/discrete;

meshx = -Lx:gridsz:Lx;
meshy = -Ly:gridsz:Ly;

[X,Y] = meshgrid(meshx,meshy);
binned_pos = zeros(size(X)); 

%scan across binned positions one by one after flattening as vec
for i = 1:length(binned_pos(:))
    binned_pos(i) = sum(pxpy_all(:,1)>=X(i) & pxpy_all(:,1)<X(i)+gridsz ...
                    & pxpy_all(:,2)>=Y(i) & pxpy_all(:,2)<Y(i)+gridsz);
end



end
