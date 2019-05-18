%function [radni_prostor_xy rad_obj_xy drop_prostor_xy drop_obj_xy]= PRAROB_ingprocess()

% uzimanje slike
% % img = videoinput(’adaptor name', deviceID,‘format');
clear all

stats_radni_prostor(1).BoundingBox(1)=350; 
stats_radni_prostor(1).BoundingBox(2)=22;
stats_radni_prostor(1).BoundingBox(3)=657;
stats_radni_prostor(1).BoundingBox(4)=724;

stats_drop_prostor(1).BoundingBox(1)=17;
stats_drop_prostor(1).BoundingBox(2)=22;
stats_drop_prostor(1).BoundingBox(3)=333;
stats_drop_prostor(1).BoundingBox(4)=724;

stats_tot_prostor(1).BoundingBox(1)=17;
stats_tot_prostor(1).BoundingBox(2)=22;
stats_tot_prostor(1).BoundingBox(3)=990;
stats_tot_prostor(1).BoundingBox(4)=724;

% img = img_capture(10);
img = imread('slika1.PNG');
%whos img

%filtirranje zona na binarne like
%radna povrsina



img_hsv=rgb2hsv(img);
figure(10);imshow(img);
hue_lower= 0;
hue_upper= 0.40;
sat_lower=0.1;
struct_element = strel('disk',5);

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

figure(7);imshow(diff_img_rad);
figure(8);imshow(diff_img_drop);

%obrada radnog prostora:
% figure(1);
% stats_radni_prostor=regionprops(diff_img_rad,'BoundingBox','Centroid');
% %stats_radni_prostor
% imshow(diff_img_rad);
% hold on
% for object = 1:length(stats_radni_prostor) 
%     bb = stats_radni_prostor(object).BoundingBox; 
%     bc = stats_radni_prostor(object).Centroid; 
%     rectangle('Position',bb,'EdgeColor','g','LineWidth',1) 
%     plot(bc(1),bc(2), '-m+') 
%     a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), 'G: ', num2str(round(bc(2))))); 
%     set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green'); 
% end 
% hold off


%obrada drop prostora
% figure(2)
% 
% stats_drop_prostor=regionprops(diff_img_drop,'BoundingBox','Centroid');
% stats_drop_prostor
% imshow(diff_img_drop);
% hold on
% for object = 1:length(stats_drop_prostor)
%     bb = stats_drop_prostor(object).BoundingBox; 
%     bc = stats_drop_prostor(object).Centroid; 
%     rectangle('Position',bb,'EdgeColor','g','LineWidth',2) 
%     plot(bc(1),bc(2), '-m+') 
%     a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), 'G: ', num2str(round(bc(2))))); 
%     set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green'); 
% end 
% hold off

%prora?un vrijednosti za konverziju iz [pix] koordinatnog sustava u traženi
%koodrinatni sustav u [mm]
%centar_pix_p=605; %650/2=325 sredina ukupnog radnog prostora
centar_pix_x=512; 
centar_pix_y=746; 

pix2mm_x=0.29;
pix2mm_y=0.30;


%obrada radnih objekata
figure(3)

stats_rad_obj=regionprops(diff_img_rad,'BoundingBox','Centroid');
stats_rad_obj
imshow(diff_img_rad);
hold on
rad_obj_xy=struct(stats_rad_obj);
for object = 1:length(stats_rad_obj) 
    bb = stats_rad_obj(object).BoundingBox; 
    bc = stats_rad_obj(object).Centroid; 
    rad_obj_xy(object).Centroid(1)=(stats_rad_obj(object).Centroid(1)+stats_radni_prostor(1).BoundingBox(1)-centar_pix_x)*pix2mm_x;
    rad_obj_xy(object).Centroid(2)=-(stats_rad_obj(object).Centroid(2)+stats_radni_prostor(1).BoundingBox(2)-centar_pix_y)*pix2mm_y;  
    
    img_rad_obj_arr=imcrop(diff_img_rad,stats_rad_obj(object).BoundingBox);
    rad_obj_invm(object)=inv_moment(img_rad_obj_arr);
    object
    rad_obj_invm(object)
    
    rectangle('Position',bb,'EdgeColor','g','LineWidth',2) 
    plot(bc(1),bc(2), '-m+') 
    a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), 'G: ', num2str(round(bc(2))))); 
    set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green'); 
end 
hold off

%obrada drop lokacija
figure(4)
img_drop_obj=diff_img_drop;
stats_drop_obj=regionprops(img_drop_obj,'BoundingBox','Centroid');

stats_drop_obj
imshow(img_drop_obj);
hold on
drop_obj_xy=struct(stats_drop_obj);
for object = 1:length(stats_drop_obj) 
    bb = stats_drop_obj(object).BoundingBox; 
    bc = stats_drop_obj(object).Centroid;     
    drop_obj_xy(object).Centroid(1)=(stats_drop_obj(object).Centroid(1)+stats_drop_prostor(1).BoundingBox(1)-centar_pix_x)*pix2mm_x;
    drop_obj_xy(object).Centroid(2)=-(stats_drop_obj(object).Centroid(2)+stats_drop_prostor(1).BoundingBox(2)-centar_pix_y)*pix2mm_y;
    
    img_drop_obj_arr=imcrop(diff_img_drop,stats_drop_obj(object).BoundingBox);
    drop_obj_invm(object)=inv_moment(img_drop_obj_arr);
    object
    drop_obj_invm(object)
    
    rectangle('Position',bb,'EdgeColor','g','LineWidth',2) 
    plot(bc(1),bc(2), '-m+') 
    a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), 'G: ', num2str(round(bc(2))))); 
    set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green'); 
end 
hold off


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

figure(5)
% xlim=[-180 180];
xlabel('X axis [mm]');
ylabel('Y axis [mm]');
% ylim=[-20 250];

title('WORKSPACE');
rectangle('Position',radni_prostor_xy(1).BoundingBox,'EdgeColor','r','LineWidth',2);
hold on
rectangle('Position',drop_prostor_xy(1).BoundingBox,'EdgeColor','b','LineWidth',2);
plot(0,0,'og');
grid on

for object =1:length(stats_rad_obj)
    rad_obj_xy(object).Centroid(1)=rad_obj_xy(object).Centroid(1);
    rad_obj_xy(object).Centroid(2)=rad_obj_xy(object).Centroid(2);
    drop_obj_xy(object).Centroid(1)=drop_obj_xy(object).Centroid(1);
    drop_obj_xy(object).Centroid(2)=drop_obj_xy(object).Centroid(2)
end

for object = 1:(length(stats_rad_obj))
    plot(rad_obj_xy(object).Centroid(1),rad_obj_xy(object).Centroid(2),'-m+');
    plot(drop_obj_xy(object).Centroid(1),drop_obj_xy(object).Centroid(2), '-m+');
    viscircles([rad_obj_xy(object).Centroid(1) rad_obj_xy(object).Centroid(2)],8,'LineWidth',1,'Color','g');
    viscircles([drop_obj_xy(object).Centroid(1) drop_obj_xy(object).Centroid(2)],8,'LineWidth',1,'Color','g');
    txt_w=strcat('Work object(',num2str(object),')');
    txt_d=strcat('Drop zone(',num2str(object),')');
    text(rad_obj_xy(object).Centroid(1)+10,rad_obj_xy(object).Centroid(2)+10,txt_w,'FontSize',10);
    text(drop_obj_xy(object).Centroid(1)+10,drop_obj_xy(object).Centroid(2)+10,txt_d,'FontSize',10);
    
    
end    
hold off



%end