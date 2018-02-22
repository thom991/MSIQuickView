function sum_of_pixels = total_count_of_pixels_in_ROI(pixelCoordinates)
%% This function will count the total number of pixels in the user drawn ROI on the web page. 
% The pixel coordinates will be passed to this function from javascript and the output will be the total number as an integer.
%% Expected structure of data from javascript/java
% 1X1 array: 
% Line --> 3,121,122,123,201,202,203,204, -1, 4,119,120,121,122, -1, 5,201,202,203,204  
% First value in each line referes to the image row # and the corresponding
% numbers refer to column numbers, -1 is the line separator.
%% Example Call
% total_count_of_pixels_in_ROI([3,121,122,123,201,202,203,204, -1, 4,119,120,121,122, -1, 5,201,202,203,204])
disp(pixelCoordinates);
count = 1;
sum_of_pixels = 0;
loc = find(pixelCoordinates == -1);
for number_of_lines = 1:(numel(loc)+1)
    if number_of_lines <= numel(loc)    
        cur_set = pixelCoordinates(count:loc(number_of_lines)-1);
        count = loc(number_of_lines)+1;
    else
        cur_set = pixelCoordinates(count:end);
    end
    cur_line = cur_set(1);
    cur_line_pixels = cur_set(2:end);
    sum_of_pixels = sum_of_pixels + numel(cur_line_pixels);
end