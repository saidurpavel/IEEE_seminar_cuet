function [P,DOA_est]  =music(R,array,n_source,stp)

%------------------------------------------------------------------------------------------------%
% music_d(R,array,n_source,stp) provides MUSIC spectra
%
% Inputs:
% R: Covariance matrix
% array: Antenna locations
% n_source: number of sources
% stp: resolution (default 1)
%
% Return P: Normalized Pseduspectrum of MUSIC algorithm
%------------------------------------------------------------------------------------------------%

% Extracting the variables from the structure

if nargin < 4
    stp = 1;
end

theta_r = -90:stp:90;  % range of angles


% Making sure arrays as column vectors
if isrow(array)
    array1 = array.';
end

[V,Lam] = eig(R);          % Eigendecomposition of R
[lambdas,idx] = sort(abs(diag(Lam)),'descend');  % Sorting the eigenvalues low to high
V = V(:,idx); % sorting the eigen vectors corresponding to eigen values

% First n_source eigen vector construct the signal subspce and rest of
% them construct the noise subspace

Vn = V(:,n_source+1:end);   % Noise subspace

P = zeros(1,length(theta_r));  % Initialization of MUSIC pseudo spectrum

for m = 1:length(theta_r) % scanning through all angles to see where peak is appeared

    A_s = steer(theta_r(m),array);
    P(m) = 1/(A_s'*(Vn*Vn')*A_s);   % MUSIC pseudo spectrum
end

P = abs(P)./max(max(abs(P)));
DOA_est = peak_location(P,n_source,-90:stp:90);   % Estimated DOA


end