% rpy2Rot: Returns a rotation matrix for the roll ,pitch & yaw of the end effector
%
% [ R ] = rpy2Rot (roll, pitch, yaw) Returns a 3-by-3 rotation matrix corresponding to 
% a roll, pitch, yaw encoded rotation.
%
% output1 = 3-by-3 rotation matrix 
% output2 = description of what the second input is/means include units if appropriate
%
% input1 = Roll in radian for the end effector about Z axis
% input2 = Pitch in radian for the end effector about Y axis
% input3 = Yaw in radian for the end effector about X axis
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [ R ] = rpy2Rot (roll, pitch, yaw)
R=[cos(roll)*cos(pitch),cos(roll)*sin(pitch)*sin(yaw)-sin(roll)*cos(yaw),cos(roll)*sin(pitch)*cos(yaw)+sin(roll)*sin(yaw);
    sin(roll)*cos(pitch),sin(roll)*sin(pitch)*sin(yaw)+cos(roll)*cos(yaw),sin(roll)*sin(pitch)*cos(yaw)-cos(roll)*sin(yaw);
    -sin(pitch),cos(pitch)*sin(yaw),cos(pitch)*cos(yaw)] %rotation matrix in terms of roll,
%pitch and yaw angles 

end


