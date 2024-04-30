function [eta,N_H,N_L,c]=residence_times_temporal(obj,landscape,v_min)
%
L = landscape.L;
%period in unitless steps - from s to jumps
period = round(2*L/v_min/(obj.delta*obj.dt)); %landscape.L == gap
c = [];
for i = 1:period
    x_temp = obj.x(:,i:period:end);
    y_temp = obj.y(:,i:period:end);
    c_temp = landscape.processing(x_temp+v_min*(i-1)*obj.dt*obj.delta,y_temp);
    %outputs each case the values as array associated to each x/y coords [Np,Nt]
    c = [c, c_temp]; %stack along the particle axis
    clear c_temp x_temp y_temp
end

mask_H=c>=(landscape.ymin+landscape.ymax)/2;
mask_L=c<(landscape.ymin+landscape.ymax)/2;
c(mask_H)=0; %high Dr = tau_H - sin curve is positive = high Dr (environment) Also high v
c(mask_L)=1;  %regions of low Dr (see below, plus simulation) alsp low v
%if square wave value for particle position (all x) = -1 (from multi), set = 0
%c is a vector with rows as the particles, columns as dt*N (time elapsed)

Nt = numel(c(1,:)); %time span 

N_L = zeros(1,Nt);
% N_H = zeros(1,Nt);

for j=1:Nt %for loop over the time points, count up particles at each delta

    N_L(j) = sum(c(:,j)); %number of particles in low vel/DR regions 

end

N_H = numel(c(:,1)) - N_L;
eta=1-sum(N_L)/numel(c); %amount in high vel region

end




