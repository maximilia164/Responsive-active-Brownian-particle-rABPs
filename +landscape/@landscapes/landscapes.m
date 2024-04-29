classdef landscapes < handle
    properties (Constant)
        %available landscapes - not called 
        landscapes_map = containers.Map({'checkerboard',...
                                      'sinusoid', ...
                                      'sinusoid_temporal'},...
                                      {@landscape.checkerboard,...
                                       @landscape.sinusoid,...
                                       @landscape.sinusoid_temporal});
    end

    properties (SetAccess = private,Abstract)
        name;
    end
    
    methods
        y=output(obj,x,y)
    end
    

end