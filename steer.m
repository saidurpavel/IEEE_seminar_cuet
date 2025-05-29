function A = steer(theta,array,d)

%
% A = steer_s(theta,array,d) function provides the steering vector/ array
% manifold matrix. 
%
% Inputs:
        % theta: DOAs
        % array: antenna location, a column vecotr.   
        % d: Inter element spacing
              
%
% Return:
        %  A: Array manifold matrix
%

if nargin < 3
    d = 0.5;    % default interelement spacing
end



if isrow(array)
    array = array.';
end

if ~isrow(theta)
    theta = theta.';
end


A = exp(-1j*2*pi*d*array*sind(theta)); % Array manifold
