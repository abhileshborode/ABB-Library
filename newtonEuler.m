% FUNCTION NAME : newtonEuler
% DESCRIPTION   : This function computes the inverse dynamics of a serial link manipulator
%                 and provides the velocity jacobian and its rate of change.
%
% OUTPUT        : The output gives the the joint torques at each joint,
%                 velocity Jacobian and time derivative of velocity
%                 Jacobian.
%
% INPUT         : The inputs are a list of joint parameters created
%                 with createLink,the the current joint angles/distances,
%                 the current joint angle/distance speeds,
%                 the current joint angle/distance accelerations and
%                 the boundary conditions corresponding to angular
%                 velocity, angular acceleration, linear acceleration,
%                 force and torque.
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [jointTorques, Jv, JvDot] = newtonEuler( linkList, paramList, paramListDot, paramListDDot, boundary_conditions )

a = zeros(6,1);
d = zeros(6,1);
alpha = zeros(6,1);
theta = zeros(6,1);
isRotary = zeros(6,1);
theta_dot = zeros(6,1);
theta_ddot = zeros(6,1);
d_dot = zeros(6,1);
d_ddot = zeros(6,1);
J_Inertia = zeros(3,3,6);
J = zeros(3,3,6);
rcom = zeros(3,6); %% com of the link with respect to link
rcom_base = zeros(3,6); %% com of the link with respect to base
m_link= zeros(6,1); %% mass of lik
jointTorques = zeros(6,1);
%% paramlistdot and paramlistddot
for i = 1:6
    a(i) = linkList(i).a;
    alpha(i) = linkList(i).alpha;
    isRotary(i) = linkList(i).isRotary;
    J_Inertia(:,:,i) = linkList(i).inertia;
    rcom(:,i) = linkList(i).com;
    m_link(i) = linkList(i).mass;
       
    if isRotary(i) == 0                    
        theta(i) = linkList(i).theta;
        d(i) = paramList(i);
        d_dot(i) = paramListDot(i);
        d_ddot(i) = paramListDDot(i);
    else              
        d(i) = linkList(i).d;
        theta(i) = paramList(i);
        theta_dot(i) = paramListDot(i);
        theta_ddot(i) = paramListDDot(i);
    end

end
T = zeros(4,4,6);
dd = zeros(3,7);
Z = zeros(3,6);
for i = 1:6
    T(:,:,i) = zeros(4,4)
end
Z = zeros(3,6);
w = zeros(3,7);
dd = zeros(3,7);
dd_dot = zeros(3,7);
dd(:,1:1) = [0; 0; 0];
Z(:,1) = [0 0 1];
H = eye(4);
for i = 1:6
    T(:,:,i)=H*dhTransform(a(i),d(i),alpha(i),theta(i));
    H = T(:,:,i); 
end
for i = 2:7
    dd(:,i:i) = T(1:3,4:4,i-1);
    Z(:,i) = T(1:3,3:3,i-1);
    R(:,:,i-1) = T(1:3,1:3,i-1)
end
for i = 1:6
    J(:,:,i) = R(:,:,i)*J_Inertia(:,:,i)*R(:,:,i).';
end
w = zeros(3,7);
w(:,1) = boundary_conditions(1).base_angular_velocity;
for i = 2:7
    if isRotary(i-1) == 1 
        w(:,i) = w(:,i-1) + theta_dot(i-1)*Z(:,i-1);
    elseif isRotary(i-1) == 0 
        w(:,i) = w(:,i-1);
    end
end
w_dot = zeros(3,7);
w_dot(:,1:1) = boundary_conditions(1).base_angular_acceleration;

if isRotary(1) == 1 
    w_dot(:,2) = w_dot(:,1) + theta_ddot(1)*Z(:,1) + cross(w(:,1),Z(:,1));
else
    w_dot(:,2) = w_dot(:,1);
