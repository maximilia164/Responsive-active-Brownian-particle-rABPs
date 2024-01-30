%% 
clear all; close all; clc
pp=what('FILEPATH_CONTAINING_DIRECTORY');
%pp=what('DR_localisation_sin_ODE');

% listing=dir([pp(2).path '/*.mat']); %2 added for sin ode 
listing=dir([pp.path '/*.mat']);
L_v_tau=zeros(numel(listing),3); %makes 3 columns of zeros corresponding to number of sim results

fraction=zeros(numel(listing),1); %fraction - 1 column
tau_H = zeros(numel(listing),1);
tau_L = zeros(numel(listing),1);
tau_H_d = {};
tau_L_d = {};
%%
for j=1:numel(listing) %for loop through all the sims
    load(listing(j).name); %.name is column of listing structure - each row (iterated) is one sim
    L_v_tau(j,1)=S.gap;
    L_v_tau(j,2)=S.v0;
    L_v_tau(j,3)=S.tau;
%     fraction(j,:)=S.eta_Dr;
%     tau_H(j,:) = sum(S.tau_H_Dr);
%     tau_L(j,:) = sum(S.tau_L_Dr);
    fraction(j,:)=S.eta_v0;
    tau_H(j,:) = sum(S.tau_H_v0);
    tau_L(j,:) = sum(S.tau_L_v0);

%     tau_H_d{j} = S.tau_H;
%     tau_L_d{j} = S.tau_L;
     
end %for loop - L_v_tau contains all data lvtau, fraction contains eta
L=sort(unique(L_v_tau(:,1)));
v=sort(unique(L_v_tau(:,2))); %obtain unique L, V values

%%

L_v=L_v_tau(:,1)./L_v_tau(:,2); %element wise division - get L/v ratio
[sorted_L_v,I] = sort(L_v); %sorted - I is index vectors of original L_v corresponding to sorted


u_L_v=unique(sorted_L_v); 
% sorted_frac = fraction(I);
vet=u_L_v(1:end); %unique L_V values (L/V)

%%w
options = optimset('TolX',1e-6);
xx = logspace(-2,4,2000); %logspace(-2,2,1000);
optimal_tau = zeros(2,numel(vet));
max_eta = zeros(2,numel(vet));


%%
H = figure()

% colors=cmocean('thermal',21); %so can scale in values of 5 - 
colors=cmocean('dense',101); %so can scale in values of 1 - 
% set_vals = [1,3,11,13,15,16,21]; [1,10,50,75,100];%  
set_vals = [1,3,5,10,15,20,25,30,40,50,60,75,100];
set_vals_flip = flip([1,3,5,10,15,20,25,30,40,50,60,75,100]);   
% set_vals = [10,25,50];    
% for i=flip([1,2,3,4,5,6,7,8,9,10,12,15,20],2)
% for i=numel(vet):-1:1 %inverse direction
for i=numel(vet):-1:1%1:numel(vet)
    val = set_vals(i);
%     val_c = set_vals(-i):
    val_c = set_vals_flip(i);
    colour = colors(val_c,:);
    
    %sort tau values for a given L/v ratio (Extract out)
    [x,id]=sort(L_v_tau(L_v==vet(i),3)); %x is the tau values
    
    y=fraction(L_v==vet(i))*100; %eta values* 100
    %sort the y_vals by tau as above
    y_id= 100 - y(id); %makes it into localisation in the low velocity regions
    y_nom = y_id./(100-y_id);

    test = ['L/v = ' num2str(vet(i))];

    f = fit(log10(x), y_id, 'smoothingspline','SmoothingParam',0.97);
    [xmin,ymax] = fminbnd(@(sort_xnorm) -f(sort_xnorm),log10(0.01),log10(100),options); %finds min between bounds, min of -f is max
    
    index = find(f(log10(xx))==max(f(log10(xx))));
    optimal_tau(1,i) = vet(i);
    optimal_tau(2,i) = xx(index);
    
    
    max_eta(1,i) = vet(i);
    max_eta(2,i) = f(log10(xx(index)));
%     semilogx(xx,f(log10(xx))/-ymax,'DisplayName',test);
    semilogx(xx,f(log10(xx)),'Color',colour,'linewidth',2.5);
    hold on
%     semilogx(x,y_id,'.','Color',colour,'markersize',20)

end

xlim([1e-2,1e+4])

colormap(flip(colors));
cb = colorbar;
% cb.Direction = 'reverse';
% cb.Ticks = [1,25,50,75,100];%linspace(1, 101,5) ; %Create 8 ticks from zero to 1
% cb.TickLabels = num2cell(1:8);

title(cb,'L/$\langle$v$\rangle$','interpreter','latex','fontsize',20)
cb.Label.Interpreter = 'latex';
cb.TickLabelInterpreter = 'latex';
cb.FontSize = 16;


caxis([ 0 101]);

ax = gca;
ax.FontSize = 16; 
xlabel("$\tau$",'Interpreter','Latex', 'FontSize',24)
ylabel('$\eta$','Interpreter','Latex', 'FontSize',24)
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex'; 
pbaspect([1 1 1])
% cb.Direction = 'reverse';

ylim([45 85])
% exportgraphics(H,'Localisation_v0.pdf','BackgroundColor','none','ContentType','vector')



%% Plotting the optimal tau for localisation vs L/v

J = figure()
ax = gca;
ax.FontSize = 16; 
yyaxis left
plot(optimal_tau(1,:), optimal_tau(2,:), "k.",'markersize',20)
ylabel("$\tau_{\eta~=~\mathrm{argmax}(\eta)}$ (s)", 'Fontsize',24,'Interpreter','latex')
ylim([-1, 27])

yyaxis right
plot(max_eta(1,:), max_eta(2,:), "r.",'markersize',20)%,'markerfacecolor','r')
% ylabel('$\eta$','Interpreter','Latex', 'FontSize',24)
ylabel("$\mathrm{argmax}(\eta(\tau))$ (\%)", 'Fontsize',24,'Interpreter','latex')
% ylabel("$\tau_{\gamma~=~\mathrm{argmax}(\gamma)}$ (s)", 'Fontsize',44,'Interpreter','latex')
% title("Optimal tau for localisation with L/v")
% 
% ax = gca;
% ax.FontSize = 16; 
xlabel("$L/v$",'Interpreter','Latex', 'FontSize',24)

xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis

ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'r';
ax.YAxis(1).TickLabelInterpreter = 'latex'; 
ax.YAxis(2).TickLabelInterpreter = 'latex'; 
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
xlim([-1,102])

ylim([60,90])
% yaxisproperties= get(gca, 'YAxis');
% yaxisproperties.TickLabelInterpreter = 'latex'; 

pbaspect([1 1 1])
% exportgraphics(J,'Trend_Localisation_tau.pdf','BackgroundColor','none','ContentType','vector')
%%

LV_x = optimal_tau(1,:);
tau_y = optimal_tau(2,:);

