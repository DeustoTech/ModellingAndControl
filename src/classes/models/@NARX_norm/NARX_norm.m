classdef NARX_norm < NARX
    %NARX_LONGTERM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mn
        st
    end
    
    methods
        function obj = NARX_norm(varargin)
            %NARX_LONGTERM Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@NARX(varargin{:});
        end
        

    end
end

