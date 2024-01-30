classdef ZOH_Delay < handle
    
    properties (SetAccess=private)
        tau;
        landscape;
        dt;
        ymemory;
        yfuture;
    end
    
    
    methods
        function obj=ZOH_Delay(dt,tau,landscape)
            obj.dt=dt;
            obj.tau=tau;
            obj.landscape=landscape;
        end %constructor
    end
    
    
    methods
        function y=output(obj,xbox,ybox,n)
            if obj.tau>0
                c=floor(obj.dt*n/obj.tau);
                if n==1
                    y=obj.landscape.output(xbox,ybox);
                    obj.ymemory=y;
                    obj.yfuture=y;
                else
                    if obj.dt*n==c*obj.tau
                        y=obj.yfuture;
                        obj.ymemory=y;
                        obj.yfuture=obj.landscape.output(xbox,ybox);
                    else
                        y=obj.ymemory;
                    end
                end
            else
                y=obj.landscape.output(xbox,ybox);
            end
        end
    end
      
    
   
end



% 
% 
% %defining the ode used
%             if obj.ode == 0
%                 obj.dydt=@(t,y,a_set)-1/obj.tau*(y-a_set); %ode
%             end
%             
%             if obj.ode == 1
%                 obj.dydt=@(t,y,a_set)-1e-1/obj.tau*(y-a_set);
%             end