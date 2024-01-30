classdef simulator_cls < handle
    
    properties %constants
        T=300; %Temperature - perhaps adjust this value to get desired DT, DR
        %R=2e-6; % radius of the particle [m]
        R= 1e-6; %Ueli experiment/to get desired values
        kb = 1.38e-23;		% Boltzmann constant [J/K]
%         eta=1e-3; %viscosity [Pa s]
        eta=0.89e-3; %viscosity [Pa s] %using water at rT
        rho=2500; %density [kg/m3]
        m
        I
        gamma
        gammar
        DT
        DR
    end
    
    properties  %parameters
        Np=1      %Number of particles
        gap=10e-6 %gap of single box
        L_box=[100 100]*1e-6   %size of the box
        dt=1e-3      %time step
        N=1e2       %number of steps
        delta=1   %lag (steps) between stored frames
        W=0     %active angular velocity
        v0=0      %active velocity
        rand_init=1 %randomise positions
        PBC=[];   %periodic boundary conditions
        yesplot=0;
        plot_single=1;
        verbose=0;
        save_theta_omega=0;
        save_DR=0;
        save_v0=0;
        save_W=0;
        data_type='single';
        integrator;
        barebone=0;
    end
    
    properties(Access = public)
        x
        y
        vx
        vy
        theta
        omega
        
        xbox
        ybox
        vxbox
        vybox
        thetabox
        omegabox
        
        alpha_box
        v0_box
        W_box
        

        DR_set
        DR_array
        v0_array
        v0_set_array
        W_array
        W_set_array
    end
    
    %constructor
    methods
        function obj=simulator_cls(Np,dt,N,delta,gap,L_box,integrator)
            obj.Np=Np;
            obj.N=N;
            obj.dt=dt;
            obj.gap=gap;
            obj.L_box=L_box;
            obj.delta=delta;
            obj.integrator=integrator;
        end
    end
    
    %initializer
    methods 
        function initialize(obj)
            obj.m=obj.rho*4/3*pi*obj.R^3; %mass  [kg] %based on sio2 particle
            obj.I=2/5*obj.m*obj.R^2; %moment of inertia   
            
            %commented out for corresponding to Ueli's experiments
%             obj.gamma = 6*pi*obj.R*obj.eta*2;	% friction coefficient [N s/m] %why the factor 2?
%             obj.gammar = obj.gamma*obj.R^2*8/6; %rotational friction coefficient

%             obj.DT = obj.kb*obj.T/obj.gamma;		% translational diffusion coefficient [m^2/s]
%             obj.DR = obj.kb*obj.T/obj.gammar;	% rotational diffusion coefficient [rad^2/s]
            
            %for Ueli experiments with velocity
            obj.gamma = obj.kb*obj.T/0.125; %to set the DT to 0.125
            obj.gammar = obj.kb*obj.T/0.1597; %to set the DR to 0.1597
            obj.DT = obj.kb*obj.T/obj.gamma;		% translational diffusion coefficient [m^2/s]
            obj.DR = obj.kb*obj.T/obj.gammar;	% rotational diffusion coefficient [rad^2/s]
           
            %initialize position vectors
            obj.x=zeros(obj.Np,obj.N/obj.delta,obj.data_type); %position vectors
            obj.y=obj.x;
            
            %randomize initial positions within the sim box or have
            %all the particles start at the origin
            if obj.rand_init==1 
                if obj.data_type==strcmp(obj.data_type,'single') %set data type of position vectors
                    obj.x(:,1)=single(2*obj.L_box(1)*rand(obj.Np,1)-obj.L_box(1));
                    obj.y(:,1)=single(2*obj.L_box(2)*rand(obj.Np,1)-obj.L_box(2));
                else
                    obj.x(:,1)=2*obj.L_box(1)*rand(obj.Np,1)-obj.L_box(1);
                    obj.y(:,1)=2*obj.L_box(2)*rand(obj.Np,1)-obj.L_box(2);
                end
            else
                %to initialise at 0,0 (minimal DR - increase ability to escape)
