function img=img_capture(t);

stats_radni_prostor(1).BoundingBox(1)=679; 
stats_radni_prostor(1).BoundingBox(2)=22;
stats_radni_prostor(1).BoundingBox(3)=333;
stats_radni_prostor(1).BoundingBox(4)=724;

stats_drop_prostor(1).BoundingBox(1)=17;
stats_drop_prostor(1).BoundingBox(2)=22;
stats_drop_prostor(1).BoundingBox(3)=657;
stats_drop_prostor(1).BoundingBox(4)=724;

info=imaqhwinfo('winvideo');
vidObj=videoinput('winvideo',1,'MJPG_1024x768');
vidObj.ReturnedColorSpace = 'rgb';
timer=0;
figure();
title('CALIBRATE CAMERA');



while timer < t
    start(vidObj);
    img=getdata(vidObj);
    img=img(:,:,(1:3));
    imshow(img)
    hold on
    rectangle('Position',stats_radni_prostor(1).BoundingBox,'EdgeColor','r','LineWidth',2);
    rectangle('Position',stats_drop_prostor(1).BoundingBox,'EdgeColor','b','LineWidth',2);
    plot(512,746,'og');
    a=text(30,35, strcat('[Time till capture: ', num2str(t-timer), ' ]')); 
    set(a, 'FontName', 'Calibri', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green'); 
    pause(1);
    timer=timer +1;

end
close();
stop(vidObj);
end