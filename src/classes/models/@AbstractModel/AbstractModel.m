classdef AbstractModel
    %BSTRACTMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        params
        model
        loss 
    end
    
    methods (Abstract)
        Ytest   = Prediction(obj)
        r       = SplitGenData(obj)
        imodel  = compile;
    end
end

