% constAccelInterp(t,trajectory,transPercent) % trajectory
% using constant acceleration approach.
% 
%  [p,v,a] = constAccelInterp(t,trajectory,transPercent) returns the
%  position, velocity and the acceleration at tiime t for a trajectory
%  interpolated using constant acceleration approach.
% p = position
% v = velocity
% a = acceleration
% t = time at which the position, velocity and acceleration is to be found
% trajectory = matrix with time and positions of the trajectory
% transPercent = signifies order of the trajectory i.e whether the trajectory is linear/quadratic.
% 

% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [p,v,a] = constAccelInterp(t,trajectory,transPercent)
t1=trajectory(:,1);
[m,n]=size(trajectory);


for i=1:m-1
    tau(i)=transPercent*(t1(i+1)-t1(i));
end
tau(m)=tau(m-1);

for j=2:n
    pos(:,j)=trajectory(:,j);
    for i=2:m-1
        dp1=pos(i)-pos(i-1);
        dp2=pos(i+1)-pos(i);
        if i-1==1 && t>t1(i-1) && t<(t1(i-1)+tau(i-1))
            dp=pos(i)-pos(i-1);
            p(j-1)=pos(i-1,j)+(((t-t1(i-1)+tau(i-1))^2)*dp/(4*tau(i-1)*(t1(i)-t1(i-1))));
            a(j-1)=(1/(2*tau(i)))*(dp/(t1(i+1)-t1(i)));
            v(j-1)=(1/(2*tau(i)))*(dp*(t-t1(i)+tau(i))/(t1(i+1)-t1(i)));
            break;
        elseif i+1==m && t<t1(i+1) && t>(t1(i+1)-tau(i+1))
            dp=pos(i+1,j)-pos(i,j);
            p(j-1)=pos(i+1,j)+(((t-t1(i+1)-tau(i+1))^2)*dp/(4*tau(i+1)*(t1(i+1)-t1(i))));
            a(j-1)=(1/(2*tau(i+1)))*(dp/(t1(i+1)-t1(i)));
            v(j-1)=(1/(2*tau(i+1)))*(dp*(t-t1(i+1)-tau(i+1))/(t1(i+1)-t1(i)));
            break;
        elseif t<(t1(i)-tau(i)) && t>=(t1(i-1)+tau(i-1))
            dp1=pos(i,j)-pos(i-1,j);
            p(j-1)=pos(i,j)-(((t1(i)-t)/(t1(i)-t1(i-1)))*dp1);
            v(j-1)=dp1/(t1(i)-t1(i-1));
            a(j-1)=0;
            break;
        elseif t>(t1(i)+tau(i)) && t<=(t1(i+1)-tau(i+1))
            dp2=pos(i+1,j)-pos(i,j);
            p(j-1)=pos(i,j)+(((-t1(i)+t)/(t1(i+1)-t1(i)))*dp2);
            v(j-1)=dp2/(t1(i+1)-t1(i));
            a(j-1)=0;
            break;
        elseif t<=(t1(i)+tau(i)) && t>=(t1(i)-tau(i))
            dp1=pos(i,j)-pos(i-1,j);
            dp2=pos(i+1,j)-pos(i,j);
            p(j-1)=pos(i,j)-(((t-t1(i)-tau(i))^2)*dp1/(4*tau(i)*(t1(i)-t1(i-1))))+(((t-t1(i)+tau(i))^2)*dp2/(4*tau(i)*(t1(i+1)-t1(i))));
            v(j-1)=((dp2*(t-t1(i)+tau(i)))/(2*tau(i)*(t1(i+1)-t1(i))))-((dp1*(t-t1(i)-tau(i)))/(2*tau(i)*(t1(i)-t1(i-1))));
            a(j-1)=((dp2)/(2*tau(i)*(t1(i+1)-t1(i))))-((dp1)/(2*tau(i)*(t1(i)-t1(i-1))));
            break;
    end
end
end