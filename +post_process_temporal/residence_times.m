function [eta,tau_H,tau_L]=residence_times(obj,landscape)

%THE OLD APPROACHES WILL NOT WORK AS THEY RELY ON DIFFERENCES BETWEEN
%PARTICLES SHIFTING FROM REGIONS

c=landscape.processing(obj.x,obj.y); %value of c(i) is +/- 1 based on position of x in chessboard
mask_H=c>=(landscape.ymin+landscape.ymax)/2;
mask_L=c<(landscape.ymin+landscape.ymax)/2;
c(mask_H)=0; %high Dr = tau_H - sin curve is positive = high Dr (environment) Also high v
c(mask_L)=1;  %regions of low Dr (see below, plus simulation) alsp low v
%if square wave value for particle position (all x) = -1 (from multi), set = 0
%c is a vector with rows as the particles, columns as dt*N (time elapsed)


tau_H=[];
tau_L=[];

for j=1:numel(c(:,1)) %for loop over the particles/Rows of c - goes particle by particle
    idx=1;
    while idx<length(c(1,:)) %number columms = number of steps (rows are particles)
        scatola=0;%~logical means inverse - all non zeros converted to 0, zeros to 1
        while ~logical(c(j,idx)) && idx<length(c(1,:)) %i.e. while zero values in given row, and idx is not complete particle number
            scatola=scatola+1; %+1 for each entry in column has c = 0
            idx=idx+1; %basically counts all the zeros in each column i
        end
        if logical(c(j,idx)) %logical indexing - non zero values are 1, zero values are 0 
            idx=idx+1;       %skip the column if c value is 1
        end
        if scatola>0
            tau_H=[tau_H scatola]; %c = -1/0 terms count to the tau_H residence time final?
        end %then updates back to the initial while loop to keep scanning through for the given particle
    end
    
    
    idx=1;
    while idx<length(c(1,:))
        scatola=0;
        while logical(c(j,idx)) && idx<length(c(1,:))
            scatola=scatola+1; %add to tau L for each c entry of particle that = 1
            idx=idx+1;
        end
        if ~logical(c(j,idx))
            idx=idx+1;
        end
        if scatola>0
            tau_L=[tau_L scatola];
        end
    end
    
end
funza=@(x)1-sum(x)/numel(c);


eta=1-sum(tau_L)/numel(c); %eta calculated before rescaling with time
%eta = sum(tau_H)/numel(c);? running through numbers?
%eta_ci=bootci(1e1,{funza,tau_L});

tau_H=tau_H.*obj.dt*obj.delta; %contribution scaled by time (50*dt effective contribution of position)
tau_L=tau_L.*obj.dt*obj.delta;
%tau_H and tau_L will likely be of different lengths since each element is
%per a while loop
end




