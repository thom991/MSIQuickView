function x5 = apply_modifications_to_all_images(x5,apply_manipulations_to_all)
% global next_sum_folder pathname image_window_to_display_value sum_of_intensities colormap_3d size_count_limits upper_limits_count lower_limits_count lower_limit_mz_value upper_limit_mz_value apply_manipulations_to_all
% next_sum_folder = next_sum_folder + 1;
% if next_sum_folder > size_count_limits
%     next_sum_folder = 1;
% elseif isempty(next_sum_folder)
%     next_sum_folder = 1;
% end
% temp_name = dir(strcat(pathname,'delete_mat_files',filesep,'sum_of_intensities*.mat'));
% load(strcat(pathname,'delete_mat_files',filesep,temp_name(next_sum_folder,1).name))
% sum_of_intensities = sum_of_intensities2;
% apply_manipulations_to_all = (get(hObject, 'Value'));
if apply_manipulations_to_all == 1;
%%Remove unwanted lines    
lines_to_remove_from_image = get(handles.remove_lines_edit_box, 'string');
lines_to_remove_from_image = str2num(lines_to_remove_from_image);
if ~isempty(lines_to_remove_from_image)
original_number_of_lines = 1:size(x5,1);
unique_elements_after_removing_lines = setdiff(original_number_of_lines, lines_to_remove_from_image);
                    for i = 1:size(unique_elements_after_removing_lines,2)
                        x5(i,:) = x5(unique_elements_after_removing_lines(i),:);
                    
                    end                    
                    x5(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
end
%% Show Interpolated Values
val_across_interpolated_data = get(handles.editbox_across_interpolated_data, 'string');
val_across_interpolated_data = str2num(val_across_interpolated_data);
val_down_interpolated_data = get(handles.editbox_down_interpolated_data, 'string');
val_down_interpolated_data = str2num(val_down_interpolated_data);
if ~isempty(val_across_interpolated_data)
x5 = imresize(x5(:,:),[size(x5,1)*val_down_interpolated_data,size(x5,2)*val_across_interpolated_data],'bilinear');
end
%% Adjust Scale
lower_limit_for_grayscale_color = get(handles.new_lowest_gray_value,'string');   %lower limit bar for Int-Time spect
higher_limit_for_grayscale_color = get(handles.new_highest_gray_value,'string');   %lower limit bar for Int-Time spect
lower_limit_for_grayscale_color = str2num(lower_limit_for_grayscale_color);
higher_limit_for_grayscale_color = str2num(higher_limit_for_grayscale_color);
%%
end    
    xnorm = x5;
                    new_min = 0;    %min of 0 to 255
                    new_max = 100;  %max of 0 to 255
                    old_min = min(x5(:));
                    old_max = max(x5(:));
                    for i = 1:size(x5,1)
                        for j2 = 1:size(x5,2)
                        value = x5(i, j2);
                        xnorm(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
                        end
                    end
if apply_manipulations_to_all == 1                    
if ~isempty(lower_limit_for_grayscale_color)
    x5 = xnorm;
x5(xnorm < lower_limit_for_grayscale_color) = lower_limit_for_grayscale_color;% - 5;
x5(xnorm > higher_limit_for_grayscale_color) = higher_limit_for_grayscale_color;% + 5;
end
end
%%

% if isempty(image_window_to_display_value) 
%     image_window_to_display_value = 1;
% end
% %     image_window_to_display_value = 2;
% % end
% 
% if image_window_to_display_value == 1
% set(handles.lower_limit_axes1,'string',num2str(lower_limits_count(next_sum_folder)));    
% set(handles.upper_limit_axes1,'string',num2str(upper_limits_count(next_sum_folder)));      
% cla(handles.zone_specified_plot);
% axes(handles.zone_specified_plot);
% else
% set(handles.lower_limit_axes2,'string',num2str(lower_limits_count(next_sum_folder)));    
% set(handles.upper_limit_axes2,'string',num2str(upper_limits_count(next_sum_folder)));        
% cla(handles.zone_specified_plot2);
% axes(handles.zone_specified_plot2);
% end
% imagesc(xnorm);%(x5);
% xlabel('Scan'); ylabel('Line');
% colormap(colormap_3d); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
% lower_limit_mz_value = lower_limits_count(next_sum_folder);
% upper_limit_mz_value = upper_limits_count(next_sum_folder);