function P = mvdr_doa(R,array,stp)
% This function estimate MVDR spectrum for DOA estimation consider ULA
%
% Input:
    % R: covariance matrix
    % array: sensor locations
%
% Output: 
    % p: power spectrum
    % DOA_est = estimated DOAs


if nargin < 3
    stp  = 1;
end


index=0;
for ii=-90:stp:90
    index=index+1;

    aa = steer(ii,array);
    P(index) = real(1 / (aa'*inv(R)*aa));

end
P = abs(P)./max(max(abs(P)));
end