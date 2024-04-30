function S=msd_disp_alpha(obj)
x=obj.x;
y=obj.y;

tmax=1000;
npoints=600; %number of points on logspace

Nmax=tmax/obj.dt; %based on parfor loop - finds the max t/number of points

%Nmax=round(obj.N/2);

steps=unique(round(logspace(log10(1),log10(Nmax/obj.delta),npoints))); %rounded log space, unique values (no duplicates)
%unique needed since rounding the log will create multiple duplicate
%integer values
%logspace between 0 and 10^log(Nmax/delta) (= number x points)
MSD=zeros(numel(steps),1,'single'); %number of MSDs to be calculated - one for each step

vanHove=cell(numel(steps),2); %steps*2 (columns) cell array
S.nngausspxy=zeros(numel(steps,1));

for i=1:numel(steps) %for loop over lag time
    dispX=(x(:,steps(i)+1:end)-x(:,1:end-steps(i))); %finds displacement for increasing step/lag time
    dispY=(y(:,steps(i)+1:end)-y(:,1:end-steps(i)));
    
    bot2=reshape(dispX.^2+dispY.^2,[1,length(dispX(1,:))*length(dispX(:,1))]);
    %reshapes matrix of dispx of all particles into row length = (N_steps)*Np
    bot1=reshape([dispX;dispY],[1,2*length(dispX(1,:))*length(dispX(:,1))]);
    %reshapes vertically concatenated matrices into row vector - for
    %histogram binning
    
    MSD(i)=mean(bot2); 
    
    [psdx,binsx]=histcounts(bot1,'Normalization','pdf');
  
    binsx=(binsx(2:end)+binsx(1:end-1))/2; %counts excluding the edges
    
    S.nngausspxy(i)=(mean(bot1.^4)/(mean(bot1.^2)^2)-3);
    %non gaussian parameter
    vanHove{i,1}=binsx;
    vanHove{i,2}=psdx;  
end

S.t=steps*obj.dt*obj.delta;
S.MSD=MSD;
S.vanHove=vanHove;
end