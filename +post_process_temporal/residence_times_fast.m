function [eta]=residence_times_fast(obj,landscape,v_min)

%THE OLD APPROACHES WILL NOT WORK AS THEY RELY ON DIFFERENCES BETWEEN
%PARTICLES SHIFTING FROM REGIONS

period = round(2*landscape.L/v_min); %landscape.L == gap

c = [];

%wrong counting - look at the data structures formats
for i = 1:period
    x_temp = obj.x(:,i:period:end);
    y_temp = obj.y(:,i:period:end);
    c_temp = landscape.processing(x_temp+v_min*(i-1)*obj.dt,y_temp);
    %outputs each case the values as array associated to each x/y coords [Np,Nt]
    c = [c, c_temp]; %stack along the particle axis
    clear c_temp x_temp y_temp
end

% c=landscape.processing(obj.x,obj.y); %value of c(i) is +/- 1 based on position of x in chessboard
mask_H=c>=(landscape.ymin+landscape.ymax)/2;
mask_L=c<(landscape.ymin+landscape.ymax)/2;
c(mask_H)=0; %high Dr = tau_H - sin curve is positive = high Dr (environment) Also high v
c(mask_L)=1;  %regions of low Dr (see below, plus simulation) alsp low v
% %if square wave value for particle position (all x) = -1 (from multi), set = 0
% %c is a vector with rows as the particles, columns as dt*N (time elapsed)
% 
% tau_H=[];
% tau_L=[];
% for i=1:length(c(:,1)) %%%!!! issue because particle approach is
% different and subsampling
%     d = [true, diff(c(i,:)) ~= 0, true];  % TRUE if values change
%     n = diff(find(d));               % Number of repetitions
%     values=c(i,d(1:end-1));    
%     tau_H=[tau_H n(values==0)];
%     tau_L=[tau_L n(values==1)];
% end

% funza=@(x)(1-sum(x)/numel(c))./(sum(x)/numel(c));

eta=c;%1-sum(tau_L)/numel(c); %eta calculated before rescaling with time
%eta = sum(tau_H)/numel(c);? running through numbers?
%eta_ci=bootci(1e2,{funza,tau_L});

% tau_H=tau_H.*obj.dt*obj.delta; %contribution scaled by time (50*dt effective contribution of position)
% tau_L=tau_L.*obj.dt*obj.delta;
%tau_H and tau_L will likely be of different lengths since each element is
%per a while loop
end


%code to use 
% function [eta,tau_H,tau_L]=residence_times_fast(obj,landscape,v_min)
% 
% period = round(2*landscape.L/v_min); %landscape.L == gap
% 
% c = [];
% 
% %wrong counting - look at the data structures formats
% for i = 1:period
%     x_temp = obj.x(:,i:period:end);
%     y_temp = obj.y(:,i:period:end);
%     c_temp = landscape.processing(x_temp+v_min*(i-1)*obj.dt,y_temp);
%     %outputs each case the values as array associated to each x/y coords [Np,Nt]
%     c = [c, c_temp]; %stack along the particle axis
%     clear c_temp x_temp y_temp
% end
% 
% % c=landscape.processing(obj.x,obj.y); %value of c(i) is +/- 1 based on position of x in chessboard
% mask_H=c>=(landscape.ymin+landscape.ymax)/2;
% mask_L=c<(landscape.ymin+landscape.ymax)/2;
% c(mask_H)=0; %high Dr = tau_H - sin curve is positive = high Dr (environment) Also high v
% c(mask_L)=1;  %regions of low Dr (see below, plus simulation) alsp low v
% %if square wave value for particle position (all x) = -1 (from multi), set = 0
% %c is a vector with rows as the particles, columns as dt*N (time elapsed)
% 
% tau_H=[];
% tau_L=[];
% for i=1:length(c(:,1))
%     d = [true, diff(c(i,:)) ~= 0, true];  % TRUE if values change
%     n = diff(find(d));               % Number of repetitions
%     values=c(i,d(1:end-1));    
%     tau_H=[tau_H n(values==0)];
%     tau_L=[tau_L n(values==1)];
% end
% 
% % funza=@(x)(1-sum(x)/numel(c))./(sum(x)/numel(c));
% 
% 
% eta=1-sum(tau_L)/numel(c); %eta calculated before rescaling with time
% %eta = sum(tau_H)/numel(c);? running through numbers?
% %eta_ci=bootci(1e2,{funza,tau_L});
% 
% tau_H=tau_H.*obj.dt*obj.delta; %contribution scaled by time (50*dt effective contribution of position)
% tau_L=tau_L.*obj.dt*obj.delta;
% %tau_H and tau_L will likely be of different lengths since each element is
% %per a while loop
% end
% 
% 
% 
% 
% 
% 
% 
