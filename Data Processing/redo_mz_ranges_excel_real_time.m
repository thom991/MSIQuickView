% --- Executes on button press in redo_for_new_ranges.
function [num, lower_limits_count2, upper_limits_count2] = redo_mz_ranges_excel_real_time(cur_line)
global pathname ll single_range_value double_range_value image_window_to_display_value size_count_limits normalize_data_mode stop_val
    stop_val = 0;
    fprintf('current_line is %d',cur_line)
    if cur_line == 1
        handles = guihandles(); % recover handles for current figure
        [FileName,PathName] = uigetfile('*.xls','Select the Excel file');
        [status, sheets] = xlsfinfo([PathName FileName]);
        [s,v] = listdlg('PromptString','Select a file:',...
                        'SelectionMode','single',...
                        'ListString',sheets);
        num = xlsread([PathName FileName],sheets{1,s});
    %     upper_limit_mz_value = 1;
        prompt = {'Enter first row #:','Enter last row #:'};
        dlg_title = '# of mz values to use';
        num_lines = 1;
        def = {'1','end'};
        answer2 = inputdlg(prompt,dlg_title,num_lines,def);
        if strcmp(answer2{2,1},'end')
           num = num((str2num(answer2{1,1}):end),:);
        else
           num = num((str2num(answer2{1,1}):str2num(answer2{2,1})),:);
        end
        api = config_file;
        saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
        if exist(strcat(pathname,saveTempFilesToFolder,filesep,'Cluster_Temp'),'file')
           rmdir(strcat(pathname,saveTempFilesToFolder,filesep,'Cluster_Temp'),'s')
        end
        prompt = {'Enter PDF #:'};
        dlg_title = 'User Input';
        num_lines = 1;
        def = {'1'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        new_no = answer{1,1};
        disp('Please Wait !!!')
        if exist(strcat(pathname,'Images',filesep,'pdf_list',new_no,'.pdf'),'file')
            delete(strcat(pathname,'Images',filesep,'pdf_list',new_no,'.pdf'))   
        end
    end
    current_dir2 = pwd;
    cd(strcat(pathname,'CDF_Files'))
    fake_name2 = ll{1,cur_line};
    fake_name2(end-3:end) = '.hdf';
    RAW_filename_new2 = strcat(pathname,'HDF_Files',filesep,fake_name2);
    intensity_values = hdf5read(RAW_filename_new2,'intensity_values');
    mass_values = hdf5read(RAW_filename_new2,'mass_values');
    scan_acquisition_time = hdf5read(RAW_filename_new2,'scan_acquisition_time');
    scan_acquisition_time = scan_acquisition_time/60;
    point_count = hdf5read(RAW_filename_new2,'point_count');
    total_intensity = hdf5read(RAW_filename_new2,'total_intensity');
    min_time_final = min(scan_acquisition_time(:));
    max_time_final = max(scan_acquisition_time(:));
    min_time = min(scan_acquisition_time(:)); max_time = max(scan_acquisition_time(:));
    min_time_final = max([min_time_final min_time]); max_time_final = min([max_time_final max_time]);
    number_time_vals = size(scan_acquisition_time,1);
    lower_limits_count2 = num(:,1);
    lower_limits_count2 = lower_limits_count2';
    upper_limits_count2 = num(:,2);
    upper_limits_count2 = upper_limits_count2';
    size_count_limits = size(lower_limits_count2,2);
    % list = zeros(lower_limits_count,1);
    for i55 = 1: size(lower_limits_count2,2)
        list{i55} = [num2str(lower_limits_count2(i55)) '-' num2str(upper_limits_count2(i55))];
    end
    set(handles.mz_list_ion_image, 'String', list);
    for oo = 1: size(lower_limits_count2,2)
%         get(hObject,'Value');
        if stop_val == 1
            break;
        end
        sum_of_intensities_temp3 = [];
        sum_of_intensities_normalize = [];
        lower_limit_mz_value2 = lower_limits_count2(oo);
        upper_limit_mz_value2 = upper_limits_count2(oo);
        low_bar = single(lower_limit_mz_value2);
        high_bar = single(upper_limit_mz_value2);
        for scan_numb = 1:size(point_count,1)
            number_time_vals_final = size(scan_acquisition_time,1);
            int_val = intensity_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
            mass_val = mass_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
            if isempty(single_range_value) %size(r,1) > 1
                single_number_forward = (find(mass_val >= low_bar,1,'first'));
                single_number_backward = (find(mass_val < low_bar,1,'last'));
                diff_forward = abs(low_bar - mass_val(single_number_forward(1)));
                if ~isempty(single_number_backward)
                    diff_backward = abs(low_bar - mass_val(single_number_backward(end)));
                else
                    diff_backward = 0;
                end
                if diff_forward < diff_backward
                    lower_number = single_number_forward(1);
                else
                    if ~isempty(single_number_backward)
                        lower_number = single_number_backward(end);
                    else
                        lower_number = single_number_forward(1);
                    end;
                end
                high_single_number_forward = (find(mass_val >= high_bar,1,'first'));
                high_single_number_backward = (find(mass_val < high_bar,1,'last'));
                high_diff_forward = abs(high_bar - mass_val(high_single_number_forward(1)));
                if ~isempty(high_single_number_backward)
                    high_diff_backward = abs(high_bar - mass_val(high_single_number_backward(end)));
                else
                    high_diff_backward = 0;
                end
                if high_diff_forward < high_diff_backward
                    higher_number = high_single_number_forward(1);
                else
                    if ~isempty(high_single_number_backward)
                        higher_number = high_single_number_backward(end);
                    else
                        higher_number = high_single_number_forward(1);
                    end
                end
                lower_number_new = lower_number;%(1);%(1) + sum(point_count(2:i2));;
                higher_number_new = higher_number;%(end);%(1) + sum(point_count(2:i2));
            elseif isempty(double_range_value)
                if isempty(single_limit_mz_value)
                    uiwait
                end
                h_l = imline(gca, [single_limit_mz_value single_limit_mz_value], [0 max(int_val(:))]);%,@get_line_info_Callback);
                api = iptgetapi(h_l);
                api.setColor([1 0 0]);
                fcn = makeConstrainToRectFcn('imline', [0, max(mass_val(:))],...
                    [0, max(int_val(:))]);
                api.setPositionConstraintFcn(fcn);
                axis tight
                low_bar = single(single_limit_mz_value);
                single_number_forward = (find(mass_val >= low_bar,1,'first'));% & sure1_check(:,n_num) < low_bar+1));
                single_number_backward = (find(mass_val > low_bar,1,'last'));% & sure1_check(:,n_num) < low_bar));
                diff_forward = abs(low_bar - mass_val(single_number_forward(1)));
                if ~isempty(single_number_backward)
                    diff_backward = abs(low_bar - mass_val(single_number_backward(end)));
                else
                    diff_backward = 0;
                end
                if diff_forward < diff_backward
                    single_number = single_number_forward(1);
                else
                    if ~isempty(single_number_backward)
                        single_number = single_number_backward(end);
                    else
                        single_number = single_number_forward(1);
                    end
                end
                single_number_new = single_number;%(1);
            end
            sum_of_intensities_temp3(1,scan_numb) = sum(int_val(lower_number_new:higher_number_new));%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));
            normalize_data_lower_lim = get(handles.normalize_data_lower_limit,'string');
            normalize_data_lower_lim = single(str2num(normalize_data_lower_lim));
            normalize_data_higher_lim = get(handles.normalize_data_higher_limit,'string');
            normalize_data_higher_lim = single(str2num(normalize_data_higher_lim));
            if ~isempty(normalize_data_lower_lim)
                single_number_forward_normalize = (find(mass_val >= normalize_data_lower_lim,1,'first'));
                single_number_backward_normalize = (find(mass_val < normalize_data_lower_lim,1,'last'));
                diff_forward_normalize = abs(normalize_data_lower_lim - mass_val(single_number_forward_normalize(1)));
                if ~isempty(single_number_backward_normalize)
                    diff_backward_normalize = abs(normalize_data_lower_lim - mass_val(single_number_backward_normalize(end)));
                else
                    diff_backward_normalize = 0;
                end
                if diff_forward_normalize < diff_backward_normalize
                    lower_number_normalize = single_number_forward_normalize(1);
                else
                    if ~isempty(single_number_backward_normalize)
                        lower_number_normalize = single_number_backward_normalize(end);
                    else
                        lower_number_normalize = single_number_forward_normalize(1);
                    end;
                end
                high_single_number_forward_normalize = (find(mass_val >= normalize_data_higher_lim,1,'first'));
                high_single_number_backward_normalize = (find(mass_val < normalize_data_higher_lim,1,'last'));
                high_diff_forward_normalize = abs(normalize_data_higher_lim - mass_val(high_single_number_forward_normalize(1)));
                if ~isempty(high_single_number_backward_normalize)
                    high_diff_backward_normalize = abs(normalize_data_higher_lim - mass_val(high_single_number_backward_normalize(end)));
                else
                    high_diff_backward_normalize = 0;
                end
                if high_diff_forward_normalize < high_diff_backward_normalize
                    higher_number_normalize = high_single_number_forward_normalize(1);
                else
                    if ~isempty(high_single_number_backward_normalize)
                        higher_number_normalize = high_single_number_backward_normalize(end);
                    else
                        higher_number_normalize = high_single_number_forward_normalize(1);
                    end
                end
                lower_number_new_normalize = lower_number_normalize;%(1);%(1) + sum(point_count(2:i2));
                higher_number_new_normalize = higher_number_normalize;%(end);%(1) + sum(point_count(2:i2));
                sum_of_intensities_normalize(1,scan_numb) = sum(int_val(lower_number_new_normalize:higher_number_new_normalize));%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));
            end
        end
        if isempty(image_window_to_display_value)
            image_window_to_display_value = 1;
        end
        if isempty(normalize_data_mode)
            normalize_data_mode = 0;
        end
        if normalize_data_mode == 1 && isempty(normalize_data_lower_lim)
            sum_of_intensities_temp3 = sum_of_intensities_temp3./total_intensity';%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));
        elseif normalize_data_mode == 1 && ~isempty(normalize_data_lower_lim)
            sum_of_intensities_temp3 = sum_of_intensities_temp3./sum_of_intensities_normalize;
            sum_of_intensities_temp3(isinf(sum_of_intensities_temp3)) = 0;
        end
        current_dir = pwd;
        cd(strcat(pathname,saveTempFilesToFolder))
        if cur_line == 1
            sum_of_intensities_temp2 = sum_of_intensities_temp3;
            vname = sprintf('x%d',cur_line);
            eval([vname, '=sum_of_intensities_temp2;'])
            save(strcat('sum_of_intensities',num2str(oo+1),'.mat'),vname)
            row_num = 1;
        else
            sum_of_intensities_temp2 = sum_of_intensities_temp3;
            vname = sprintf('x%d',cur_line);
            eval([vname, '=sum_of_intensities_temp2;'])
            save(strcat('sum_of_intensities',num2str(oo+1),'.mat'),vname,'-append')
            if stop_val == 1
                break;
            end
        end
        cd(current_dir)
    end
