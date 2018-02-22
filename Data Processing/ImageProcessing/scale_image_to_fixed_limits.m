function image_file2 = scale_image_to_fixed_limits(new_min, new_max, image_file)
% scale_image_to_fixed_limits : Scale data/ion image with values from 0 to n to 0 to a new max value, example 100.
% Inputs:
%   1) new_min = 0;    %min of 0 to 255
%   2) new_max = 100;  %max of 0 to 255
%   3) image_file : image or data array
% Outputs:
%   1) image_file2 : image or data array within new scales
old_min = min(image_file(:));
old_max = max(image_file(:));
image_file2 = zeros(size(image_file,1),size(image_file,2),class(image_file));
for i = 1:size(image_file,1)
    for j2 = 1:size(image_file,2)
        value = image_file(i, j2);
        image_file2(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
    end
end