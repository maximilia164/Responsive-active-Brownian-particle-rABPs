function binned_pos = discretise_pos(Np,lengtht,Struct,discrete,skip,sample)

%initialise the arrays (good praxis)
x = zeros(Np,lengtht);
y = zeros(Np,lengtht);

%load the relevant data into the arrays initalised
x(:,:) = Struct.traj.x;
y(:,:) = Struct.traj.y;

%to remove unnecessary data at beginning
x = x(:,skip:end);
y = y(:,skip:end);

%to remove unnecessary data - sub-sample
x = x(:,1:sample:end);
y = y(:,1:sample:end);

length_new = size(x,2);

%defining box height
Lx = Struct.L_box(2); %need to flip because it goes from left to right etc?
Ly = Struct.L_box(1);
period = Struct.gap;

% make the x and y of all particles into single column (x2)
pxpy_all = zeros(numel(x),2);

for i = 1:Np %inefficient if more particles than steps
    
%     pxpy_all((1+(i-1)*lengtht):i*lengtht,1) = x(i,:);
%     pxpy_all((1+(i-1)*lengtht):i*lengtht,2) = y(i,:);
    pxpy_all((1+(i-1)*length_new):i*length_new,1) = x(i,:);
    pxpy_all((1+(i-1)*length_new):i*length_new,2) = y(i,:);
    
end

gridsz = period/discrete; %how much to divide each period into

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
