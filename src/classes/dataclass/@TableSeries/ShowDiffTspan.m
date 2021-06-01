function  ShowDiffTspan(Ts,varargin)


p = inputParser;
addRequired(p,'Ts')
addOptional(p,'window',[])

parse(p,Ts,varargin{:})

window = p.Results.window;

hold on
for iTs = Ts
    Nt = length(iTs.DateTime);

    if isempty(window)
        plot(iTs.DateTime(2:end),hours(diff(iTs.tspan)),'.-','LineWidth',2,'MarkerSize',15);
    else
        time = hours(diff(iTs.tspan));
        try
        plot(iTs.DateTime(2:window:Nt),time(1:window:(Nt-1)),'.-','LineWidth',2,'MarkerSize',15);
        catch
            'hola'
        end
    end
end
ax = gca;
ax.FontSize = 21;

grid on
title('$\Delta t (hours)$','Interpreter','latex','FontSize',21)
box
end