end
for i = 3:7
    if isRotary(i-1) == 1 
        w_dot(:,i) = w_dot(:,i-1) + theta_ddot(i-1)*Z(:,i-1) + cross(w(:,i-1),w(:,i));
    else
        w_dot(:,i) = w_dot(:,i-1);
    end
end
dd_dot(:,1:1) = [0; 0; 0];
for i = 2:7
    if isRotary(i-1) == 1 
        dd_dot(:,i) = dd_dot(:,i-1) + cross(w(:,i),(dd(:,i)-dd(:,i-1)));
    elseif isRotary(i-1) == 0 
        dd_dot(:,i) = dd_dot(:,i-1) + cross(w(:,i),(dd(:,i)-dd(:,i-1))) + d_dot(i-1)*Z(:,i-1);
    end 
end
dd_ddot = zeros(3,7);
dd_ddot(:,1:1) = boundary_conditions(1).base_linear_acceleration;

for i = 2:7
    if isRotary(i-1) == 1 
        dd_ddot(:,i:i) = dd_ddot(:,i-1) + cross(w_dot(:,i),(dd(:,i)-dd(:,i-1))) + cross(w(:,i),cross(w(:,i),(dd(:,i)-dd(:,i-1))));
    elseif isRotary(i-1) == 0 
        dd_ddot(:,i:i) = dd_ddot(:,i-1) + cross(w_dot(:,i),(dd(:,i)-dd(:,i-1))) + cross(w(:,i),cross(w(:,i),(dd(:,i)-dd(:,i-1)))) + d_ddot(i-1)*Z(:,i-1) + cross(2*d_dot(i-1)*w(:,i-1),Z(:,i-1));
    end
end
rcom_base = zeros(3,6);
for i = 1:6
    rcom_base(:,i:i) = R(:,:,i)*rcom(:,i:i);
end

rcom_base_dot = zeros(3,6);
for i = 1:6
    if isRotary(i) == 1 
        rcom_base_dot(:,i) = dd_dot(:,i) + cross(w(:,i+1),rcom(:,i));
    else 
        rcom_base_dot(:,i) = dd_dot(:,i) + cross(w(:,i+1),rcom(:,i)) + d_dot(i)*Z(:,i);
    end
end

rcom_base_ddot = zeros(3,6);

for i = 1:6
    if isRotary(i) == 1 
        rcom_base_ddot(:,i) = dd_ddot(:,i) + cross(w_dot(:,i+1),(dd(:,i+1)-dd(:,i)+rcom_base(:,i))) + cross(w(:,i+1),cross(w(:,i+1),(dd(:,i+1)-dd(:,i)+rcom_base(:,i))));
    else
        rcom_base_ddot(:,i) = dd_ddot(:,i) + cross(w_dot(:,i+1),(dd(:,i+1)-dd(:,i)+rcom_base(:,i))) + cross(w(:,i+1),cross(w(:,i+1),(dd(:,i+1)-dd(:,i)+rcom_base(:,i)))) + cross(2*w(:,i),d_dot(i)*Z(:,i)) + d_ddot(i)*Z(:,i);
    end
end
f = zeros(3,7);
f(:,7) = boundary_conditions(1).distal_force;
n = zeros(3,7);
n(:,7) = boundary_conditions(1).distal_torque;
for i = 6:-1:1
    f(:,i:i) = f(:,i+1) + m_link(i)*rcom_base_ddot(:,i);
    n(:,i:i) = n(:,i+1) + cross(dd(:,i+1)-dd(:,i)+rcom_base(:,i),f(:,i)) + J(:,:,i)*w_dot(:,i+1) + cross(w(:,i+1),J(:,:,i)*w(:,i+1)) - cross(rcom_base(:,i),f(:,i+1));
    if isRotary(i) == 1 
        jointTorques(i,1) = Z(:,i).'*n(:,i);
    else
        jointTorques(i,1) = Z(:,i).'*f(:,i);
    end
end

[Jv,JvDot] = velocityJacobian(linkList,paramList,paramListDot);
end
