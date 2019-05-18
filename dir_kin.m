function [x, y, z] = dir_kin(l0, theta1, theta2, a2, a3)  
x = a2*sin(double(theta2-3/5*theta1))+a3*sin(double(theta1 + theta2-3/5*theta1));
y = a2*cos(double(theta2-3/5*theta1))+a3*cos(double(theta1 + theta2-3/5*theta1));
z = double(l0);
end