%                     obj.x(:,1)=zeros(obj.Np,1,obj.data_type);
%                     obj.y(:,1)=zeros(obj.Np,1,obj.data_type);     
                %to initialise at max velocity (increase ability to escape)
                    obj.x(:,1)=zeros(obj.Np,1,obj.data_type);
                    obj.y(:,1)=obj.gap*ones(obj.Np,1,obj.data_type);  
            end
            
            if obj.data_type==strcmp(obj.data_type,'single')
                obj.thetabox=single(rand(obj.Np,1)*2*pi); %initial orientations
            else
                obj.thetabox=rand(obj.Np,1)*2*pi; %initial orientations
            end
        
            obj.xbox=obj.x(:,1);
            obj.ybox=obj.y(:,1);
            obj.omegabox=zeros(obj.Np,1,obj.data_type);    
            obj.theta(:,1)=obj.thetabox; %initial orientations
            
            obj.vxbox=zeros(obj.Np,1,obj.data_type);
            obj.vybox=zeros(obj.Np,1,obj.data_type);
              
            if obj.save_theta_omega==1
                obj.theta=zeros(obj.Np,obj.N/obj.delta,obj.data_type);       %angle
                obj.omega=zeros(obj.Np,obj.N/obj.delta,obj.data_type);       %angular velocity
                obj.theta(:,1)=obj.thetabox; %initial orientations
            end
            
            if obj.save_DR==1
                obj.DR_set=zeros(obj.Np,obj.N/obj.delta,obj.data_type);
                obj.DR_array=zeros(obj.Np,obj.N/obj.delta,obj.data_type);
                obj.alpha_box=obj.integrator.response_DR.landscape.output(obj.xbox,obj.ybox);
                obj.DR_set(:,1)=obj.alpha_box;
                obj.DR_array(:,1)=obj.alpha_box;
            end
            
            if obj.save_v0==1
                obj.v0_set_array=zeros(obj.Np,obj.N/obj.delta,obj.data_type);
                obj.v0_array=zeros(obj.Np,obj.N/obj.delta,obj.data_type);
                obj.v0_box=obj.integrator.response_v.landscape.output(obj.xbox,obj.ybox);
                obj.v0_set_array(:,1)=obj.v0_box;
                obj.v0_array(:,1)=obj.v0_box;
            end
            
            if obj.save_W==1
                obj.W_set_array =zeros(obj.Np,obj.N/obj.delta,obj.data_type);
                obj.W_array=zeros(obj.Np,obj.N/obj.delta,obj.data_type);
                obj.W_box=obj.integrator.response_W.landscape.output(obj.xbox,obj.ybox);
                obj.W_set_array(:,1)=obj.W_box;
                obj.W_array(:,1)=obj.W_box;
            end

        end
    end
    
    methods
        PLOT(obj,n,barebone)
        function b = saveobj(a) %consider including function here
            S.T=a.T; %Temperature
            S.R=a.R; % radius of the particle [m]
            S.kb=a.kb;		% Boltzmann constant [J/K]
            S.eta=a.eta; %viscosity [Pa s]
            S.rho=a.rho; %density [kg/m3]
            S.m=a.m;
            S.I=a.I;
            S.gamma=a.gamma;
            S.gammar=a.gammar;
            S.DT=a.DT;
            S.DR=a.DR; 
            S.Np=a.Np;      %Number of particles
            S.L_box=a.L_box;   %size of the box
            S.dt=a.dt;      %time step
            S.N=a.N;       %number of steps
            S.delta=a.delta;   %lag (steps) between stored frames
            S.W=a.W;     %active angular velocity
            S.v0=a.v0;      %active velocity
            S.rand_init=a.rand_init; %whether or not positions are randomised initially
            S.PBC=a.PBC;   %periodic boundary conditions
            S.Np=a.Np;
            S.t=0:a.dt*a.delta:a.dt*a.N; 
        
            if a.save_DR==1
                S.DR_set=a.DR_set;
                S.DR_array=a.DR_array;
            end
            
            if a.save_v0==1
                S.v0_set_array=a.v0_set_array;
                S.v0_array=a.v0_array;
            end
            
            if a.save_W==1
                S.W_set_array=a.W_set_array;
                S.W_array=a.W_array;
            end
            
            b = S;
        end
        function traj=get_trajectories(obj)
            traj.x=obj.x;
            traj.y=obj.y;
            if obj.save_theta_omega==1
                traj.theta=obj.theta;
                traj.omega=obj.omega;
            end
        end
        function integrate(obj)
            index1=0; %time 
            index2=2; %particles position (individual) at time 2
            for n=1:obj.N %across all integration steps (1e7)
                obj.integrator.advance_sim(obj,n)
                
                if n==index1+obj.delta
                    obj.x(:,index2)=obj.xbox; %save the value at x every delta in xbox 
                    obj.y(:,index2)=obj.ybox;
                    
                    if obj.save_theta_omega==1
                        obj.theta(:,index2)=obj.thetabox;
                        obj.omega(:,index2)=obj.omegabox;
                    end
                    
                    if obj.save_DR==1
                        obj.DR_set(:,index2)=obj.integrator.response_DR.landscape.output(obj.xbox,obj.ybox);
                        obj.DR_array(:,index2)=obj.kb*obj.T./obj.alpha_box;
                    end
                    
                    if obj.save_v0==1
                        obj.v0_set_array(:,index2)=obj.integrator.response_v.landscape.output(obj.xbox,obj.ybox);
                        obj.v0_array(:,index2)=obj.v0_box;
                    end
                    
                    if obj.save_W==1
                        obj.W_set_array(:,index2)=obj.integrator.response_W.landscape.output(obj.xbox,obj.ybox);
                        obj.W_array(:,index2)=obj.W_box;
                    end
                    
                    index1=index1+obj.delta; %update time requirement so next condition to be met
                    index2=index2+1; %next column along which is saved 
                    if obj.yesplot==1
                        PLOT(obj,index2-1,obj.barebone)  
                    end
                    if obj.verbose==1
                        n
                    end
                end
            end
        end
    end
    
    methods (Static)
        checkerboard_3(L,xmin,xmax)
    end
   
      
end