%     k_final_2 = count_2;
%     k = k + 1;
%     row_num = row_num + 1;
%     end
%     current_dir = pwd;    
%     cd(strcat(pathname,'delete_mat_files'))
%     for i = 1:size(lower_limits_count,2)
%         sum_of_intensities2 = NaN([org_sum_of_int1,org_sum_of_int2]);
%         load(strcat('sum_of_intensities',num2str(i),'.mat'))
%         for j = 1:size(sum_of_intensities2,1)
%             vname = sprintf('x%d',j);
%             eval_vname = size(eval(vname),2);
%             sum_of_intensities2(j,1:eval_vname) = eval(vname);
%         end
%         save(strcat('sum_of_intensities',num2str(i),'.mat'),'sum_of_intensities2')
%     end
%     cd(current_dir)
%     subplot_count = 1;  
%     pdf_count = 1;
%     for gg = 1: size(lower_limits_count,2)  
%         x5 = load(strcat(pathname,'delete_mat_files',filesep,'sum_of_intensities',num2str(gg)));
%         x5 = x5.sum_of_intensities2;
%         if apply_manipulations_to_all == 1;
%             %% Avergae Image Pixels
%             if avg_image_pixels == 1
%                 max_val = get(handles.max_val,'string');
%                 lim_val = single(str2num(max_val));
%                 new_min = 0;    %min of 0 to 255
%                 new_max = 100;  %max of 0 to 255
%                 old_min = min(x5(:));
%                 old_max = max(x5(:));
%                 for i = 1:size(x5,1)
%                     for j2 = 1:size(x5,2)
%                         value = x5(i, j2);
%                         x5(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
%                     end
%                 end
%                 for i = 1:size(x5,1)
%                     for j = 2:size(x5,2)-1
%                         current_val = x5(i,j);
%                         left_val = x5(i,j-1);
%                         right_val = x5(i,j+1);
%                         average_left_right = (left_val+right_val)/2;
%                         if current_val > average_left_right + lim_val
%                             new_current_val = average_left_right;
%                             x5(i,j) = new_current_val;
%                         end
%                     end
%                 end
%             end
%             %% Align Image
%             filename2 = filename;
%             x5 = interpolation_code(x5, number_of_scans, filename2);
%             %% Remove unwanted lines
%             lines_to_remove_from_image = get(handles.remove_lines_edit_box, 'string');
%             lines_to_remove_from_image = str2num(lines_to_remove_from_image);
%             if ~isempty(lines_to_remove_from_image)
%                 original_number_of_lines = 1:size(x5,1);
%                 unique_elements_after_removing_lines = setdiff(original_number_of_lines, lines_to_remove_from_image);
%                 for i = 1:size(unique_elements_after_removing_lines,2)
%                     x5(i,:) = x5(unique_elements_after_removing_lines(i),:);
%                 end
%                 x5(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
%             end
%             %% Show Interpolated Values
%             val_across_interpolated_data = get(handles.editbox_across_interpolated_data, 'string');
%             val_across_interpolated_data = str2num(val_across_interpolated_data);
%             val_down_interpolated_data = get(handles.editbox_down_interpolated_data, 'string');
%             val_down_interpolated_data = str2num(val_down_interpolated_data);
%             if ~isempty(val_across_interpolated_data)
%                 x5 = imresize(x5(:,:),[size(x5,1)*val_down_interpolated_data,size(x5,2)*val_across_interpolated_data],'bilinear');
%             end
%             %% Adjust Scale
%             lower_limit_for_grayscale_color = get(handles.new_lowest_gray_value,'string');   %lower limit bar for Int-Time spect
%             higher_limit_for_grayscale_color = get(handles.new_highest_gray_value,'string');   %lower limit bar for Int-Time spect
%             lower_limit_for_grayscale_color = str2num(lower_limit_for_grayscale_color);
%             higher_limit_for_grayscale_color = str2num(higher_limit_for_grayscale_color);
%         end
%         xnorm = x5;
%         new_min = 0;    %min of 0 to 255
%         new_max = 100;  %max of 0 to 255
%         old_min = min(x5(:));
%         old_max = max(x5(:));
%         for i = 1:size(x5,1)
%             for j2 = 1:size(x5,2)
%                 value = x5(i, j2);
%                 xnorm(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
%             end
%         end
%         if apply_manipulations_to_all == 1
%             if ~isempty(lower_limit_for_grayscale_color)
%                 x5 = xnorm;
%                 x5(xnorm < lower_limit_for_grayscale_color) = lower_limit_for_grayscale_color;% - 5;
%                 x5(xnorm > higher_limit_for_grayscale_color) = higher_limit_for_grayscale_color;% + 5;
%             end
%         else
%             xnorm = x5;
%             new_min = 0;    %min of 0 to 255
%             new_max = 100;  %max of 0 to 255
%             old_min = min(x5(:));
%             old_max = max(x5(:));
%             for i = 1:size(x5,1)
%                 for j2 = 1:size(x5,2)
%                     value = x5(i, j2);
%                     xnorm(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
%                 end
%             end
%             x5 = xnorm;
%         end
%         if gg == 1
%             mkdir([pathname, 'delete_mat_files', filesep, 'Cluster_Temp'])
%         end
%         if subplot_count == 1
%             axes(handles.axes39)
%         elseif subplot_count == 2
%             axes(handles.axes40)
%         elseif subplot_count == 3
%             axes(handles.axes41)
%         elseif subplot_count == 4
%             axes(handles.axes42)
%         elseif subplot_count == 5
%             axes(handles.axes43)
%         elseif subplot_count == 6
%             axes(handles.axes44)
%         elseif subplot_count == 7
%             axes(handles.axes45)
%         elseif subplot_count == 8
%             axes(handles.axes46)
%         elseif subplot_count == 9
%             axes(handles.axes47)
%         elseif subplot_count == 10
%             axes(handles.axes48)
%         elseif subplot_count == 11
%             axes(handles.axes49)
%         elseif subplot_count == 12
%             axes(handles.axes50)
%         elseif subplot_count == 13
%             axes(handles.axes51)
%         elseif subplot_count == 14
%             axes(handles.axes52)
%         elseif subplot_count == 15
%             axes(handles.axes53)
%         end
%         %% Adjust Aspect Ratio
%         if ~isempty(temp2)
%             set(gca,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
%         end
%         if apply_manipulations_to_all == 1
%             if changed_aspect_ratio == 1
%                 across_val = get(handles.aspect_ratio_across_edit,'string');
%                 down_val = get(handles.aspect_ratio_down_edit,'string');
%                 temp1 = get(gca,'Position');
%                 temp2 = temp1;
%                 if isempty(temp5)
%                     temp5 = temp1;
%                 end
%                 down_val = str2num(down_val);
%                 across_val = str2num(across_val);
%                 if down_val > across_val
%                     width = (temp2(3)*(across_val/down_val));%((temp1(3)/down_val)*across_val);
%                     set(gca,'Position',[temp1(1) temp1(2) width temp1(4)]) % change axis position
%                 else
%                     height = (temp2(4)*(down_val/across_val));%((temp1(3)/down_val)*across_val);
%                     set(gca,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
%                 end
%             end
%         end
%         text_color = [1,0,0];
%         imagesc(x5); colormap(colormap_3d)
%         title(strcat(' {\it mz } ', num2str(num(gg,1)),'-',num2str(num(gg,2))),'FontSize',3.5,'Color',text_color); colormap(strcat(colormap_3d,'(32)'));%pause(.5);
%         axis off
%         if subplot_count == 15 || gg == size(lower_limits_count,2)
%             subplot_count = 0;
%             h = gcf;
%             fnout = [pathname, 'delete_mat_files', filesep, 'Cluster_Temp', filesep, 'images',num2str(pdf_count), '.pdf'];
%             set(h, 'PaperOrientation','portrait');
%             print('-dpdf','-zbuffer','-r300',fnout);
%             pdf_count = pdf_count + 1;
%             cla(handles.axes39)
%             title(handles.axes39,' ')
%             cla(handles.axes40)
%             title(handles.axes40,' ')
%             cla(handles.axes41)
%             title(handles.axes41,' ')
%             cla(handles.axes42)
%             title(handles.axes42,' ')
%             cla(handles.axes43)
%             title(handles.axes43,' ')
%             cla(handles.axes44)
%             title(handles.axes44,' ')
%             cla(handles.axes45)
%             title(handles.axes45,' ')
%             cla(handles.axes46)
%             title(handles.axes46,' ')
%             cla(handles.axes47)
%             title(handles.axes47,' ')
%             cla(handles.axes48)
%             title(handles.axes48,' ')
%             cla(handles.axes49)
%             title(handles.axes49,' ')
%             cla(handles.axes50)
%             title(handles.axes50,' ')
%             cla(handles.axes51)
%             title(handles.axes51,' ')
%             cla(handles.axes52)
%             title(handles.axes52,' ')
%             cla(handles.axes53)
%             title(handles.axes53,' ')
%         end
%         subplot_count = subplot_count + 1;
%         if gg == 1;
%             bb = x5;
%         end
%     end
%     system(['C:\vis_xcalibur_raw_files\pdftk' ' ' strcat('"',pathname, 'delete_mat_files', filesep, 'Cluster_Temp',filesep,'*.pdf','"') ' ' 'output' ' ' strcat('"',pathname,'Images',filesep,'pdf_list',new_no,'.pdf','"')]);
%     set(handles.uipanel120, 'visible', 'off');
%         set(handles.uipanel145, 'visible', 'off');
%         set(handles.uipanel130, 'visible', 'off');
%         set(handles.axes39, 'visible', 'off');
%         set(handles.uipanel131, 'visible', 'off');
%         set(handles.axes40, 'visible', 'off');
%         set(handles.uipanel132, 'visible', 'off');
%         set(handles.axes41, 'visible', 'off');
%         set(handles.uipanel133, 'visible', 'off');
%         set(handles.axes42, 'visible', 'off');
%         set(handles.uipanel134, 'visible', 'off');
%         set(handles.axes43, 'visible', 'off');
%         set(handles.uipanel135, 'visible', 'off');
%         set(handles.axes44, 'visible', 'off');
%         set(handles.uipanel136, 'visible', 'off');
%         set(handles.axes45, 'visible', 'off');
%         set(handles.uipanel137, 'visible', 'off');
%         set(handles.axes46, 'visible', 'off');
%         set(handles.uipanel138, 'visible', 'off');
%         set(handles.axes47, 'visible', 'off');
%         set(handles.uipanel139, 'visible', 'off');
%         set(handles.axes48, 'visible', 'off');
%         set(handles.uipanel140, 'visible', 'off');
%         set(handles.axes49, 'visible', 'off');
%         set(handles.uipanel141, 'visible', 'off');
%         set(handles.axes50, 'visible', 'off');
%         set(handles.uipanel142, 'visible', 'off');
%         set(handles.axes51, 'visible', 'off');
%         set(handles.uipanel143, 'visible', 'off');
%         set(handles.axes52, 'visible', 'off');
%         set(handles.uipanel144, 'visible', 'off');
%         set(handles.axes53, 'visible', 'off');
%     set(handles.uipanel1, 'visible', 'on');
%         set(handles.text152, 'visible', 'on');
%         set(handles.browse_for_image, 'visible', 'on');
%         set(handles.textbox_for_browsed_image, 'visible', 'on');
%         set(handles.clear_all_button, 'visible', 'on');
%     set(handles.intensity_vs_frequency_spectrum_panel, 'visible', 'on');
%         set(handles.uipanel30, 'visible', 'on');
%         set(handles.move_lower_bar, 'visible', 'on');
%         set(handles.text160, 'visible', 'on');
%         set(handles.move_lower_bar_forward, 'visible', 'on');
%         set(handles.diagonal_line_scan, 'visible', 'on');
%         set(handles.text164, 'visible', 'on');
%         set(handles.uipanel104, 'visible', 'on');
%         set(handles.prev_time_for_mz_plot, 'visible', 'on');
%         set(handles.text162, 'visible', 'on');
%         set(handles.next_time_for_mz_plot, 'visible', 'on');
%         set(handles.uipanel31, 'visible', 'on');
%         set(handles.move_upper_bar_backward, 'visible', 'on');
%         set(handles.text161, 'visible', 'on');
%         set(handles.move_upper_bar, 'visible', 'on');
%         set(handles.time_bar_box, 'visible', 'on');          
%     set(handles.uipanel109, 'visible', 'on');
%         set(handles.uipanel3, 'visible', 'on');
%         set(handles.text139, 'visible', 'on');
%         set(handles.select_image_to_display, 'visible', 'on');
%         set(handles.normalize_data_checkbox, 'visible', 'on');
%         set(handles.normalize_data_lower_limit, 'visible', 'on');
%         set(handles.text144, 'visible', 'on');
%         set(handles.normalize_data_higher_limit, 'visible', 'on');
%         set(handles.apply_manipulations_to_all_images, 'visible', 'on');
%         set(handles.redo_for_new_ranges, 'visible', 'on');
%         set(handles.save_settings, 'visible', 'on');
%         set(handles.export_pixel_vals_excel, 'visible', 'on');
%         set(handles.align_sum_of_intensities, 'visible', 'on');
%         set(handles.uipanel97, 'visible', 'on');
%         set(handles.remove_lines_from_grayscale_image, 'visible', 'on');
%         set(handles.remove_lines_edit_box, 'visible', 'on');
%         set(handles.uipanel89, 'visible', 'on');
%         set(handles.text74, 'visible', 'on');
%         set(handles.text158, 'visible', 'on');
%         set(handles.editbox_across_interpolated_data, 'visible', 'on');
%         set(handles.text75, 'visible', 'on');
%         set(handles.editbox_down_interpolated_data, 'visible', 'on');
%         set(handles.show_interpolated_sum_of_intensities, 'visible', 'on');
%         set(handles.overlay_images_panel, 'visible', 'on');
%         set(handles.uipanel88, 'visible', 'on');
%         set(handles.uipanel149, 'visible', 'on');
%         set(handles.text40, 'visible', 'on');
%         set(handles.text159, 'visible', 'on');
%         set(handles.new_lowest_gray_value, 'visible', 'on');
%         set(handles.text42, 'visible', 'on');
%         set(handles.new_highest_gray_value, 'visible', 'on');
%         set(handles.display_grayscale_image_with_new_limits, 'visible', 'on');
%         set(handles.text169, 'visible', 'on');
%         set(handles.avg_image_pixels, 'visible', 'on');
%         set(handles.max_val, 'visible', 'on');
%         set(handles.display_avg_pixels, 'visible', 'on');
%         set(handles.uipanel101, 'visible', 'on');
%         set(handles.text142, 'visible', 'on');
%         set(handles.lower_limit_axes1, 'visible', 'on');
%         set(handles.text140, 'visible', 'on');
%         set(handles.upper_limit_axes1, 'visible', 'on');
%         set(handles.register_image, 'visible', 'on');
%         set(handles.ROI_method, 'visible', 'on');
%         set(handles.zone_specified_plot, 'visible', 'on');
%         set(handles.uipanel105, 'visible', 'on');
%         set(handles.prev_sum_of_intensities_number, 'visible', 'on');
%         set(handles.next_sum_of_intensities_number, 'visible', 'on');
%         set(handles.uipanel102, 'visible', 'on');
%         set(handles.text143, 'visible', 'on');
%         set(handles.lower_limit_axes2, 'visible', 'on');
%         set(handles.text141, 'visible', 'on');
%         set(handles.upper_limit_axes2, 'visible', 'on');
%         set(handles.zone_specified_plot2, 'visible', 'on');
%     set(handles.uipanel19, 'visible', 'on');
%         set(handles.across_aspect_ratio_static, 'visible', 'on');
%         set(handles.text155, 'visible', 'on');
%         set(handles.aspect_ratio_across_edit, 'visible', 'on');
%         set(handles.down_aspect_ratio_static, 'visible', 'on');
%         set(handles.aspect_ratio_down_edit, 'visible', 'on');
%         set(handles.enter_scaling_values, 'visible', 'on');
%         set(handles.reset_scale_button, 'visible', 'on');
%     set(handles.time_panel,'Visible','on');
%         set(handles.software_free,'Visible','on');  
%     set(handles.uipanel6, 'visible', 'on');
%         set(handles.text_for_number_of_scans, 'visible', 'on');
%         set(handles.start, 'visible', 'on');
%         set(handles.text156, 'visible', 'on');
%         set(handles.text82, 'visible', 'on');
%         set(handles.start_with_line_number_editbox, 'visible', 'on');
%     set(handles.enter_mz_range_panel, 'visible', 'on');
%         set(handles.text165, 'visible', 'on');
%         set(handles.lower_limit_mz_value_static, 'visible', 'on');
%         set(handles.lower_limit_mz_value_box, 'visible', 'on');
%         set(handles.upper_limit_mz_value_static, 'visible', 'on');
%         set(handles.upper_limit_mz_value_box, 'visible', 'on');
%         set(handles.text86, 'visible', 'on');
%         set(handles.enter_vals_for_multiple_mz, 'visible', 'on');
%         set(handles.text87, 'visible', 'on');
%         set(handles.editbox_for_enter_threshold_value, 'visible', 'on');
%         set(handles.freq_range_selected, 'visible', 'on');
%         set(handles.stop_running_loop, 'visible', 'on'); 
%     set(handles.uipanel100, 'visible', 'on');
%         set(handles.text94, 'visible', 'on');
%         set(handles.mz_value_1, 'visible', 'on');
%         set(handles.axes_for_mz_values_1, 'visible', 'on');
%         set(handles.text95, 'visible', 'on');
%         set(handles.mz_value_2, 'visible', 'on');
%         set(handles.axes_for_mz_values_2, 'visible', 'on');
%         set(handles.text96, 'visible', 'on');
%         set(handles.mz_value_3, 'visible', 'on');
%         set(handles.axes_for_mz_values_3, 'visible', 'on');
%         set(handles.text97, 'visible', 'on');
%         set(handles.mz_value_4, 'visible', 'on');
%         set(handles.axes_for_mz_values_4, 'visible', 'on');
%         set(handles.text98, 'visible', 'on');
%         set(handles.mz_value_5, 'visible', 'on');
%         set(handles.axes_for_mz_values_5, 'visible', 'on');
%         set(handles.text99, 'visible', 'on');
%         set(handles.mz_value_6, 'visible', 'on');
%         set(handles.axes_for_mz_values_6, 'visible', 'on');
%         set(handles.transfer_to_alfresco, 'visible', 'on');
%         set(handles.close_multiple_mz_panel, 'visible', 'on');
%         set(handles.text166, 'visible', 'on');
%     set(handles.uipanel83, 'visible', 'on');
%         set(handles.refresh_image, 'visible', 'on');
%         xnorm = bb;
%     new_min = 0;    %min of 0 to 255
%     new_max = 100;  %max of 0 to 255
%     old_min = min(bb(:));
%     old_max = max(bb(:));
%     for i = 1:size(bb,1)
%         for j2 = 1:size(bb,2)
%             value = bb(i, j2);
%             xnorm(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
%         end
%     end
%     if isempty(image_window_to_display_value) 
%         image_window_to_display_value = 1;
%     end
%     if image_window_to_display_value == 1
%         set(handles.lower_limit_axes1,'string',num2str(lower_limits_count(1)));    
%         set(handles.upper_limit_axes1,'string',num2str(upper_limits_count(1)));
%         cla(handles.zone_specified_plot);
%         axes(handles.zone_specified_plot);
%     else
%         set(handles.lower_limit_axes2,'string',num2str(lower_limits_count(1)));
%         set(handles.upper_limit_axes2,'string',num2str(upper_limits_count(1)));
%         cla(handles.zone_specified_plot2);
%         axes(handles.zone_specified_plot2);
%     end
%     imagesc(xnorm);%(sum_of_intensities);
%     xlabel('Scan'); ylabel('Line');
%     colormap(colormap_3d); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
%     next_sum_folder = 1;
%     sum_of_intensities = xnorm;
%     cd(current_dir2)
    disp('Done !!!')
