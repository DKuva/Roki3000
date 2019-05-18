function V=norm_moment(img,k,j)

   img_cent=regionprops(img,'centroid');
   V=calculate_central_moment(img,img_cent(1).Centroid,[k j])/(calculate_central_moment(img,img_cent(1).Centroid,[0 0])^((k+j+2)/2));
   % m00=calculate_central_moment(img,img_cent(1).Centroid,[k k]);
   %v20=calculate_central_moment(img,img_cent(1).Centroid,[2 0])/(m00^2);
   %v02=calculate_central_moment(img,img_cent(1).Centroid,[0 2])/(m00^2);
   %v11=calculate_central_moment(img,img_cent(1).Centroid,[1 1])/(m00^2);
   % I=(v20-v02)^2 +(2*v11)^2;
end