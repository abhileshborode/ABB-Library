% angleAxis2Rot: Returns the rotation matrix encoded by a rotation of theta radians
% about the unit vector k axis.
%
% R = angleAxis2Rot(k, theta) Provides us the 3-by-3 roation matrix for the  angle 
% axis represenation for a rotation of theta about k vector 
%
% output1 = 3-by-3 rotation matrix
% output2 = description of what the second output is/means include units if appropriate
%
% input1 = Axis parameter i.e, k being 3-by-1 vector
% input2 = Angle parameter theta in radians 
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function R = angleAxis2Rot(k, theta)
I=eye(3,3);
S=[0,-k(3),k(2);k(3),0,-k(1);-k(2),k(1),0]; %3-by-3 skew symmetric matrix for vector k
R=I*cos(theta)+S*sin(theta)+k*transpose(k)*(1-cos(theta)) % rotation matrix in terms 
% of and theta 
end

