% transError returns a 6x1 vector, where the first 3
% elements are position error (desired - current),
% and the last three elements are an angle-axis
% representation of rotation error. Both
% expressed in the shared base frame.
% Td is the homogenious matrix describing the
% desired coordinate pose (of the robot for
% example) in the reference frame (of the world
% for example).
% Tc is the homogenious matrix describing the
% current coordinate frame (of the robot for
% example) in the reference frame (of the world
% for example).
% error_vector is a 6x1 vector describing the error
% ([pos_error;rot_error]) as expressed in the
% shared base frame.
% Abhilesh Borode
% 10830440
% MEGN 544 
% 18th Nov 2018

function [error_vector] = transError(Td, Tc) 
Rd (1:3,1:3) = Td(1:3,1:3);
Rc (1:3,1:3) = Tc(1:3,1:3);

pd = Td(1:3,4);
pc = Tc(1:3,4);

rot_error_vector = rotationError(Rd ,Rc);
pos_err = (pd-pc);

error_vector = [pos_err;rot_error_vector];
end







