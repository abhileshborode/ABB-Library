% twist2Transform: Returns the twist vector corresponding to the provided homogenous
% transform matrix. 
%
% [ t ]= transform2Twist( H ) for a given 4-by-4 homogenous tranformation matrix 
%  the resulting functions returns a 6-by-1 twist vector stacked
% as[v;w th] and v and w calculated seperately
%
% output1 = 6-by-1 twist vector stacked as[v;w th] 
% output2 = description of what the second output is/means include units if appropriate
%
% input1 = 4-by-4 homogenous tranformation matrix
% input2 = description of what the second input is/means include units if appropriate 
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [ t ]= transform2Twist( H )
% seperating R and d matrix from H
 R = H(1:3,1:3)
 d = H(1:3,4)
theta=acos((R(1,1)+R(2,2)+R(3,3)-1)/2) % theta calculation
%special cased if theta=o then v=d and w=0 vector 
if theta==0
v=d;
w=[zeros(3,1)]
t=[v;w]
else
    %if theta not equal to 0 then w vector is calulated as below using
    %theta value
w1=(R(3,2)-R(2,3))/(2*sin(theta))
w2=(R(1,3)-R(3,1))/(2*sin(theta))
w3=(R(2,1)-R(1,2))/(2*sin(theta))

w=[w1,w2,w3];
w=w(:)
w_x=[0,-w(3),w(2);
    w(3),0,-w(1);
    -w(2),w(1),0]
v=inv(((eye(3)-R)*w_x+theta*w*w'))*d % v vector calculated using R and d
omega=w.*theta % twist vector is v and omega ,where omega=w*theta
t=[v;omega] %6-by-1 twist vector
end
end

