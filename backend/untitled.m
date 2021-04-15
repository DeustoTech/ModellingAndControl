clear all, close all, clc
%% Create a simple signal with two frequencies
dt = .001;
t = 0:dt:1; 
f = sin(2*pi*50*t) + sin(2*pi*120*t); % Sum of 2 frequencies
f = f + 2.5*randn(size(t));  %  Add some noise

fft_fcn(f,t,dt)