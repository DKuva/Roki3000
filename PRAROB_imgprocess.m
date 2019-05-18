function [radni_prostor_xy rad_obj_xy drop_prostor_xy drop_obj_xy]= PRAROB_ingprocess(img)

%whos img

% stats_radni_prostor(1).BoundingBox(1)=350; 
% stats_radni_prostor(1).BoundingBox(2)=22;
% stats_radni_prostor(1).BoundingBox(3)=657;
% stats_radni_prostor(1).BoundingBox(4)=724;
% 
% stats_drop_prostor(1).BoundingBox(1)=17;
% stats_drop_prostor(1).BoundingBox(2)=22;
% stats_drop_prostor(1).BoundingBox(3)=333;
% stats_drop_prostor(1).BoundingBox(4)=724;

stats_radni_prostor(1).BoundingBox(1)=679; 
stats_radni_prostor(1).BoundingBox(2)=22;
stats_radni_prostor(1).BoundingBox(3)=333;
stats_radni_prostor(1).BoundingBox(4)=724;

stats_drop_prostor(1).BoundingBox(1)=17;
stats_drop_prostor(1).BoundingBox(2)=22;
stats_drop_prostor(1).BoundingBox(3)=657;
stats_drop_prostor(1).BoundingBox(4)=724;

stats_tot_prostor(1).BoundingBox(1)=17;
stats_tot_prostor(1).BoundingBox(2)=22;
stats_tot_prostor(1).BoundingBox(3)=990;
stats_tot_prostor(1).BoundingBox(4)=724;

%parameters 
img_hsv=rgb2hsv(img);
hue_lower= 0;
hue_upper= 0.40;
sat_lower=0.1;
struct_element = strel('disk',5);

%%filtirranje zona na binarne like
diff_img_rad = imcrop(img,stats_radni_prostor(1).BoundingBox);
diff_img_rad = imsubtract(diff_img_rad(:,:,1),rgb2gray(diff_img_rad));
diff_img_rad = medfilt2(diff_img_rad, [5 5]);
diff_img_rad = imerode(diff_img_rad, struct_element);
diff_img_rad = im2bw(diff_img_rad,0.15);

diff_img_drop = imcrop(img_hsv,stats_drop_prostor(1).BoundingBox);
diff_img_drop = (diff_img_drop(:,:,3) > 0.7);
diff_img_drop = medfilt2(diff_img_drop);
diff_img_drop = imdilate(diff_img_drop, struct_element);
diff_img_drop = im2bw(diff_img_drop,0.18);
diff_img_drop = imcomplement(diff_img_drop);

%%obrada radnog prostora:
% stats_radni_prostor=regionprops(diff_img_rad,'BoundingBox','Centroid');
% stats_radni_prostor(1).BoundingBox
%%obrada drop prostora
% stats_drop_prostor=regionprops(diff_img_drop,'BoundingBox','Centroid');

%%proracun vrijednosti za konverziju iz [pix] koordinatnog sustava u traženi
%%koodrinatni sustav u [mm]
centar_pix_x=512; 
centar_pix_y=746; 

pix2mm_x=0.30;
pix2mm_y=0.30;

%obrada radnih objekata

stats_rad_obj=regionprops(diff_img_rad,'BoundingBox','Centroid');
rad_obj_xy=struct(stats_rad_obj);

for object = 1:length(stats_rad_obj) 
    rad_obj_xy(object).Centroid(1)=(stats_rad_obj(object).Centroid(1)+stats_radni_prostor(1).BoundingBox(1)-centar_pix_x)*pix2mm_x;
    rad_obj_xy(object).Centroid(2)=-(stats_rad_obj(object).Centroid(2)+stats_radni_prostor(1).BoundingBox(2)-centar_pix_y)*pix2mm_y;  
 
end 

%obrada drop lokacija


stats_drop_obj=regionprops(diff_img_drop,'BoundingBox','Centroid');
drop_obj_xy=struct(stats_drop_obj);

for object = 1:length(stats_drop_obj)   
    drop_obj_xy(object).Centroid(1)=(stats_drop_obj(object).Centroid(1)+stats_drop_prostor(1).BoundingBox(1)-centar_pix_x)*pix2mm_x;
    drop_obj_xy(object).Centroid(2)=-(stats_drop_obj(object).Centroid(2)+stats_drop_prostor(1).BoundingBox(2)-centar_pix_y)*pix2mm_y;

end 

%transformacija iz [pix] u [mm] i ispis na graf
radni_prostor_xy=stats_radni_prostor;
radni_prostor_xy(1).BoundingBox(1)=(stats_radni_prostor(1).BoundingBox(1)-centar_pix_x)*pix2mm_x;
radni_prostor_xy(1).BoundingBox(2)=0;
radni_prostor_xy(1).BoundingBox(3)=stats_radni_prostor(1).BoundingBox(3)*pix2mm_x;
radni_prostor_xy(1).BoundingBox(4)=stats_radni_prostor(1).BoundingBox(4)*pix2mm_y;

drop_prostor_xy=stats_drop_prostor;
drop_prostor_xy(1).BoundingBox(1)=(stats_drop_prostor(1).BoundingBox(1)-centar_pix_x)*pix2mm_x;
drop_prostor_xy(1).BoundingBox(2)=0;
drop_prostor_xy(1).BoundingBox(3)=stats_drop_prostor(1).BoundingBox(3)*pix2mm_x;
drop_prostor_xy(1).BoundingBox(4)=stats_drop_prostor(1).BoundingBox(4)*pix2mm_y;
% 
% for object =2:length(stats_rad_obj)
%     rad_obj_xy(object-1).Centroid(1)=rad_obj_xy(object).Centroid(1);
%     rad_obj_xy(object-1).Centroid(2)=rad_obj_xy(object).Centroid(2);
%     drop_obj_xy(object-1).Centroid(1)=drop_obj_xy(object).Centroid(1);
%     drop_obj_xy(object-1).Centroid(2)=drop_obj_xy(object).Centroid(2);
% end

end