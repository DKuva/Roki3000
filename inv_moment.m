function I2=inv_moment(img)
   %I1=norm_moment(img,2,0)+norm_moment(img,0,2);
   
   I2=(norm_moment(img,2,0)-norm_moment(img,0,2))^2 +(2*norm_moment(img,1,1))^2;
   %I3=(norm_moment(img,3,0)-3*norm_moment(img,1,2))^2 +(3*norm_moment(img,2,1)-norm_moment(img,0,3))^2;
   %I4=(norm_moment(img,3,0)+norm_moment(img,1,2))^2 +(norm_moment(img,2,1)+norm_moment(img,0,3))^2;
end