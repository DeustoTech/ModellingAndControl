
clear all 

T_k = 273.15;


rl = sim('SOFC');

InletGas = rl.logsout.getElement('Inlet Gas').Values;

H2O = InletGas.H2O;
Fuel = InletGas.Fuel;
Air = InletGas.Air;

%%
TReformer = rl.logsout.getElement('T_reformer').Values.Data - T_k;
TH2O  = H2O.Steam_Temperature.Data - T_k;
TFuel = Fuel.Fuel_Temperature.Data- T_k ;
TAir  = Air.Air_Temperature.Data - T_k;

%%
clf
hold on 
plot(TReformer,'LineWidth',2);
plot(TFuel);
plot(TAir);
plot(TH2O);
ylabel('Temperature(ºC)')
legend('T_{reformer}','T_{fuel}','T_{Air}','T_{H_2O}')