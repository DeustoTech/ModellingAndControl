classdef NARX < AbstractModel
    %
    
    properties
        No          = 2
        Ni          = 1
        Nd          = 1
        %
        NLayers     = 2
        NHNFactor   = 1   % Number of Hidden Neurons
        %
        mode        string {mustBeMember(mode,{'OpenLoop','CloseLoop'})} = 'OpenLoop'
    end
    
    methods
        function obj = NARX(varargin)
                            %
            p = inputParser;
            addOptional(p,'No',2)
            addOptional(p,'Ni',1);
            addOptional(p,'Nd',1);
            % 
            addOptional(p,'NLayers',2);
            addOptional(p,'NHNFactor',1);

            parse(p,varargin{:})
            %
            obj.NLayers = p.Results.NLayers;
            obj.NHNFactor = p.Results.NHNFactor;
            %
            obj.No = p.Results.No;
            obj.Ni = p.Results.Ni;
            obj.Nd = p.Results.Nd;

        end
        

    end
end

