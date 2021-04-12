function [AllInputs,AllOutputs] = NARXDataFormat(idat,no)

    [~,~,~,nexp] =  size(idat);
    
    AllInputs = [];
    AllOutputs = [];
    for inexp = 1:nexp
        iexp = getexp(idat,inexp);
        [in,out] = NARXData(iexp,no);
        AllInputs  = [AllInputs in'];
        AllOutputs = [AllOutputs out'];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function [inputs_NARX,outputs_NARX] =NARXData(jexp,no)
        
        inputs  = jexp.InputData;
        outputs = jexp.OutputData;
        %   
        inputs_NARX = inputs((no+1):end,:);
        for i = 1:no
            inputs_NARX = [inputs_NARX outputs((no+1-i):end-i,:) ];
        end
        outputs_NARX = outputs((no+1):end,:);
    end
end