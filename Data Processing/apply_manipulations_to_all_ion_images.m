function handles = apply_manipulations_to_all_ion_images(handles)
if isfield(handles, 'apply_manipulations_to_all') && handles.apply_manipulations_to_all == 1;
    if isfield(handles, 'avg_image_pixels') && handles.avg_image_pixels == 1
        max_val = get(handles.max_val,'string');
        lim_val = single(str2num(max_val)); %#ok<*ST2NM>
        %sum_of_intensities = scale_image_to_fixed_limits(0, 100, sum_of_intensities);
        for i = 1:size(handles.sum_of_intensities,1)
            for j = 2:size(handles.sum_of_intensities,2)-1
                current_val = handles.sum_of_intensities(i,j);
                left_val = handles.sum_of_intensities(i,j-1);
                right_val = handles.sum_of_intensities(i,j+1);
                average_left_right = (left_val+right_val)/2;
                if current_val > average_left_right + lim_val
                    new_current_val = average_left_right;
                    handles.sum_of_intensities(i,j) = new_current_val;
                end
            end
        end
    end
    %% Remove unwanted lines
    lines_to_remove_from_image = get(handles.remove_lines_edit_box, 'string');
    lines_to_remove_from_image = str2num(lines_to_remove_from_image);
    if ~isempty(lines_to_remove_from_image)
        original_number_of_lines = 1:size(handles.sum_of_intensities,1);
        unique_elements_after_removing_lines = setdiff(original_number_of_lines, lines_to_remove_from_image);
        for i = 1:size(unique_elements_after_removing_lines,2)
            handles.sum_of_intensities(i,:) = handles.sum_of_intensities(unique_elements_after_removing_lines(i),:);
            
        end
        handles.sum_of_intensities(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
    end
    %% Adjust Scale
    lower_limit_for_grayscale_color = get(handles.new_lowest_gray_value,'string');   %lower limit bar for Int-Time spect
    higher_limit_for_grayscale_color = get(handles.new_highest_gray_value,'string');   %lower limit bar for Int-Time spect
    lower_limit_for_grayscale_color = str2num(lower_limit_for_grayscale_color);
    higher_limit_for_grayscale_color = str2num(higher_limit_for_grayscale_color);
end
if handles.apply_manipulations_to_all == 1
    handles = align_ion_image(handles);
    xnorm = handles.sum_of_intensities;
    if ~isempty(lower_limit_for_grayscale_color)
        xnorm(xnorm < lower_limit_for_grayscale_color) = lower_limit_for_grayscale_color;
        xnorm(xnorm > higher_limit_for_grayscale_color) = higher_limit_for_grayscale_color;
        handles.sum_of_intensities = xnorm;
    end
    %% Show Interpolated Values
    val_across_interpolated_data = get(handles.editbox_across_interpolated_data, 'string');
    val_across_interpolated_data = str2num(val_across_interpolated_data);
    val_down_interpolated_data = get(handles.editbox_down_interpolated_data, 'string');
    val_down_interpolated_data = str2num(val_down_interpolated_data);
    if ~isempty(val_across_interpolated_data)
        handles.sum_of_intensities = imresize(handles.sum_of_intensities(:,:),[size(handles.sum_of_intensities,1)*val_down_interpolated_data,size(handles.sum_of_intensities,2)*val_across_interpolated_data],'bilinear');
    end    
end