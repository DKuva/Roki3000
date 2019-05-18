function [ output ] = calculate_central_moment( image, centroid, order )
%CALCULATE_CENTRAL_MOMENT Calculates central moment of a given order for an
%image
%   Parameter image should be a logical image (binary image)
%   Centroid is a 1D array of length 2, the first element is the x
%   coordinate of the centroid, the second element is the y coordinate of
%   the centroid
%   Order is a 1D array of length 2, the first element is the order of the
%   central moment along x axis, the second element is the order of the
%   central moment along y axis
    x_c = centroid(1);
    y_c = centroid(2);
    
    order_x = order(1);
    order_y = order(2);
    
    [rows, cols] = size(image);
    
    sum = 0;
    for i=1:rows
        for j=1:cols
            if image(i,j) > 0
                sum = sum + ((j - x_c)^order_x)*((i - y_c)^order_y);
            end
        end
    end
    
    output = sum;
end