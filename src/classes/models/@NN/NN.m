classdef NN < AbstractModel
    %NN model
    
    properties
        NLayers   = 2
        NHNFactor = 1   % Number of Hidden Neurons
        %
        Fmodel 
        parameters
    end
    
    methods
        function obj = NN(varargin)
            %
            p = inputParser;
            addOptional(p,'NLayers',2)
            addOptional(p,'NHNFactor',1);
            % 
            parse(p,varargin{:})
            %
            obj.NLayers = p.Results.NLayers;
            obj.NHNFactor = p.Results.NHNFactor;

        end

    end
end

