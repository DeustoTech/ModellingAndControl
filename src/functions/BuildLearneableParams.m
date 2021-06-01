function [w,b,p] = BuildLearneableParams(NInput,NHiddenNeurons,NLayers,NOutput,varargin)

    p = inputParser;
    
    addRequired(p,'NInput');
    addRequired(p,'NHiddenNeurons');
    addRequired(p,'NLayers');
    addRequired(p,'NOutput');

    addOptional(p,'prefi',"")
    
    parse(p,NInput,NHiddenNeurons,NLayers,NOutput,varargin{:})
    
    prefi = p.Results.prefi;
    
    import casadi.*

    
    w = {};b = {};

    w{1} =  SX.sym(char(prefi+"w"+1),[NHiddenNeurons,NInput]);
    b{1} = SX.sym(char(prefi+"b"+1),[NHiddenNeurons,1]);

    p = [w{1}(:) ;b{1}(:)];
    for il = 2:NLayers+1
       w{il} = SX.sym(char(prefi+"w"+il),[NHiddenNeurons,NHiddenNeurons]);
       b{il} = SX.sym(char(prefi+"b"+il),[NHiddenNeurons,1]);
       p = [p; w{il}(:) ;b{il}(:)];

    end
    w{NLayers+2} =  SX.sym(char(prefi+"w"+(NLayers+2)),[NOutput,NHiddenNeurons]);
    b{NLayers+2} = SX.sym(char(prefi+"b"+(NLayers+2)),[NOutput,1]);
    p = [p; w{NLayers+2}(:) ;b{NLayers+2}(:)];    
    %%
end

