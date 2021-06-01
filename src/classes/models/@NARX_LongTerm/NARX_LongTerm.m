classdef NARX_LongTerm < NARX
    %NARX_LONGTERM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Nt = 5
    end
    
    methods
        function obj = NARX_LongTerm(varargin)
            %NARX_LONGTERM Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@NARX(varargin{:});
        end
        

    end
end

