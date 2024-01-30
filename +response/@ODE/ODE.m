classdef ODE < handle
 
    properties (SetAccess=private)
        tau;
        landscape;
        dt;  
        y_set
        ymemory
        dydt
    end
    
    
    methods
        function obj=ODE(dt,tau,landscape)
            obj.dt=dt;
            obj.tau=tau;
            obj.landscape=landscape;
            obj.dydt=@(t,y,y_set)-1/tau*(y-y_set); %no need for this now - hardcoded (unfortunately)
        end %constructor
    end
    
    
    methods
        function y=output(obj,xbox,ybox,n)
            if obj.tau>0
                if n==1 %the initial condition set up
                    y=obj.landscape.output(xbox,ybox);
                    obj.ymemory=y;
                else
                    obj.y_set=obj.landscape.output(xbox,ybox); %target val
                    y=obj.ymemory; %current y is called from the previous value
                    %obj.ymemory=obj.RK(@(t,y)obj.dydt(t,y,obj.y_set),obj.dt,n*obj.dt,y);
                    obj.ymemory=obj.update(y); %call the update function RK4
                end
            else
                y=obj.landscape.output(xbox,ybox);
            end
        end
        
        yf=update(obj,y); 
    end
    
    
    
    
    methods (Static)
        yf = RK(f,dt,tn,y0)   %Runge Kutta 4th order
    end
 
        
end