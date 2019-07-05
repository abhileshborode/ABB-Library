% rot2Quat: Returns a quaternion for a given rotation matrix. 
%
% Q = rot2Quat(R) Given a 3*3 rotaton matrix the given function generates
% a quaternion in the form of [q_0 q_1 q_2 q_3]
%
% output1 = 1-by-4  quaternion with first term being the scalar
% output2 = description of what the second output is/means include units if appropriate
%
% input1 =  3-by-3 roation matrix R 
% input2 = description of what the second input is/means include units if appropriate 
%
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function Q = rot2Quat(R)
Q_0=sqrt(R(1,1)+R(2,2)+R(3,3)+1)/(2); % Q_0 calulated using trace of R
% calculation of Q_vector i.e Q_1
q1=sqrt(1+R(1,1)-R(2,2)-R(3,3))/(2);
q2=sqrt(1-R(1,1)+R(2,2)-R(3,3))/(2);
q3=sqrt(1-R(1,1)-R(2,2)+R(3,3))/(2);

%Special case if Q_0 =0 and either one of Q_vector i.e Q_1 is 0
% As Q_0 is 0 we will check which one of element of Q_vector i.e Q_1 is the
% highest. We will use this highest vector element to calculate the values
% of remaining Q_vector i.e Q_1 element

% As Q_0=0 we can't use to calculate Q_vector i.e Q_1
if Q_0==0
    if q1>q2 & q1>q3
     Q_0=sqrt(R(1,1)+R(2,2)+R(3,3)+1)/(2);
     %q1 is highest ,so calculate q1 and use it to find q2 and q3
     q1=sqrt(1+R(1,1)-R(2,2)-R(3,3))/(2);
     
     q2=(R(1,2)+R(2,1))/(4*q1);
     q3=(R(1,3)-R(3,1))/(4*q1);
    Q_1=[q1,q2,q3];
    Q=[Q_0,Q_1];
    Q=Q(:) % 4-by-1 quaternion
    elseif q2>q3
        %q2 is highest ,so calculate q2 and use it to find q1 and q3
    Q_0=sqrt(R(1,1)+R(2,2)+R(3,3)+1)/(2);
    q2=sqrt(1-R(1,1)+R(2,2)-R(3,3))/(2);

    q1=(R(1,2)+R(2,1))/(4*q2);
    q3=(R(2,3)+R(3,2))/(4*q2);
    Q_1=[q1,q2,q3];
    Q=[Q_0,Q_1];
    Q=Q(:) % 4-by-1 quaternion
    else
        %q3 is highest ,so calculate q3 and use it to find q1 and q2
        Q_0=sqrt(R(1,1)+R(2,2)+R(3,3)+1)/(2); 
        q3=sqrt(1-R(1,1)-R(2,2)+R(3,3))/(2);
        
        q1=(R(1,3)+R(3,1))/(4*q3);
        q2=(R(2,3)+R(3,2))/(4*q3);
        Q_1=[q1,q2,q3];
        Q=[Q_0,Q_1];
        Q=Q(:) % 4-by-1 quaternion
    end
    
else
    %if Q_0 is not zero we'll calculte Q_vector i.e Q_1 element using Q_0
Q_0=sqrt(R(1,1)+R(2,2)+R(3,3)+1)/(2);
q1=(R(3,2)-R(2,3))/(4*Q_0);
q2=(R(1,3)-R(3,1))/(4*Q_0);
q3=(R(2,1)-R(1,2))/(4*Q_0);
Q_1=[q1,q2,q3];
Q=[Q_0,Q_1];
Q=Q(:) % 4-by-1 quaternion

end

end

