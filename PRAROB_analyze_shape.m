function N = PRAROB_ingprocess(img,rad_object)

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

% %obrada radnog prostora
% stats_radni_prostor=regionprops(diff_img_rad,'BoundingBox','Centroid');
% %obrada drop prostora
% stats_drop_prostor=regionprops(diff_img_drop,'BoundingBox','Centroid');

%obrada radnih objekata


stats_rad_obj=regionprops(diff_img_rad,'BoundingBox','Centroid');
rad_obj_xy=struct(stats_rad_obj);

for object = 1:length(stats_rad_obj)  
    img_rad_obj_arr=imcrop(diff_img_rad,stats_rad_obj(object).BoundingBox);   
    rad_obj_invm(object)=inv_moment(img_rad_obj_arr);
 
end 

%obrada drop lokacija

stats_drop_obj=regionprops(diff_img_drop,'BoundingBox','Centroid');
drop_obj_xy=struct(stats_drop_obj);

for object = 1:length(stats_drop_obj) 
    img_drop_obj_arr=imcrop(diff_img_drop,stats_drop_obj(object).BoundingBox);  
    drop_obj_invm(object)=inv_moment(img_drop_obj_arr);  

end 
match=0;
match_index=0;
%tolerancija slicnosti
tolerance=0.01;

for object = 1:length(stats_rad_obj)       
   if (abs(drop_obj_invm(rad_object)-rad_obj_invm(object))<=tolerance)      
       match = match + 1;
       match_index = object;
   end
   
%    if match == 0
%        I_match=0;
%        
%        stats_rad_obj(rad_object).BoundingBox(3)=stats_rad_obj(rad_object).BoundingBox(3)/2;
%        stats_rad_obj(rad_object).BoundingBox(4)=stats_rad_obj(rad_object).BoundingBox(4)/2;
%        img_rad_obj_arr1=imcrop(img_rad_obj,stats_rad_obj(rad_object).BoundingBox);
%        rad_obj_invm_dod(1)=inv_moment(img_rad_obj_arr1);
%        
%        stats_rad_obj(rad_object).BoundingBox(1)=stats_rad_obj(rad_object).BoundingBox(1)+stats_rad_obj(rad_object).BoundingBox(3);       
%        img_rad_obj_arr2=imcrop(img_rad_obj,stats_rad_obj(rad_object).BoundingBox);
%        rad_obj_invm_dod(2)=inv_moment(img_rad_obj_arr2);
%        
%        stats_rad_obj(rad_object).BoundingBox(2)=stats_rad_obj(rad_object).BoundingBox(2)+stats_rad_obj(rad_object).BoundingBox(4);       
%        img_rad_obj_arr3=imcrop(img_rad_obj,stats_rad_obj(rad_object).BoundingBox);
%        rad_obj_invm_dod(3)=inv_moment(img_rad_obj_arr3);
%        
%        stats_rad_obj(rad_object).BoundingBox(1)=stats_rad_obj(rad_object).BoundingBox(1)-stats_rad_obj(rad_object).BoundingBox(3);      
%        img_rad_obj_arr4=imcrop(img_rad_obj,stats_rad_obj(rad_object).BoundingBox);
%        rad_obj_invm_dod(4)=inv_moment(img_rad_obj_arr4);
%        
%        for object2 = 1:length(stats_drop_obj)
%           
%            stats_drop_obj(object2).BoundingBox(3)=stats_drop_obj(object2).BoundingBox(3)/2;
%            stats_drop_obj(object2).BoundingBox(4)=stats_drop_obj(object2).BoundingBox(4)/2;
%            img_drop_obj_arr1=imcrop(img_drop_obj,stats_drop_obj(object2).BoundingBox);
%            drop_obj_invm_dod(1)=inv_moment(img_drop_obj_arr1);
%        
%            stats_drop_obj(object2).BoundingBox(1)=stats_drop_obj(object2).BoundingBox(1)+stats_drop_obj(object2).BoundingBox(3);       
%            img_drop_obj_arr2=imcrop(img_drop_obj,stats_drop_obj(object2).BoundingBox);
%            drop_obj_invm_dod(2)=inv_moment(img_drop_obj_arr2);
%        
%            stats_drop_obj(object2).BoundingBox(2)=stats_drop_obj(object2).BoundingBox(2)+stats_drop_obj(object2).BoundingBox(4);       
%            img_drop_obj_arr3=imcrop(img_drop_obj,stats_drop_obj(object2).BoundingBox);
%            drop_obj_invm_dod(3)=inv_moment(img_drop_obj_arr3);
%        
%            stats_drop_obj(object2).BoundingBox(1)=stats_drop_obj(object2).BoundingBox(1)-stats_drop_obj(object2).BoundingBox(3);      
%            img_drop_obj_arr4=imcrop(img_drop_obj,stats_drop_obj(object2).BoundingBox);
%            drop_obj_invm_dod(4)=inv_moment(img_drop_obj_arr4);
%            
%            for i=1:4
%                if(abs(rad_obj_invm_dod(i)-drop_obj_invm_dod(i))<=tolerance)
%                    I_match = I_match + 1;
%                end
%            end 
%            if I_match == 4 
%                match = match + 1;
%                match_index = object;
%            end
%                
%            end
%  end

end
if match >= 1
    N=match_index;
else 
    N=0;
end