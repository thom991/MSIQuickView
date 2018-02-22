function x5 = average_ion_pixels_based_on_user_input(lim_val, sum_of_intensities)
x5 = scale_image_to_fixed_limits(0, 100, sum_of_intensities);
for i = 1:size(x5,1)
    for j = 2:size(x5,2)-1
        current_val = x5(i,j);
        left_val = x5(i,j-1);
        right_val = x5(i,j+1);
        average_left_right = (left_val+right_val)/2;
        if current_val > average_left_right + lim_val
            new_current_val = average_left_right;
            x5(i,j) = new_current_val;
        end
    end
end
