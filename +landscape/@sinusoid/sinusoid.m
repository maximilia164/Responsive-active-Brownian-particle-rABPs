classdef sinusoid < landscape.landscapes

    properties (SetAccess = private)
        name; %string
        L; %through-to-peak distance (period=2*L)
        ymin; 
        ymax;
    end
   
    
    methods 
        Plot(obj)
        function obj=sinusoid(name,ymin,ymax,L)
            obj.name=name;
            obj.L=L;
            obj.ymin=ymin;
            obj.ymax=ymax;
        end %constructor
        
        function y=output(obj,x,y)
            y=(obj.ymin-obj.ymax)/2*(1+sin(x./(obj.L)*pi+pi/2)...
                .*sin(y./(obj.L)*pi+pi/2))+obj.ymax;
        end %2D sinusoid
        
    end
    

end