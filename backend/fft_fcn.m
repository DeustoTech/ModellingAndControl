function fft_fcn(f,date,dt,thold,Parent)
%%
t = minutes(date-date(1));
%
% remove mean 
fmean = mean(f);
f = f - fmean;
%% Compute the Fast Fourier Transform FFT
n = length(t);
fhat = fft(f,n);       % Compute the fast Fourier transform
PSD = fhat.*conj(fhat)/n; % Power spectrum (power per freq)
freq = 1/(dt*n)*(0:n); % Create x-axis of frequencies in Hz
L = 1:floor(n/2);   % Only plot the first half of freqs

%% Use the PSD to filter out noise
indices = PSD>thold;  % Find all freqs with large power
PSDclean = PSD.*indices;  % Zero out all others
fhat = indices.*fhat;  % Zero out small Fourier coeffs. in Y
ffilt = ifft(fhat); % Inverse FFT for filtered time signal

%% PLOTS
%
subplot(1,2,1,'Parent',Parent)
plot(date,f+fmean,'k.','LineWidth',1.5), hold on
plot(date,ffilt+fmean,'-b','LineWidth',1.2)
legend('Clean','Filtered')
ylim([0 50])
%
subplot(1,2,2,'Parent',Parent)
plot(freq(L),PSD(L),'r','LineWidth',1.5), hold on
plot(freq(L),PSDclean(L),'-.b','LineWidth',1.2)
legend('Noisy','Filtered')



% 
% %% PLOTS
% subplot(3,1,1)
% plot(t,y,'r','LineWidth',1.2)
% hold on
% plot(t,x,'k','LineWidth',1.5)
% axis([0 .25 -5 5])
% legend('Noisy','Clean')
% 
% subplot(3,1,2)
% plot(t,x,'k','LineWidth',1.5)
% hold on
% plot(t,yfilt,'b','LineWidth',1.2)
% axis([0 .25 -5 5])
% legend('Clean','Filtered')
% 
% subplot(3,1,3)
% plot(freq(L),PSD(L),'r','LineWidth',1.5)
% hold on
% plot(freq(L),PSDclean(L),'-b','LineWidth',1.2)
% legend('Noisy','Filtered')

end

