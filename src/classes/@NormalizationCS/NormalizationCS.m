classdef NormalizationCS
    %NORMALIZATIONCS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mean
        std
    end
    
    methods
        function obj = NormalizationCS(mean,std)
            %NORMALIZATIONCS Construct an instance of this class
            %   Detailed explanation goes here
            obj.mean = mean;
            obj.std = std;
        end

    end
end

