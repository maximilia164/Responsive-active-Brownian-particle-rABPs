% script to extract out the positions as heat map - calls discrete pos
% Can use the format provided here to make own heatmaps

Np = 1000;
% lengtht = 10001;
lengtht = 100001;
discrete = 20;


%normalise wrt to the equilibrium with tau = 0 (instant update), L/v = 10
% load('FILEPATH_LOCALISATION_XY')
tic
norm = discretise_pos(Np,lengtht,S,discrete);
max_vals(1) = max(norm(:));
toc
% 
% %tau = 0.03, L/v = 10
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000_tau_0.03_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster15_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_100000000_tau_0.03_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster14_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000000_tau_0.03_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% tic
% tau_003 = discretise_pos(Np,lengtht,S,discrete);
% max_vals(2) = max(tau_003(:));
% toc
% 
% %tau = 0.3, L/v = 10
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000_tau_0.3_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster15_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_100000000_tau_0.3_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster14_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000000_tau_0.3_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% tic
% tau_03 = discretise_pos(Np,lengtht,S,discrete);
% max_vals(3) = max(tau_03(:));
% toc
% %tau = 3, L/v = 10
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000_tau_3_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster15_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_100000000_tau_3_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster14_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000000_tau_3_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% tau_3 = discretise_pos(Np,lengtht,S,discrete);
% max_vals(4) = max(tau_3(:));
% 
% %tau = 3, L/v = 10
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000_tau_30_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster15_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_100000000_tau_30_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster14_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000000_tau_30_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% tic
% tau_30 = discretise_pos(Np,lengtht,S,discrete);
% max_vals(5) = max(tau_30(:));
% toc
% %tau = 300, L/v = 10
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000_tau_300_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% % load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster15_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_100000000_tau_300_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% load('/Users/mbailey/Documents/New_Euler/v0_localisation_studies_postdoc/DR_Localisation_map/5x5_1e8/2712_Cluster14_Output_residence_DR/ResidenceSIMS_L_50_v_5_W_0_Np_1000_dt_0.001_N_1000000000_tau_300_PBC_1_Lbox_250_250_ymin_0.010295_ymax_10.2953.mat')
% tic
% tau_300 = discretise_pos(Np,lengtht,S,discrete);
% max_vals(6) = max(tau_300(:));
% toc
% cap = max(max_vals(:));
% 
% %%
% % cap = max([max(norm(:)),max(tau_003(:)),max(tau_03(:)), ...
% %         max(tau_3(:)), max(tau_30(:)), max(tau_300(:))]);
% J = figure();
% fontsz = 14;
% titlesz = 18;
% tick_len = 0.05;
% colors=cmocean('thermal',cap); %so can scale in values of 1 - 
% colormap(colors);
% 
% 
% 
% subplot(2,3,1)
% imagesc(norm)
% axis square
% set(gca,'fontsize',fontsz,'TickLength', [tick_len, tick_len]);
% title("$\tau$/($\frac{L}{V}$) = 0", 'interpreter','latex','fontsize',titlesz)
% % xticks([1,51,101])
% xticks([1,101,201])
% xticklabels(["-5L","0","5L"])
% % yticks([1,51,101])
% yticks([1,101,201])
% yticklabels(["5L","0","-5L"])
% % h = colorbar;
% % h.Location = 'eastoutside';
% % % ylabel(h, 'Normalised tracer counts')
% % h.Label.Interpreter = 'latex';
% % h.TickLabelInterpreter = 'latex';
% caxis([0,cap])
% 
% 
% 
% subplot(2,3,2)
% imagesc(tau_003)
% axis square
% set(gca,'fontsize',fontsz,'TickLength', [tick_len, tick_len]);
% title("$\tau$/($\frac{L}{V}$) = 0.003", 'interpreter','latex','fontsize',titlesz)
% % xticks([1,51,101])
% xticks([1,101,201])
% xticklabels(["-5L","0","5L"])
% % yticks([1,51,101])
% yticks([1,101,201])
% yticklabels(["5L","0","-5L"])
% caxis([0,cap])
% 
% subplot(2,3,3)
% imagesc(tau_03)
% axis square
% set(gca,'fontsize',fontsz,'TickLength', [tick_len, tick_len]);
% title("$\tau$/($\frac{L}{V}$) = 0.03", 'interpreter','latex','fontsize',titlesz)
% % xticks([1,51,101])
% xticks([1,101,201])
% xticklabels(["-5L","0","5L"])
% % yticks([1,51,101])
% yticks([1,101,201])
% yticklabels(["5L","0","-5L"])
% caxis([0,cap])
% 
% subplot(2,3,4)
% imagesc(tau_3)
% axis square
% set(gca,'fontsize',fontsz,'TickLength', [tick_len, tick_len]);
% title("$\tau$/($\frac{L}{V}$) = 0.3", 'interpreter','latex','fontsize',titlesz)
% % xticks([1,51,101])
% xticks([1,101,201])
% xticklabels(["-5L","0","5L"])
% % yticks([1,51,101])
% yticks([1,101,201])
% yticklabels(["5L","0","-5L"])
% caxis([0,cap])
% 
% subplot(2,3,5)
% imagesc(tau_30)
% axis square
% set(gca,'fontsize',fontsz,'TickLength', [tick_len, tick_len]);
% title("$\tau$/($\frac{L}{V}$) = 3", 'interpreter','latex','fontsize',titlesz)
% % xticks([1,51,101])
% xticks([1,101,201])
% xticklabels(["-5L","0","5L"])
% % yticks([1,51,101])
% yticks([1,101,201])
% yticklabels(["5L","0","-5L"])
% caxis([0,cap])
% 
% subplot(2,3,6)
% imagesc(tau_300)
% axis square
% set(gca,'fontsize',fontsz,'TickLength', [tick_len, tick_len]);
% title("$\tau$/($\frac{L}{V}$) = 30", 'interpreter','latex','fontsize',titlesz)
% % xticks([1,51,101])
% xticks([1,101,201])
% xticklabels(["-5L","0","5L"])
% % yticks([1,51,101])
% yticks([1,101,201])
% yticklabels(["5L","0","-5L"])
% caxis([0,cap])
% 
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% set(groot,'defaulttextinterpreter','latex');
% 
% % set(groot,'defaultLegendInterpreter','latex');
% 
% exportgraphics(J,'Localisation_DRmap.pdf','BackgroundColor','none','ContentType','vector')




