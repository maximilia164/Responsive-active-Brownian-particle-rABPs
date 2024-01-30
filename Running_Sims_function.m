function S=Running_Sims_function(Np,dt,N,delta,gap,L_box,v0,tau,ymin,ymax,W,verbose,path,PBC)

max_ratio = ymax/ymin;

%initialise the sim/landscape and inputs    
% landscape_DR=landscape.sinusoid('sin_DR',ymin,ymax,gap); 
% response_DR=response.ODE(dt,tau,landscape_DR);
% integratorx=integrator(response_DR,[],[]); %only Dr is studied for now
% sim=simulator_cls(Np,dt,N,delta,L_box,integratorx);

% landscape_DR=landscape.sinusoid('sinDR',ymin,ymax,gap);  %name for reference
% response_DR=response.ODE(dt,tau,landscape_DR);
% integratorx=integrator(response_DR,[],[]); %only Dr is studied for now
% sim=simulator_cls(Np,dt,N,delta,gap,L_box,integratorx);

%initialise desired landscape in value
landscape_v0=landscape.checkerboard('checker_v0',ymin,ymax,gap); 
%initialise the desired response - hysteresis for ODE3 - for the landscape
%declared above
response_v0=response.ODE3(dt,tau,landscape_v0);
%can add more responses if desired - but requires input of DRmin/DRmax etc.
% response_DR=response.ZOH_Delay(dt,tau,landscape_DR);
%integrator that takes in the values of the response function
%3 arguments - DR, velocity, torque
integratorx=integrator([],response_v0,[]); 
sim=simulator_cls(Np,dt,N,delta,gap,L_box,integratorx);

% landscape_v=landscape.sinusoid('sin_v',ymin,ymax,gap);
% response_v=response.ODE(dt,tau,landscape_v);
% landscape_W=landscape.sinusoid('sin_W',ymin,ymax,gap);
% response_W=response.ODE(dt,tau,landscape_W);

%running sim
sim.save_theta_omega=0;
sim.save_DR=0; %saves Dr etc.
sim.save_v0=0;
sim.save_W=0;
sim.W=W;
sim.v0=v0;
sim.yesplot=0; 
sim.barebone=0;
sim.plot_single=0;
sim.PBC=PBC;
sim.Np=Np;
sim.verbose=verbose;
sim.rand_init=1; %change to 0 for TSA, 1 for localisation (random)
sim.data_type='single'; %used to define x vector data type - less precision but less memory
sim.initialize;
sim.integrate
S = saveobj(sim); %saves simulation properties to S

S.traj=sim.get_trajectories; %gets x, y values - not for localisation -

% [eta_Dr,tau_H_Dr,tau_L_Dr]= post_process.residence_times_fast(sim,landscape_DR);
% S.eta_Dr=eta_Dr;
% S.tau_H_Dr=tau_H_Dr;
% S.tau_L_Dr=tau_L_Dr;
[eta_v0,tau_H_v0,tau_L_v0]= post_process.residence_times_fast(sim,landscape_v0);
S.eta_v0=eta_v0;
S.tau_H_v0=tau_H_v0;
S.tau_L_v0=tau_L_v0;

S.max_ratio = max_ratio;
S.gap = gap;
S.tau = tau;


filename=['ResidenceSIMS_L_' num2str(gap*1e6) ...
    '_v_' num2str(v0*1e6) '_W_' num2str(W) '_Np_' num2str(Np) ...
    '_dt_' num2str(dt) '_N_' num2str(N) ...
    '_tau_' num2str(tau) '_PBC_' num2str(PBC) ...
    '_Lbox_' num2str(L_box(1)*1e6) '_' num2str(L_box(2)*1e6) '_ymin_' num2str(ymin) '_ymax_' num2str(ymax) ...
     '.mat']; %name of the save file

filename_S = fullfile(path, filename);
save(filename_S,'S')

S=[];
sim=[];
t=[];

%for residence times
eta_v0=[];
tau_H_v0=[];
tau_L_v0=[];

%for eta sims
phat=[];
pci=[];
NH=[];
NL=[];

end


