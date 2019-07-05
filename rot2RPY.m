% rot2RPY: Returns the roll ,pitch & yaw for the end effector for the given
% rotation matrix
%
% [roll, pitch, yaw] = rot2RPY(R) Provides us the roll,pitch and yaw angle
% for a 3-by-3 input roation matrix with a special case of pitch=pi/2
%
% output1 = 2-by-1 Roll in radian for the end effector 
% output2 = 2-by-1 Pitch in radian for the end effector
% output3 = 2-by-1 Yaw in radian for the end effector
%
% input1 = 3-by-3 rotation matrix 
% input2 = description of what the second input is/means include units if appropriate 
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018
function [roll, pitch, yaw] = rot2RPY(R)
m=sqrt(R(1,1)^2+R(2,1)^2);
n=-(sqrt(R(1,1)^2+R(2,1)^2));

%pitch P1 and P2 for positive and negative square root
P1=atan2(-R(3,1),m);
P2=atan2(-R(3,1),n);

% for special case check pitch = pi/2
if P1==pi/2 || P2==pi/2
    P=[P1,P1];
pitch=P(:) %returs pitch in terms of 2-by-1 vector

%if pitch=pi/2 then we can calculate sum of roll and yaw. 
%here we consider yaw =0 and calculate the value of roll for this special
%case using the matrix element 

    Y1=0; 
    Y=[Y1,Y1]; 
    yaw=Y(:) %returs yaw in terms of 2-by-1 vector
    R1=-atan2(R(1,2),R(2,2));
    R=[R1,R1];
    roll=R(:) %returs roll in terms of 2-by-1 vector
   
else    
P=[P1,P2];
pitch=P(:)

% two values of yaw for different pitch angles i.e. P1 and P2
Y1=atan2(R(3,2)/cos(P1),R(3,3)/cos(P1)); 
Y2=atan2(R(3,2)/cos(P2),R(3,3)/cos(P2));
Y=[Y1,Y2];
yaw=Y(:) %returs yaw in terms of 2-by-1 vector

% two values of roll for different pitch angles i.e. P1 and P2
R1=atan2(R(2,1)/cos(P1),R(1,1)/cos(P1));
R2=atan2(R(2,1)/cos(P2),R(1,1)/cos(P2));
R=[R1,R2];
roll=R(:) %returs roll in terms of 2-by-1 vector
end

end
