function [ output ] = calculate_moment( image, order )
%CALCULATE_MOMENT Calculates moments of given order for an image
%   Parameter image should be a logical image (binary image)
%   Order is a 1D array of length 2, the first element is the order of the
%   moment along x axis, the second element is the order of the moment
%   along y axis
    [rows, cols] = size(image);
    order_x = order(1);
    order_y = order(2);
    sum = 0;
    for i=1:rows
        for j=1:cols
            if image(i, j) > 0
                % fill your code here
            end
        end
    end
    output = sum;
end
