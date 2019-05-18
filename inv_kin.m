function [l0, theta1, theta2, ERR] = inv_kin(x, y, z, a2, a3)  
    ERR    = 0;
    l0     = 0;
    theta1 = 0;
    theta2 = 0;
    
    theta2M = [acos((x^2 +y^2 -a2^2 -a3^2)/(2*a2*a3)) -acos((x^2+y^2-a2^2-a3^2)/(2*a2*a3))];
    gama   = acos((a2^2+x^2+y^2-a3^2)/(2*a2*sqrt(x^2+y^2)));
    %theta2[atan2(imag(theta2M(1)), real(theta2M(1))), atan2(imag(theta2M(2)),real(theta2M(2)))];
    theta1M = [pi/2-gama+atan2(-y,x) pi/2+gama+atan2(-y,x)];
    %theta1M = [atan2(imag(theta1M(1)),real(theta1M(1))), atan2(imag(theta1M(2)),real(theta1M(2)))];
    %theta2 correction
    theta2M = theta2M - 3/5*theta1M;
    
    l0 = z;
    
    if (theta1M(1)*57.2957795 > -35) && (theta1M(1)*57.2957795 < 90)  
        theta1 = theta1M(1);
        theta2 = theta2M(1);
    elseif (theta1M(2)*57.2957795 > -35) 
        theta1 = theta1M(2);
        theta2 = theta2M(2);
    else
        ERR = 1;
    end
    
    if (l0>5.5 || l0<0)
        ERR = 1;
    end 
   
end