% imagesc(binned_pos)
% % imagesc(medfilt2(binned_pos,[3,3])/max(max(medfilt2(binned_pos,[3,3]))))
% axis square;
% % subplot(1,2,2)
% % imagesc(medfilt2(binned_pos,[5,5])/max(max(medfilt2(binned_pos,[5,5]))))
% % axis square;

% %filtered
% % normed_img = medfilt2(binned_pos,[5,5])/max(max(medfilt2(binned_pos,[5,5])));
% % %
% % J = figure();
% % % avg_x = mean(normed_img,1)/max(mean(normed_img,1));
% % % avg_y = mean(normed_img,2)/max(mean(normed_img,2));
% % % plot(avg_y)
% % % plot(smooth(avg_y,0.1),'linewidth',3,'color','k')
% % % xline(1.39,'c--',{'$~\hat{\tau_c}$ = 1.39'},'linewidth',1.5,'fontsize',18,'Interpreter', 'latex', ...
% % %     'LabelVerticalAlignment', 'top', 'LabelHorizontalAlignment', 'left');
% % yline(0,'k-',{'$N_{x,y}/N_{argmax(x,y)}$ = 0'},'linewidth',1.5,'fontsize',16, ...
% % 'LabelVerticalAlignment', 'middle','LabelHorizontalAlignment', 'center','Interpreter', 'latex')
% % pbaspect([1 0.3 1])
% % set(gca,'YTick',[]);
% % % xlim([1,52])
% % % ylim([-0.1,0.98])
% % set(gca,'XTick',[]);
% % set(gca,'Visible','off')
% 
% 
% 
