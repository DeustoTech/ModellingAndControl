function fftplot(ftab,dt,Parent)

    tspan = hours(ftab.DataTime - ftab.DataTime(1));
    f = ftab{:,:};
    clf
    %%
    subplot(4,1,1,'Parent',Parent)
    hold on
    plot(tspan(1:end),f(1:end),'.','MarkerSize',2)
    %
    uni_tspan = 0:dt:tspan(end);

    f = interp1(tspan,f,uni_tspan,'pchip');
    plot(uni_tspan,f,'-')
    %
    xlabel('Hours')
    grid on
    title(ftab.Properties.VariableNames)
    legend('real','interp')
    %%
    t = uni_tspan;        % Time vector
    n = length(t);        % Length of signal

    %
    fhat = fft(f,n);
    PSD = log(fhat.*conj(fhat)/n);
    freq = (1/(dt*n))*(0:n);
    %
    L = 1:floor(n/2);
    %
    subplot(4,2,3,'Parent',Parent);
    hold on
    grid on
    plot(freq(L),PSD(L)) 
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('log|P1(f)|')
    ylim([-15 15])
    %     [~,ind_sort] = sort(diff(smoothdata(P1,'SmoothingFactor',0.1)),'descend');
%     ind_sort = ind_sort+1;
%     % max 1
%     for i = 1:5
%         plot(freq(ind_sort(i)),P1(ind_sort(i)),'.','MarkerSize',15,'Color','r') 
%         text(freq(ind_sort(i)),P1(ind_sort(i)),"T = "+num2str(1/freq(ind_sort(i)),'%.1f')+"h" ) 
%     end 

    %%
    subplot(4,2,4,'Parent',Parent);
    hold on
    grid on
    ind = (PSD> 5)

    plot(freq(L),PSD(L).*ind(L)) 
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('log|P1(f)|')
    ylim([-15 15])


    %%
    subplot(4,1,3,'Parent',Parent)
    
    %
    uni_tspan = 0:dt:tspan(end);
    fclean =  real(ifft(fhat.*ind));
    hold on 
    plot(uni_tspan,f,'r-')

    plot(uni_tspan,fclean,'b-')

    %
    xlabel('Hours')
    grid on
    title(ftab.Properties.VariableNames)
    legend('f','f_{clean}')
    
    %%
    subplot(4,1,4,'Parent',Parent)
    hold on 
    plot(uni_tspan,f - fclean,'r-')
    plot(uni_tspan,f,'b-')
    legend('\Delta f','f')

    grid on
end

