classdef ODE3 < handle
%3r version - hysteretic response
    properties (SetAccess=private)
        tau;
        landscape;
        dt;  
        y_set;
        ymemory;
        dydt;
        dydt_inst; %for instant response
    end
    
    
    methods
        function obj=ODE3(dt,tau,landscape)
            obj.dt=dt;
            obj.tau=tau;
            obj.landscape=landscape;
            %2nd order - harmonic oscillator
%             obj.dydt=@(t,y,y_set)-1/tau*(y.^2-y_set.^2); %try to adjust to allow change here
            %1st order - standard response
            obj.dydt=@(t,y,y_set)-1/tau*(y-y_set); %the response function used
            obj.dydt_inst = @(t,y,y_set)-1000*(y-y_set); %currently not used
        end %constructor
    end
    
    
    methods
        function y=output(obj,xbox,ybox,n)
            if obj.tau>0 %tau is the response 1/tau
                if n==1 %the initial condition set up (t=0) 
                    y=obj.landscape.output(xbox,ybox);
                    obj.ymemory=y;
                else
                    obj.y_set=obj.landscape.output(xbox,ybox); %target val from the landscape
                    y=obj.ymemory; %particle value is called from its memory
                    %updating memory with RK4 in general form
                    obj.ymemory=obj.RK3(y,n); %input stored DR/V0 from memory
%                     obj.ymemory=obj.update(y); %call the update function RK4
                end
            else
                y=obj.landscape.output(xbox,ybox); %when tau = 0
            end
        end
        
        yf = RK3(obj,y,n);
%         yf=update(obj,y); 
    end
    
    
    
    
%     methods (Static)
%         yf = RK2(obj,y,n);   %Runge Kutta 4th order
%     end
%  
        
end