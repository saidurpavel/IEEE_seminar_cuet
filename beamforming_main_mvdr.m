clear
close all
clc
set(0,"DefaultAxesFontSize",18)
% This code is for MVDR beamforiming using ULA



N = 10;           % number of antennas
array = 0:N-1;   % antenna locations

T = 1000;        % Number of snapshots
Theta_d = 0;     % desired signal
Theta_j = [30,10];    %  interference
n_source = length(Theta_d); % Number of desired signals
n_int = length(Theta_j);    % Number of interference

SNR_dB = 10;            % SNR in dB
SNR = 10^(SNR_dB/10);   % SNR in linear scale

INR_dB = 30;            % INR in dB
INR = 10^(INR_dB/10);   % INR in linear scale


% Desired signal
Sd =  (sqrt(SNR/2)).*(randn(n_source,T)+1j*randn(n_source,T)); % Impinging random signal
Ad = steer(Theta_d,array);  % Steering matrix for desired signal
Xd = Ad*Sd;  % Array signal for desired signal


% Noise
Noise = (sqrt(1/2))*(randn(N,T)+1j*randn(N,T)); % Noise

% Interference
Sj =  (sqrt(INR/2)).*(randn(n_int,T)+1j*randn(n_int,T)); % Impinging Interference
Aj = steer(Theta_j,array); % Steering matrix for interference
Xj = Aj*Sj; % Array signal for interference

X = Xd + Xj + Noise; % Total signal
R = (1/T)*(X*X');    % covariance matrix

zeta = 0;   % Diagonal loading parameter
R_loaded = R+zeta*eye(size(R));     % Diagonal loaded cov matrix
invR = inv(R_loaded);
w = invR * Ad/ (Ad' * invR * Ad);   % MVDR weights


%  ----------- Calculation SINR -----------
% Output waveforms
yd = (w'*Xd);
yj = (w'*Xj);
yn = (w'*Noise);

% Powers
Pd = (yd*yd')/T;
Pj = (yj*yj')/T;
Pn = (yn*yn')/T;

% SINR
sinr = 10 * log10(Pd/(Pn+Pj));
fprintf("SINR = %g dB\n",sinr)
% --------------------------------------------

% plotting array pattern
theta_r = -90:90;
for ii=1:length(theta_r)
    a = steer(theta_r(ii),array);
    p(ii) = abs(w'*a);    
end
p = abs(p)./max(abs(p));
xline(Theta_d,"r","LineWidth",2)
hold on
xline(Theta_j,"k","LineWidth",2)

plot(theta_r,p)
xlabel('Angle of arrival (degree)')
ylabel('Normalized array pattern')
ylim([0 1])
legend({"Desried signal location","Interference location","array pattern"},"Location","best")




