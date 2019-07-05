% rot2AngleAxis: Returns the angle and axis corresponding to a rotation matrix.
%
% [k, theta] = rot2AngleAxis(R) Provides us with an angle axis
% represenation for the 3-by-3 input roation matrix with a special case of
% theta=pi
%
% output1 = Axis parameter i.e, k being 3-by-1 vector
% output2 = Angle parameter theta in radians
%
% input1 = 3-by-3 rotation matrix 
% input2 = description of what the second input is/means include units if appropriate 
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [k, theta] = rot2AngleAxis(R)
theta=acos((R(1,1)+R(2,2)+R(3,3)-1)/2) % theta calculation

% Special case if theta=pi
if theta==pi
    k1=sqrt((R(1,1)+1)/2); %calculation of k for theta=pi
    k2=sqrt((R(2,2)+1)/2);
    k3=sqrt((R(3,3)+1)/2);
    k=[k1,k2,k3];
    k=k(:);
   else    
    k1=(R(3,2)-R(2,3))/(2*sin(theta)); % calculation of k with theta other than pi
    k2=(R(1,3)-R(3,1))/(2*sin(theta));
    k3=(R(2,1)-R(1,2))/(2*sin(theta));
    k=[k1,k2,k3];
    k=k(:);
end

end

