% rotZ : Returns a rotation matrix for rotation about Z axis 
% 
% R = rotZ(theta) Returns a rotation matrix describing a rotation about 
% the Z axis (theta in radians).
% 
% output1 = 3-by-3 rotation matrix 
% output2 = description of what the second output is/means include units if appropriate 
% 
% input1 = theta represent a rotation about Z in radians
% input2 = description of what the second input is/means include units if appropriate 
% 
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function R = rotZ(theta)
    R=[cos(theta),-sin(theta),0;sin(theta),cos(theta),0;0,0,1] %rotation matrix about Z axis
end