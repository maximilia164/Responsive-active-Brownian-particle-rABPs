classdef integrator < handle
  
    properties (SetAccess = public)
        response_DR;
        response_v;
        response_W;
    end

    
    methods
        function obj=integrator(varargin)
%             if nargin>0
              obj.response_DR=varargin{2};
%             end
%             if nargin>1
              obj.response_v=varargin{1};
%             end       
%             if nargin>2
              obj.response_W=varargin{3};
%             end
        end
    end %constructor
    
    methods
        advance_sim(obj,sim,n)     
    end
    
end