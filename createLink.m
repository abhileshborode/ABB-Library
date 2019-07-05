% createLink: Creates a structure with the input given below
%
% L = createLink(a,d,alpha,theta,centOfMass,mass,inertia) creates a
% structure L the following input elements.
% 
% output1 = L( Structure) 
%
% input1 = a – DH parameter a (meters)
% input2 =d – DH parameter d (meters)
% input3 = alpha – DH parameter alpha (radians)
% input4 = theta – DH parameter theta (radians)
% input5 = mass – link mass (kg)
% input6 = inertia – link mass moment of inertia (kg m^2)
% input7 = com – the position of the link’s center of mass
% input8 = isRotary – Boolean true if it is a rotary joint false if it is a prismatic joint.
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function L = createLink(a,d,alpha,theta,centOfMass,mass,inertia)
% assigning the isRotary initially to zero
isRotary=0;
L.a=a;
L.d=d;
L.alpha=alpha;
L.theta=theta;
L.com=centOfMass;
L.mass=mass;
L.inertia=inertia;
%% if theta=0 then its prismatic joint else rotary and based upon that pass empty array
if theta==0
    isRotary==0;
    L.d=[];

else
    isRotary==1;
    L.theta=[];
end

