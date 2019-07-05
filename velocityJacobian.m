% velocityJacobian: Returns the velocity jacobian of the manipulator given an array of links created by the createLink function
% and the current joint variables
% Jv – the velocity jacobian
% Jv – the velocity jacobian
% JvDot – the time derivative of the velocity jacobian
% linkList – the list of joint parameters created with
% createLink
% paramList – the current theta or d values for the
% joints. (an Nx1 array)
% paramRateList – the current theta_dot and d_dot
% values for the joints. (an Nx1 array)
% If paramRateList is not provided (check with
% exist(‘paramRateList’,’var’) ), then return [] for
% JvDot. Otherwise calculate JvDot as well.

% [Jv, JvDot] = velocityJacobian( linkList, paramList, paramRateList) Returns the forward kinematics of a manipulator 
% with the provided DH parameter set

% output1 = velocity jacobian
% output2 = time derivative of the velocity jacobian
%
% input1 = linkList(the list of joint parameters created with createLink)
% input2 = paramList(the current theta or d values for the joints(Nx1 array))
% input3= paramRateList(the current theta_dot and d_dot values for the joints(Nx1 array))

% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [Jv, JvDot] = velocityJacobian( linkList, paramList, paramRateList)
%% setting up initial structure for all the values
a = zeros(6,1);
d = zeros(6,1);
alpha = zeros(6,1);
theta = zeros(6,1);
isRotary = zeros(6,1);
d_dot = zeros(6,1);
theta_dot = zeros(6,1);

for i = 1:6
    a(i) = linkList(i).a;
    alpha(i) = linkList(i).alpha;
    isRotary(i) = linkList(i).isRotary;
% conditon for rotary or prismatic joint
if isRotary(i) == 0                     
        theta(i) = linkList(i).theta;
        d(i) = paramList(i);
        if exist('paramRateList','var')
            d_dot(i) = paramRateList(i);
        end
    else           
        d(i) = linkList(i).d;
        theta(i) = paramList(i);
        if exist('paramRateList','var')
            theta_dot(i) = paramRateList(i);
        end
    end
end

for i = 1:6
    T(:,:,i) = zeros(4,4)
end
%%  initailizing the values for T,d and Z
dd = zeros(3,7);
Z = zeros(3,6);
w = zeros(3,7);
dd_dot = zeros(3,7);
 H = eye(4);
 % calculating the final T matrix i.e T01,T02 etc....
for i = 1:6
    T(:,:,i)=H*dhTransform(a(i),d(i),alpha(i),theta(i));
    H = T(:,:,i);
end
% setting the initail values for d,z,w,ddot to zero   
dd(:,1:1) = [0; 0; 0];
Z(:,1) = [0 0 1];
w(:,1:1) = [0; 0; 0];
dd_dot(:,1:1) = [0; 0; 0];
%% calculating the linear and angular velocity
for i = 2:7
    dd(:,i:i) =  T(1:3,4:4,i-1);
    Z(:,i) = T(1:3,3:3,i-1);
    if isRotary(i-1) == 1 
        w(:,i) = theta_dot(i-1)*Z(:,i-1)+w(:,i-1);
    else
        w(:,i) = w(:,i-1);
    end
    if isRotary(i-1) == 1 
        dd_dot(:,i) = dd_dot(:,i-1) + cross(w(:,i),(dd(:,i)-dd(:,i-1)));
    else 
        dd_dot(:,i) = dd_dot(:,i-1) + cross(w(:,i),(dd(:,i)-dd(:,i-1))) + d_dot(i-1)*Z(:,i-1);
    end
    
end

%% calculating the velocity jacobain(Jv) for the rotary or prismatic joint
for i = 1:6
    if isRotary(i) == 1          
        Jv(1:3,i:i) = cpMap(Z(:,i))*(T(1:3,4,6)-dd(:,i));
        Jv(4:6,i:i) = Z(:,i);
    else   
        Jv(1:3,i:i) = Z(:,i);
        Jv(4:6,i:i) = [0; 0; 0];
    end
end

%% calculating the derivative of  velocity jacobain(JvDot) for the rotary or prismatic joint based 
% upon the paramRateList if given or not

JvDot = zeros(6,6)
if exist('paramRateList','var')
    for i = 1:6;
        if isRotary(i) == 1             % Rotary
            JvDot(:,i) = [cross(cross(w(:,i),Z(:,i)),(dd(:,7)-dd(:,i)))+cross(Z(:,i),dd_dot(:,7)-dd_dot(:,i)); cross(w(:,i),Z(:,i))];
        else       % Prismatic
            JvDot(:,i) = [cross(w(:,i),Z(:,i)); 0; 0; 0];
        end
    end
else
    JvDot = []; % empty value for JvDot if no third input value
end
end