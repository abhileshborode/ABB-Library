% dhFwdKine: Returns the forward kinematics of a manipulator with the provided DH parameter
%linkList is to be an array of links, each created by
% createLink
% paramList is to be an array containing the current
% state of their joint variables.
% H = dhFwdKine(linkList, paramList) Returns the forward kinematics of a manipulator 
% with the provided DH parameter set

% output1 = H ( homogenous transformation matrix 4-by-4)
%
% input1 = linkList is to be an array of links each created by createLink
% function 
% input2 = paramList is to be an array containing the current state of their joint variables
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function H = dhFwdKine(linkList, paramList)
N = length(linkList)
H = eye(4);

% calculating the homogenous transformation matrix based upon either rotary or prismatic joint
% if rotary is true then its rotary joint and paramList will be equal to
% theta else it will be equal to d

for i = 1:N
    if linkList(i).isRotary == true
        H = H*dhTransform(linkList(i).a,linkList(i).d,linkList(i).alpha,paramList(i));
    else
        H = H*dhTransform(linkList(i).a,paramList(i),linkList(i).alpha,linkList(i).theta);
    end
end
% for i = 1:N-1
%     if i == 1
%         K = H1(:,:,1);
%         H = K*H1(:,:,2);
%     else
%         K = H*H1(:,:,i+1);
%         H = K;
%     end
% end
end

