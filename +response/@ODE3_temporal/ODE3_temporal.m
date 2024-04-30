classdef ODE3_temporal < handle
%3r version - hysteretic response
    properties (SetAccess=private)
        tau;
        landscape;
        dt;  
        y_set;
        ymemory;
        dydt;
        % dydt_inst; %for instant response
        ymin;
    end
    
    
    methods
        function obj=ODE3_temporal(dt,tau,landscape,ymin)
            obj.dt=dt;
            obj.tau=tau;
            obj.landscape=landscape;
            obj.ymin = ymin;
            %2nd order - harmonic oscillator
%             obj.dydt=@(t,y,y_set)-1/tau*(y.^2-y_set.^2); %try to adjust to allow change here
            %1st order - standard response
            obj.dydt=@(t,y,y_set)-1/tau*(y-y_set); %the response function used
            % obj.dydt_inst = @(t,y,y_set)-1000*(y-y_set); %currently not used
        end %constructor
    end
    
    
    methods
        function y=output(obj,xbox,ybox,n)
            if obj.tau>0 %tau is the response 1/tau
                if n==1 %the initial condition set up (t=0) 
                    y=obj.landscape.output(xbox,ybox);
                    obj.ymemory=y;
                else
                    %shift both directions
                    % obj.y_set=obj.landscape.output(xbox+obj.ymin*(n-1)*obj.dt,ybox+obj.ymin*(n-1)*obj.dt); %target val from the landscape
                    %shift just xfor checks
                    obj.y_set=obj.landscape.output(xbox+obj.ymin*(n-1)*obj.dt,ybox);
                    y=obj.ymemory; %particle value is called from its memory
                    %updating memory with RK4 in general form
                    obj.ymemory=obj.RK3(y,n); %input stored DR/V0 from memory
                end
            else
                %shift both vals
                % y=obj.landscape.output(xbox+obj.ymin*(n-1)*obj.dt,ybox+obj.ymin*(n-1)*obj.dt);
                %shift just x for checks
                y=obj.landscape.output(xbox+obj.ymin*(n-1)*obj.dt,ybox);
            end
        end
        yf = RK3(obj,y,n);
    end
    
    
    
    
%     methods (Static)
%         yf = RK2(obj,y,n);   %Runge Kutta 4th order
%     end
%  
        
end