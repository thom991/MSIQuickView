sum_of_intensities = zeros(number_of_scans,max(max_num(:)));
next_val = 1;
three_d_image = zeros(number_of_scans,max(max_num(:)),10);
for i = 1:10
    for j = 1:number_of_scans
    sum_of_intensities(j,1:max_num(j)) = M(i,next_val:(next_val+max_num(j)-1));
    next_val = next_val+max_num(j);
    end
    three_d_image(:,:,i) = sum_of_intensities;
    next_val = 1;
end

if fig_no == 1
    close(figure(1)); figure(1) 
end
subplot((no_of_images_per_page/2),2,fig_no); 
imagesc(sum_of_intensities_temp); axis off; 
if range_selected == 1
% title(strcat('MZ__min',num2str(final_mz_val(i_n))),'__max',num2str(final_mz_val_u(i_n)))%subplot(3,3,i);
% else
title(strcat('\it m/z \rm  ==',num2str(final_mz_val(i_n))))%subplot(3,3,i);    
end
if i_n == 1 && (fig_no == no_of_images_per_page)
% if image_window_to_display_value == 1
export_fig('trial.pdf', figure(1))%handles.zone_specified_plot)
% else
% export_fig('trial.pdf', figure(1))%handles.zone_specified_plot2)
% end
elseif (fig_no == no_of_images_per_page)
% if image_window_to_display_value == 1
export_fig('trial.pdf', figure(1),'-append') 
elseif ii == size(final_mz_val,1)
    export_fig('trial.pdf', figure(1),'-append')
% else
% export_fig('trial.pdf', handles.zone_specified_plot2,'-append')   
% end
end
% if i_n == 25;
%     break;
% end
% k = k2; 
    %%
    fig_no = fig_no + 1;
    if fig_no > no_of_images_per_page
        fig_no = 1;
    end
    time_taken = toc; fprintf('Estimated time remaining is %f \n', time_taken*abs(ii-size(final_mz_val,1)))
end
fprintf('PDF Saved !!! \n')
cd(current_dir)
close(figure(1))


for k = 1:10
    subplot(5,2,k); imagesc(three_d_image(:,:,k))
end