function YTest = Prediction(iNARX,ics,r,Nt)


sym = iNARX.model.sym;
u_sym = sym.u;
d_sym = sym.d;
x_sym = sym.x;
%%

ind_sym = arrayfun(@(i)x_sym(1+(i-1)*ics.Nout:i*ics.Nout)',1:iNARX.No-1,'UniformOutput',0);
%
x_next = iNARX.model.Fcn(x_sym,u_sym,d_sym,iNARX.params.num);


step_model = casadi.Function('step_model',{x_sym,d_sym,u_sym}, ...
                            {[x_next ;[ind_sym{:}]']});

roll_on_model = step_model.mapaccum(Nt);
%%
YTest = roll_on_model(r.OutputDelays(:,1),r.Disturbances(:,1:Nt),r.Input(:,1:Nt));
YTest = full(YTest(1:ics.Nout,:));

end

