% This code is for DOA estimation usnig uniform linear array(ULA)
% using MUSIC and MVDR algorithm

clear
close
clc
set(0, "DefaultAxesFontSize",18)

N = 10;          % Number of antennas
array = 0:N-1;   % Antenna locations 
D = 7;           % Number of signals

% Chossing some angles between -60 to 60 degree. 
% you can choose any angles you like

theta = linspace(-60,60,D);
A = steer(theta,array);      % Steering matrix

SNR_dB = 10;                 % SNR in dB
SNR = 10^(SNR_dB/10);        % SNR in lienar scale
T = 100;                     % Number of snapshots

s = sqrt(SNR/2)*(randn(D,T)+1j*randn(D,T)); % Impinging random signal
noise = sqrt(1/2)*(randn(N,T)+1j*randn(N,T)); % Noise

X = A*s+noise; % Array received signal

% X is generally known to us ( can be directly extract from the antenna
% array)
% Objective is to estimate the DOA information encompasses in X
% To do this first obtain the sample covariance matrix

R = (1/T)*(X*X');

% ------------ MUSIC based DOA -----------------------
[P,DOA_est] = music(R,array,D); % MUSIC based DOA

figure(1)
plot(-90:90,P);    % MUSIC Spectrum
xline(theta,'r--') % True DOAs
xlabel("Angle (degree")
ylabel(" MUSIC Spectrum")

% --------------- MDVR DOA ---------------------
P_mvdr = mvdr_doa(R,array);
figure(2)
plot(-90:90,P_mvdr);    % MUSIC Spectrum
xline(theta,'r--') % True DOAs
xlabel("Angle (degree")
ylabel("MVDR Spectrum")