classdef checkerboard < landscape.landscapes 

    properties (SetAccess = private)
        name; %string
        L; %length of the sides of the squares of the checkerboard pattern
        ymin; 
        ymax;
        gauss;
    end
    
    methods (Static)
        s = SQW(t)
    end
    
    methods 
        Plot(obj)
        function obj=checkerboard(name,ymin,ymax,L,gauss)
            obj.name=name;
            obj.L=L;
            obj.ymin=ymin;
            obj.ymax=ymax;
            obj.gauss=gauss;
        end %constructor
        
        %output into the integrator
        function y=output(obj,x,y)
            y=((obj.ymin-obj.ymax)/2*(1+obj.SQW(x./(obj.L)*pi+pi/2)...
                .*obj.SQW(y./(obj.L)*pi+pi/2))+obj.ymax).*obj.gauss;
        end %2D checkerboard function
        
        %for post-processing (localisation study)
        function y=processing(obj,x,y)
            y=(obj.ymin-obj.ymax)/2*(1+obj.SQW(x./(obj.L)*pi+pi/2)...
                .*obj.SQW(y./(obj.L)*pi+pi/2))+obj.ymax;
        end %2D checkerboard function
        
    end
    

end