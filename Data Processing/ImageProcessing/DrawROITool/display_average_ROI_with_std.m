function [mean_val, std_val, coordinates, linearInd, IT_mask_image_ROI, IT_mask_binary_image_ROI] = display_average_ROI_with_std(ROI_pts, IT_mask_image, IT_mask_binary_image, sum_of_intensities, coordinates, linearInd, IT_mask_image_ROI, IT_mask_binary_image_ROI)
%% Function to use the ROI pixels drawn by the user to generate the mean value and standard deviation of the pixels within the ROI.
% Inputs:
% ROI_pts: ROI x and y pixel values
% IT_mask_image: IT_mask (actual values) to multiply with the ROI and discard those values
% IT_mask_binary_image: IT_mask (binary) to multiply with the ROI and discard those values
% sum_of_intensities: sum_of_intensities image or ion image 
% Output
% mean: mean intensity value from the ROI
% std: standard deviation of the intensity values within the ROI

%% Architecture
% 1) from ion_image, get all intensity values within ROI
% 2) from the binary IT_mask, get all the values within the ROI
% 3) Multiply 1*2 and remove 0 values to discard the bad IT time pixels from
% the mean calculation
% 4) get mean and std value
if ~exist('coordinates','var')
    coordinates = [ROI_pts.full_x; ROI_pts.full_y]';
    linearInd = sub2ind([size(sum_of_intensities,1),size(sum_of_intensities,2)], coordinates(:,2), coordinates(:,1));
    IT_mask_image_ROI = IT_mask_image(linearInd);
    IT_mask_binary_image_ROI = IT_mask_binary_image(linearInd);
end
sum_of_intensities_ROI = sum_of_intensities(linearInd);
combined_image = sum_of_intensities_ROI.*IT_mask_image_ROI.*IT_mask_binary_image_ROI;
combined_image([combined_image == 0]) = [];
mean_val = mean(combined_image);
std_val = std(combined_image);
