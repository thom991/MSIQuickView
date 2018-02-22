function sum_of_intensities = which_image_window(image_window_to_display_value, m, lowerlimitscount, upperlimitscount, colormap_3d, handles)
% Determines which image window (1 or 2) to use to display the ion image...
if isempty(image_window_to_display_value) 
    image_window_to_display_value = 1;
end
if image_window_to_display_value == 1
%     handles = guihandles(); % recover handles for current figure
    set(handles.lower_limit_axes1,'string',num2str(lowerlimitscount));    
    set(handles.upper_limit_axes1,'string',num2str(upperlimitscount));
    cla(handles.zone_specified_plot);
    axes(handles.zone_specified_plot);
else
%     handles = guihandles(); % recover handles for current figure
    set(handles.lower_limit_axes2,'string',num2str(lowerlimitscount));    
    set(handles.upper_limit_axes2,'string',num2str(upperlimitscount));    
    cla(handles.zone_specified_plot2);
    axes(handles.zone_specified_plot2);
end
if size(handles.sum_of_intensities,2) > 1000
   handles.sum_of_intensities = imresize(handles.sum_of_intensities, [size(handles.sum_of_intensities,1), 1000]); 
end
sum_of_intensities = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
sum_of_intensities = remove_noise_spikes_from_image(sum_of_intensities, 20);
sum_of_intensities = scale_image_to_fixed_limits(0, 100, sum_of_intensities);
imagesc(sum_of_intensities);%(sum_of_intensities);
xlabel('Scan'); ylabel('Line');
colormap(colormap_3d); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
