function which_image_window_without_set(image_window_to_display_value, xnorm, colormap_3d, handles)
% Determines which image window (1 or 2) to use to display the ion image...
if isempty(image_window_to_display_value) 
    image_window_to_display_value = 1;
end
if image_window_to_display_value == 1
    cla(handles.zone_specified_plot);
    axes(handles.zone_specified_plot);
else 
    cla(handles.zone_specified_plot2);
    axes(handles.zone_specified_plot2);
end
imagesc(xnorm);%(sum_of_intensities);
xlabel('Scan'); ylabel('Line');
if isempty(colormap_3d)
    colormap_3d = 'gray';
end
colormap(colormap_3d); set_colorbar(); %h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
