classdef ODE2_temporal < handle
%2nd version - trying to generalise for higher order functions
    properties (SetAccess=private)
        tau;
        landscape;
        dt;  
        y_set;
        ymemory;
        dydt;
        ymin;
    end
    
    
    methods
        function obj=ODE2_temporal(dt,tau,landscape,ymin)
            obj.dt=dt;
            obj.tau=tau;
            obj.landscape=landscape;
            obj.ymin = ymin;
            %2nd order - harmonic oscillator
%             obj.dydt=@(t,y,y_set)-1/tau*(y.^2-y_set.^2); %try to adjust to allow change here
            %1st order - standard response
            obj.dydt=@(t,y,y_set)-1/tau*(y-y_set);
              %below DOES NOT WORK: .^2 makes always positive - therefore
              %will always be decreasing the value
%             obj.dydt=@(t,y,y_set)-1/tau*(y-y_set).^2;  %needs to be fixed
        end %constructor
    end
    
    
    methods
        function y=output(obj,xbox,ybox,n)

            if obj.tau>0
                if n==1 %the initial condition set up
                    y=obj.landscape.output(xbox,ybox);
                    obj.ymemory=y;
                else
                    obj.y_set=obj.landscape.output(xbox+obj.ymin*(n-1)*obj.dt,ybox+obj.ymin*(n-1)*obj.dt); %update for shifting sin curve
                    y=obj.ymemory; %current y is called from the previous value
                    %updating memory with RK4 in general form
                    obj.ymemory=obj.RK2(y,n);
                end
            else
                y=obj.landscape.output(xbox+obj.vmin*(n-1)*obj.dt,ybox+obj.vmin*(n-1)*obj.dt);
            end
        end
        yf = RK2(obj,y,n);
    end
        
end