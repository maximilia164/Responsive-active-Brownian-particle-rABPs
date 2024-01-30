classdef landscapes < handle
    properties (Constant)
        %available landscapes
        landscapes_map = containers.Map({'checkerboard',...
                                      'sinusoid'},...
                                      {@landscape.checkerboard,...
                                       @landscape.sinusoid});
    end

    properties (SetAccess = private,Abstract)
        name;
    end
    
    methods
        y=output(obj,x,y)
    end
    

end