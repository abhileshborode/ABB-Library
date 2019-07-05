% dhInvKine: Returns the parameter list necessary to achieve a desired homogenous transform 
% and the residual error in that transform.
% 
% [paramList, error] = dhInvKine (linkList, desTransform, paramListGuess)
% 
% output1 = residual error in the transform
% output2 = parameter list necessary to achieve desired homogenous transform
%
% input1 = linkList(the list of joint parameters created with createLink)
% input2 = desired homogenous transform(4-by-4)
% input3 = paramListGuess(initial guess at the parameters)

% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [paramList, error] = dhInvKine( linkList,desTransform, paramListGuess)
N = length(linkList);
%% initializing
d_q = ones(N,1);
d_e = zeros(6,1);
de_w = zeros(3,1);
de_p = zeros(3,1);
error = 1;
restarts = 0;
iteration = 0;

paramList = paramListGuess;
%% getting the desired position and orientation
P_d = desTransform(1:3,4);
R_d = desTransform(1:3,1:3);

while error > 1e-15 && restarts < 100
if iteration < 300
        % getting current position and orientation
    T_c = dhFwdKine(linkList, paramList);
    R_c = T_c(1:3,1:3);
    P_c = T_c(1:3,4);
    [k,theta] = rot2AngleAxis( R_c'*R_d );
    if theta == 0
        k = [0; 0; 0;];
    end
    % calacualting the error from curreent and desired values
    de_w = R_c*k*theta;
    de_p = P_d  - P_c;
    d_e = [de_p;de_w;];
   
    % finding Jv from velocity jacobian and calaculating its inverse from
    %
   % Pseudo 
    Jv = velocityJacobian(linkList, paramList);
    [U, S, V] = svd(Jv);
    [r, c] = size(S);
    maxS = max(S);
    Inv_s = zeros(size(S));
    for i = 1:r
        if S(i,i)< maxS(1)/500
            Inv_s(i,i) = 0;
        else
            Inv_s(i,i) = 1/S(i,i);
        end
    end
    Jvinv = V*Inv_s'*U';
    %calculates
    d_q = Jvinv*d_e;
    paramList = paramList + d_q;
    error = max(abs(d_e));
    iteration = iteration + 1;
elseif restarts < 98
    for j = 1:N
        if linkList(j).isRotary == 1
            paramList(j) = rand(1,1)*2*pi;
        else
            paramList(j) = rand(1,1)*100 - 50;
        end
    end 
    iteration = 1;
    restarts = restarts + 1;
else
    restarts = restarts + 1;
end

error = max(abs(d_e)); %% calculating the max of the absolute value of error
end
end

