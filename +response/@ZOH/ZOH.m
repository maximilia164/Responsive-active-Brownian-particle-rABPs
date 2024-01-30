classdef ZOH < handle
 
    properties (SetAccess=private)
        tau;
        landscape;
        dt;
        ymemory;
    end
    
    
    methods
        function obj=ZOH(dt,tau,landscape)
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
                else
                    if obj.dt*n==c*obj.tau
                        y=obj.landscape.output(xbox,ybox);
                        obj.ymemory=y;
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