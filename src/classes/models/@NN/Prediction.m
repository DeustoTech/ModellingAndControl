function YTest = Prediction(iNN,ics,r,Nt)

    YTest = iNN.model.Fcn(r.Input,r.Disturbances,iNN.params.num);

end

