function [phat,pci,NH,NL]=calc_eta(obj,landscape)

chess_matrix=landscape.output(obj.x,obj.y);

NH=sum((chess_matrix>=(landscape.ymin+landscape.ymax)/2),1); %sums along columns (timewise) - returns row with values for each timestep
NL=sum((chess_matrix<(landscape.ymin+landscape.ymax)/2),1);
[phat,pci] = binofit(NH,obj.Np); %num_p = Np - set in eta_sims_function
%see documentation - phat is likelihood particle is in NH based on sum of
%NH, number of independent trials Np, pci is 95% confidence interval
end
