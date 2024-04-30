function S=Running_Sims_function(Np,dt,N,delta,gap,L_box,v0,tau,ymin,ymax,W,verbose,path,PBC,gauss,env,ode,rand_init)

% max_ratio = ymax/ymin;
%NB: very simple to extend so that each DR/v0 has different landscape/ODE
switch env 
    %first switch between environment types - can add more
    case 'sinusoid'
        if ~isempty(ymin{1}) %velocity
            landscape_v0=landscape.sinusoid('sin_v0',ymin{1},ymax{1},gap,gauss);
            switch ode %different response functions possible
                    case 'Standard'
                        response_v0=response.ODE2(dt,tau,landscape_v0);
                    case 'Hysteresis'
                        response_v0=response.ODE3(dt,tau,landscape_v0);
                    case 'Standard_Temporal'
                        response_v0=response.ODE2_temporal(dt,tau,landscape_v0,ymin{1});
                    case 'Hysteresis_Temporal'
                        response_v0=response.ODE3_temporal(dt,tau,landscape_v0,ymin{1});
                    case 'ZOH'
                        response_v0=response.ZOH(dt,tau,landscape_v0);
                    case 'ZOH_Delay'
                        response_v0=response.ZOH_Delay(dt,tau,landscape_v0);
                    otherwise 
                        warning('Not a valid input, try again Ueli')
            end
        end
        if ~isempty(ymin{2}) %DR
            landscape_DR=landscape.sinusoid('sin_DR',ymin{2},ymax{2},gap,gauss);
            switch ode %different response functions possible
                    case 'Standard'
                        response_DR=response.ODE2(dt,tau,landscape_DR);
                    case 'Hysteresis'
                        response_DR=response.ODE3(dt,tau,landscape_DR);
                    %these are commented out, since may need to manually input variable for the speed of shift of the mapping
                    % case 'Standard_Temporal'
                        % response_DR=response.ODE2_temporal(dt,tau,landscape_DR,VAR); replace VAR with desired shift speed
                    % case 'Hysteresis_Temporal'
                    %     response_DR=response.ODE3_temporal(dt,tau,landscape_DR,VAR);
                    case 'ZOH'
                        response_DR=response.ZOH(dt,tau,landscape_DR);
                    case 'ZOH_Delay'
                        response_DR=response.ZOH_Delay(dt,tau,landscape_DR);
                    otherwise 
                        warning('Not a valid input, try again Ueli (see the code)')
            end
        end
        if ~isempty(ymin{3}) %Active Torque
            landscape_W=landscape.sinusoid('sin_W',ymin{3},ymax{3},gap,gauss);
            %can add copy/paste below as needed for response funcs
        end
    case 'checker'
        if ~isempty(ymin{1})
            landscape_v0=landscape.checkerboard('checker_v0',ymin{1},ymax{1},gap,gauss);
            switch ode
                    case 'Standard'
                        response_v0=response.ODE2(dt,tau,landscape_v0);
                    case 'Hysteresis'
                        response_v0=response.ODE3(dt,tau,landscape_v0);
                    case 'Standard_Temporal'
                        response_v0=response.ODE2_temporal(dt,tau,landscape_v0,ymin{1});
                    case 'Hysteresis_Temporal'
                        response_v0=response.ODE3_temporal(dt,tau,landscape_v0,ymin{1});
                    case 'ZOH'
                        response_v0=response.ZOH(dt,tau,landscape_v0);
                    case 'ZOH_Delay'
                        response_v0=response.ZOH_Delay(dt,tau,landscape_v0);
                    otherwise 
                        warning('Not a valid input, try again Ueli')
            end
        end
        if ~isempty(ymin{2})
            landscape_DR=landscape.checkerboard('checker_DR',ymin{2},ymax{2},gap,gauss);
            switch ode %different response functions possible
                    case 'Standard'
                        response_DR=response.ODE2(dt,tau,landscape_DR);
                    case 'Hysteresis'
                        response_DR=response.ODE3(dt,tau,landscape_DR);
                    %these are commented out, since may need to manually input variable for the speed of shift of the mapping
                    % case 'Standard_Temporal'
                        % response_DR=response.ODE2_temporal(dt,tau,landscape_DR,VAR); replace VAR with desired shift speed
                    % case 'Hysteresis_Temporal'
                    %     response_DR=response.ODE3_temporal(dt,tau,landscape_DR,VAR);
                    case 'ZOH'
                        response_DR=response.ZOH(dt,tau,landscape_DR);
                    case 'ZOH_Delay'
                        response_DR=response.ZOH_Delay(dt,tau,landscape_DR);
                    otherwise 
                        warning('Not a valid input, try again Ueli')
            end
        end
        if ~isempty(ymin{3})
            landscape_W=landscape.checkerboard('checker_W',ymin{3},ymax{3},gap,gauss);
            %can add copy/paste below as needed for response funcs
        end
