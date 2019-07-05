% twist2Transform: Returns the homogenous transformation matrix corresponding 
% to a 6 element twist vector. 
%
% [ H ] = twist2Transform( t ) for a given 6-by-1 twist vector stacked
% as[v;w th] the resulting functions returns a homogenous tranformation
% matrix of 4-by-4 with rotation and displacement calculated seperately
%
% output1 = 4-by-4 homogenous tranformation matrix
% output2 = description of what the second output is/means include units if appropriate
%
% input1 = 6-by-1 twist vector stacked as[v;w th] 
% input2 = description of what the second input is/means include units if appropriate 
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [ H ] = twist2Transform( t )

%separting the v and w vector
v=t([1 2 3]);
w=t([4 5 6]);
% Special case if there is no rotation i.e. w vector is zero then theta=0 
% else theta=norm(w)
if w == 0 
    theta=0
    else
	theta  = norm(w) % calculate theta
    w=w./theta % gives w hat 
    end
		if theta==0
            R=eye(3)  %roation matrix = 3-by-3 identity matrix
            d=v % d is equal to v for no ratation
        else
            %if theta jot equal to 0,calculate skew symmetric of w vector
            w_x=[0,-w(3),w(2); 
    w(3),0,-w(1);
    -w(2),w(1),0]
l=(1-cos(theta)) 
    R=cos(theta).*eye(3)+sin(theta).*w_x+(l.*(w*w')) %3-by-3 rotation matrix using w_x,w and theta
    d=((eye(3)-R)*w_x+w*w'.*theta)*v % 3-by-1 displacement matrix 
        end
        H=[R,d];
H=[H;[zeros(1,3),1]]  %getting a 4-by-4 homogenous transformation matrixfor the twist vector
end

