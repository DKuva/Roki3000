%% Doing stuff with MATLAB Image Processing toolbox
% Modify the lv6.m script along with calculate_moment.m and
% calculate_central_moment.m functions to perform the following tasks.

%% Task 1 - Load image
% Load the input image using the imread function

img = imread('image.PNG');
figure();imshow(img);title('Original image')

%% Task 2 - Preprocessing
% Do preprocessing steps you deem necessary (filtering, color space
% conversions etc.)

% fill in your code here
% ...
% ...

%% Task 3 - Segmentation
% Segment the image to have the black pen in the foreground (logical ones)

% Fill in the segmentation code here:
% ...
% ...
% Perform morphological operations if necessary. Fill in your code here:
% ...
% ...

% Once finished, show image
figure();imshow(img_pen);title('Pen after processing');

%% Task 4 - Moments, area and centroid
% Prepare calculate_moment function. In calculate_moment.m fill in the code
% to calculate the moment:
% 
% $$m_{kj}=\Sigma x^ky^j$$
% 

% Next, calculate area and centroid of the pen and compare your results to MATLAB built-in functionality

m_00 = calculate_moment(img_pen, [0 0]);
m_10 = calculate_moment(img_pen, [1 0]);
m_01 = calculate_moment(img_pen, [0 1]);

% calculate area and centroid
% A = ...
% x_c = ...
% y_c = ...

% display region props
disp(regionprops(img_pen))

% Try to explain any existing differences

%% Task 5 -  Central moments and object angle
% Prepare calculate_moment function. In calculate_central_moment.m fill in
% the code to calculate the central moment:
% 
% $$m_{kj}=\Sigma (x-x_c)^k(y-y_c)^j$$
% 

% Next, calculate central moments
mu_11 = calculate_central_moment(img_pen, [x_c y_c], [1 1]);
mu_20 = calculate_central_moment(img_pen, [x_c y_c], [2 0]);
mu_02 = calculate_central_moment(img_pen, [x_c y_c], [0 2]);

% calculate angle here:
% angle = <your code here>;

% rotate the image using the calculated angle
img_rotated = imrotate(img, -angle);
figure();imshow(img_rotated);title('Pen should be vertical')

% Check help of imrotate function and explain why negative value of
% calculated angle is passed to the function

%% Task 6 - Lines and object angle
% Calculate the angle of the pen by detecting lines

% Perform edge detection on the grayscale image

% detect lines using hough transformation
[H,T,R] = hough(img_edges);
P = houghpeaks(H, 2);
lines = houghlines(img_edges, T, R, P, 'FillGap', 60, 'MinLength', 7);
figure, imshow(img), hold on, title('Lines');
max_len = 0;
for k = 1:length(lines)
    disp(['Angle of line ', num2str(k), ' is ', num2str(lines(k).theta), ' degrees'])
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

% Compare and comment the angles obtained from Hough transform

%% Task 7 - Find red circles
% Calculate the number of red coins in the image. Segment image to show
% only the red color in the foreground then use imfindcircles to find all
% circles in the segmented image. Pay special attention to the radius
% interval you pass to the function.

% fill in your segmentation code here
% img_red_coins = ...

% find circles
% [center, radius]=imfindcircles(img_red_coins, [low_radius, high_radius])

imshow(img);title('Red coins')
viscircles(center, radius, 'EdgeColor', [0,0,0]);

%% Task 8 - Find all other circles
% Calculate the number of all other coins (excluding the red coins). Again,
% use imfindcircles to find circles in the image.

% fill in your segmentation code here
% img_other_coins = ...

% find circles
% [center_other, radius_other]=imfindcircles(img_other_coins, [low_radius, high_radius])

figure();imshow(img);title('Other coins')
viscircles(center_other, radius_other, 'EdgeColor', [0,0,0]);


