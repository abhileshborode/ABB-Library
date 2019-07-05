% calculates the H

% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [ H ] = dhTransnew( a, d, alpha, theta, n, m)
F = zeros(4, 4, 1, length(a));
n = n+1;
H = eye(4);

for i = 1:length(a)
    F(:,:,1,i) = translationz(d(i))*(([1 0 0; 0 1 0; 0 0 1; 0 0 0]*rotZ(theta(i))*[1 0 0 0; 0 1 0 0; 0 0 1 0])+[0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 1])*translationx(a(i))*(([1 0 0; 0 1 0; 0 0 1; 0 0 0]*rotX(alpha(i))*[1 0 0 0; 0 1 0 0; 0 0 1 0])+[0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 1]);
end

for i = n:m
    H = H*F(:,:,1,i);
end
end