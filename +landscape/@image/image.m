classdef image < handle
    properties (Constant)
        %available landscapes
        landscapes_map = containers.Map({'checkerboard',...
                                      'sinusoid',...
                                      'image'},...
                                      {@landscape.checkerboard,...
                                       @landscape.sinusoid,...
                                       @landscape.image});
    end

    properties (SetAccess = private)
        name;
        ymin
        ymax
        path
        Ibw
        L
        X
        Y
    end
    
    methods
        function obj=image(name,filename,ymin,ymax,L_box)
            obj.name=name;
            
            obj.ymin=ymin;
            obj.ymax=ymax;
            I = imread(filename);
            s=size(I);  
            w=s(2);
            h=s(1);
            w_h=w/h;
            obj.L=L_box*[w_h 1];
%             r = centerCropWindow2d(s,[min(s(1:2)) min(s(1:2))]);    
%             I = imcrop(I,r);
            
            Ibw = double(rgb2gray(I));
            Ibw_lin=reshape(Ibw,1,numel(Ibw));        
       
            obj.Ibw=flipud(-(Ibw-min(Ibw_lin))./(max(Ibw_lin)-min(Ibw_lin)).*(ymax-ymin)+ymax); 
           
            %obj.Ibw=flipud((Ibw-min(Ibw_lin))./(max(Ibw_lin)-min(Ibw_lin)).*(ymax-ymin)+ymin); 
            x=linspace(-obj.L(1),obj.L(1),numel(Ibw(1,:)));
            y=linspace(-obj.L(2),obj.L(2),numel(Ibw(:,1)));    
            [obj.X,obj.Y]=meshgrid(x,y);
            
        end %constructor
        
        function y=output(obj,x,y)        
            y = interp2(obj.X,obj.Y,obj.Ibw,x,y);
        end
       
    end
    

end