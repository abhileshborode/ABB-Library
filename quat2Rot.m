% quat2Rot: Returns a rotation matrix for a given quaternion
%
% R = quat2Rot(Q)) Given a 1-by-4 quaternion in the form of [q_0 q_1 q_2
% q_3] the given function returns a rotaton matrix R
%
% output1 = 3-by-3 roation matrix R
% output2 = description of what the second output is/means include units if appropriate
%
% input1 =  1-by-4  quaternion with first term being the scalar
% input2 = description of what the second input is/means include units if appropriate 
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function R = quat2Rot(Q)
R=[1-2*Q(3)^2-2*Q(4)^2,      2*Q(2)*Q(3)-2*Q(1)*Q(4),    2*Q(2)*Q(4)+2*Q(1)*Q(3);
    2*Q(2)*Q(3)+2*Q(1)*Q(4),          1-2*Q(2)^2-2*Q(4)^2,     2*Q(3)*Q(4)-2*Q(1)*Q(2);
    2*Q(2)*Q(4)-2*Q(1)*Q(3),      2*Q(3)*Q(4)+2*Q(1)*Q(2),         1-2*Q(2)^2-2*Q(3)^2]
% rotation matrix in terms of quaternion 
end