end


%integrator that takes in the values of the response function
%3 arguments - velocity, DR, torque - needs to be defined still by user
%otherwise stupid nesting or new function - 
% integratorx=integrator(response_v0,response_DR,[]); 
integratorx=integrator(response_v0,[],[]); 
sim=simulator_cls(Np,dt,N,delta,gap,L_box,integratorx);

%running sim
sim.save_theta_omega=0;
%%%!!! Make sure that DR/v0 properly saved as appropriate
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
sim.rand_init=rand_init; %change to 0 for TSA, 1 for localisation (random)
sim.data_type='single'; %used to define x vector data type - less precision but less memory
sim.initialize;
sim.integrate
S = saveobj(sim); %saves simulation properties to S

S.traj=sim.get_trajectories; %gets x, y values - not for localisation -

if~contains(ode,'Temporal') %standard case implemented
    if exist('landscape_v0')
        [eta_v0,tau_H_v0,tau_L_v0]= post_process.residence_times_fast(sim,landscape_v0);
        S.eta_v0=1-eta_v0; %since expect localisation in low velocity region - eta defined by max values
        S.tau_H_v0=tau_H_v0;
        S.tau_L_v0=tau_L_v0;
    end
    if exist('landscape_DR')
        [eta_Dr,tau_H_Dr,tau_L_Dr]= post_process.residence_times_fast(sim,landscape_DR);
        S.eta_Dr=eta_Dr;
        S.tau_H_Dr=tau_H_Dr;
        S.tau_L_Dr=tau_L_Dr;
    end
else
% "Localisation calc for temporal landscape not implemented yet"
    if exist('landscape_v0')
        [eta_v0,N_H_v0,N_L_v0,c]= post_process_temporal.residence_times_temporal(sim,landscape_v0,ymin{1});
        S.eta_v0=1-eta_v0; %since expect localisation in low velocity region - eta defined by max values
        S.N_H_v0=N_H_v0;
        S.N_L_v0=N_L_v0;
        S.C = c; %to check how matrix looks
    end
    % % again commented out for now - need to update VAR as before for speed of shift
    % % if exist('landscape_DR')
    % %     [eta_Dr,tau_H_Dr,tau_L_Dr]= post_process_temporal.residence_times_fast(sim,landscape_DR,VAR);
    % %     S.eta_Dr=eta_Dr;
    % %     S.tau_H_Dr=tau_H_Dr;
    % %     S.tau_L_Dr=tau_L_Dr;
    % % end

end

if ~isempty(ymin{1})
    S.v0_ratio = ymax{1}/ymin{1};
end
if ~isempty(ymin{2})
    S.DR_ratio = ymax{2}/ymin{2};
end
if ~isempty(ymin{3})
    S.W_ratio = ymax{3}/ymin{3};
end

S.gap = gap;
S.tau = tau;
S.ode = ode;


filename=['ResidenceSIMS_L_' num2str(gap*1e6) ...
    '_v_' num2str(v0*1e6) '_W_' num2str(W) '_Np_' num2str(Np) ...
    '_dt_' num2str(dt) '_N_' num2str(N) ...
    '_tau_' num2str(tau) '_PBC_' num2str(PBC) ...
    '_Lbox_' num2str(L_box(1)*1e6) '_' num2str(L_box(2)*1e6) '_vmin_' num2str(ymin{1}) '_vmax_' num2str(ymax{1}) ...
    '_DRmin_' num2str(ymin{2}) '_DRmax_' num2str(ymax{2}) '_Wmin_' num2str(ymin{3}) '_Wmax_' num2str(ymax{3}) ...
    '_ODE_' ode '.mat']; %name of the save file

filename_S = fullfile(path, filename);
save(filename_S,'S')

%clear the cache
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


