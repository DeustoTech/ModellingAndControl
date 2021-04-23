function [w,b,p] = BuildLearneableParams(NInput,NHiddenNeurons,NLayers,NOutput)

    import casadi.*

    w = {};b = {};

    w{1} =  SX.sym(char("w"+1),[NHiddenNeurons,NInput]);
    b{1} = SX.sym(char("b"+1),[NHiddenNeurons,1]);

    p = [w{1}(:) ;b{1}(:)];
    for il = 2:NLayers+1
       w{il} = SX.sym(char("w"+il),[NHiddenNeurons,NHiddenNeurons]);
       b{il} = SX.sym(char("b"+il),[NHiddenNeurons,1]);
       p = [p; w{il}(:) ;b{il}(:)];

    end
    w{NLayers+2} =  SX.sym(char("w"+(NLayers+2)),[NOutput,NHiddenNeurons]);
    b{NLayers+2} = SX.sym(char("b"+(NLayers+2)),[NOutput,1]);
    p = [p; w{NLayers+2}(:) ;b{NLayers+2}(:)];    
    %%
end

