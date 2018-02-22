function redo_for_spreadsheet(hObject, handles)
    handles.stop_val = 0;
    if handles.autoflow == 0;
        button = questdlg('Load an Excel (.xls) File ?',...
            'Use User Inputs or Excel',...
            'OK','Cancel','OK');
    else
        button = 'OK';
    end
    switch button
        case 'OK'
            if handles.autoflow == 0
                [handles.RedoFileName,handles.RedoPathName] = uigetfile('*.xls','Select the Excel file');
                [~,Redosheets] = xlsfinfo([handles.RedoPathName handles.RedoFileName]);
                [handles.redo_s,~] = listdlg('PromptString','Select a file:',...
                    'SelectionMode','single',...
                    'ListString',Redosheets);
            else
                [~,Redosheets] = xlsfinfo([handles.RedoPathName handles.RedoFileName]);
            end
            num = xlsread([handles.RedoPathName handles.RedoFileName],Redosheets{1,handles.redo_s});
            handles.upper_limit_mz_value = 1;
            prompt = {'Enter first row #:','Enter last row #:', 'Enter PDF # to save:'};
            dlg_title = 'Required Inputs';
            num_lines = 1;
            def = {'1','end', '1'};
            if handles.autoflow == 0
                handles.redoanswer2 = inputdlg(prompt,dlg_title,num_lines,def);
            else
                handles.redoanswer2 = [handles.redoanswer2; handles.redoanswer];
            end
            if strcmp(handles.redoanswer2{2,1},'end')
                num = num((str2num(handles.redoanswer2{1,1}):end),:);
            else
                num = num((str2num(handles.redoanswer2{1,1}):str2double(handles.redoanswer2{2,1})),:);
            end
        case 'Cancel'
            handles.upper_limit_mz_value = get(handles.upper_limit_mz_value_box, 'string'); handles.upper_limit_mz_value = str2double(handles.upper_limit_mz_value);
    end
    if exist(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,'Cluster_Temp'),'file')
        rmdir(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,'Cluster_Temp'),'s')
    end
    new_no = handles.redoanswer2{3,1};
    disp('Please Wait !!!')
    set(handles.software_free, 'BackgroundColor', 'red');
    pause(.15)
    if exist(strcat(handles.pathname,handles.saveImagesToFolder,filesep,'pdf_list',new_no,'.pdf'),'file')
        delete(strcat(handles.pathname,handles.saveImagesToFolder,filesep,'pdf_list',new_no,'.pdf'))
    end
    current_dir2 = pwd;
    cd(strcat(handles.pathname,'CDF_Files'))
    if ~isfield(handles, 'upper_limit_mz_value') 
        xx = find(handles.pathname(1:end-1)==filesep);
        mat_filename = handles.pathname(xx(end)+1:end-1);
        load(strcat(handles.pathname,mat_filename,'.mat'));
        handles.filename = list{1,1}; %#ok<*NODEF>
        handles.count_2 = list{1,2};
        handles.number_of_scans = list{1,3};
        handles.colormap_3d = list{1,6};
        handles.O_was_present = list{1,7};
        handles.lower_limit_mz_value = list{1,8};
        handles.upper_limit_mz_value = list{1,9};
        handles.single_range_value = list{1,10};
        handles.double_range_value = list{1,11};
        handles.check_point_count = list{1,12};
        handles.image_window_to_display_value = list{1,13};
        handles.next_sum_folder = list{1,14};
        handles.size_count_limits = list{1,15};
        handles.upper_limits_count = list{1,16};
        handles.lower_limits_count = list{1,17};
        handles.normalize_data_mode = list{1,18};
        across_val = list{1,40};
        down_val = list{1,41};
        handles.apply_manipulations_to_all = list{1,42};
        handles.val1_lower_lim = list{1,22};
        set(handles.start_with_line_number_editbox,'string',num2str(list{1,20}));
        handles.pathname = list{1,21};
        set(handles.apply_manipulations_to_all_images, 'Value',handles.apply_manipulations_to_all);
        set(handles.lower_limit_mz_value_box, 'string',num2str(handles.lower_limit_mz_value));
        set(handles.upper_limit_mz_value_box, 'string',num2str(handles.upper_limit_mz_value));
        handles.sum_of_intensities = NaN([list{1,4},list{1,5}]);
        set(handles.text_for_number_of_scans, 'string',num2str(handles.number_of_scans));
        set(handles.enter_vals_for_multiple_mz, 'string',num2str(list{1,38}));
        set(handles.editbox_for_enter_threshold_value, 'string',num2str(list{1,39}));
        set(handles.aspect_ratio_across_edit, 'string',num2str(across_val));
        set(handles.aspect_ratio_down_edit, 'string',num2str(down_val));
        set(handles.normalize_data_checkbox, 'Value',list{1,45});
        set(handles.normalize_data_lower_limit, 'string',num2str(list{1,46}));
        set(handles.normalize_data_higher_limit, 'string',num2str(list{1,47}));
        set(handles.remove_lines_edit_box, 'string',num2str(list{1,48}));
        set(handles.editbox_across_interpolated_data, 'string',num2str(list{1,49}));
        set(handles.editbox_down_interpolated_data, 'string',num2str(list{1,50}));
        set(handles.new_lowest_gray_value, 'string',num2str(list{1,52}));
        set(handles.new_highest_gray_value, 'string',num2str(list{1,51}));
        handles.org_sum_of_int1 = list{1,53};
        handles.org_sum_of_int2 = list{1,54};
        guidata(hObject,handles);
        handles = prev_sum_of_intensities_number_Callback(hObject,[],[]);
    end
    k = get(handles.start_with_line_number_editbox,'string');
    k = single(str2double(k)); 
    if handles.count_2 == 1
        handles.count_2 = 2;
    else
        handles.count_2 = handles.number_of_scans + 1;
    end
    for i = 1:handles.count_2-1
        done_with_loop = tic;
        fake_name2 = handles.ll{1,k};
        fake_name2(end-3:end) = '.hdf';
        RAW_filename_new2 = strcat(handles.pathname,'HDF_Files',filesep,fake_name2);
        intensity_values = hdf5read(RAW_filename_new2,'intensity_values');
        mass_values = hdf5read(RAW_filename_new2,'mass_values');
        scan_acquisition_time = hdf5read(RAW_filename_new2,'scan_acquisition_time');
        scan_acquisition_time = scan_acquisition_time/60;
        point_count = hdf5read(RAW_filename_new2,'point_count');
        total_intensity = hdf5read(RAW_filename_new2,'total_intensity');
        min_time_final = min(scan_acquisition_time(:));
        max_time_final = max(scan_acquisition_time(:));
        min_time = min(scan_acquisition_time(:)); max_time = max(scan_acquisition_time(:));
        handles.lower_limits_count = num(:,1);
        handles.lower_limits_count = handles.lower_limits_count';
        handles.upper_limits_count = num(:,2);
        handles.upper_limits_count = handles.upper_limits_count';
        handles.size_count_limits = size(handles.lower_limits_count,2);
        list = cell(1,size(handles.lower_limits_count,2));
        for i55 = 1: size(handles.lower_limits_count,2)
            list{i55} = [num2str(handles.lower_limits_count(i55)) '-' num2str(handles.upper_limits_count(i55))];
        end
        set(handles.mz_list_ion_image, 'String', list);
        set(handles.listbox_for_mz_values,'String', list);
        set(handles.listbox_for_mz_values,'Value', 1:numel(list));
        for oo = 1: size(handles.lower_limits_count,2)
            get(hObject,'Value');
            if handles.stop_val == 1
                break;
            end
            sum_of_intensities_temp3 = zeros(1,numel(point_count));
            sum_of_intensities_normalize = zeros(1,numel(point_count));
            handles.lower_limit_mz_value = handles.lower_limits_count(oo);
            handles.upper_limit_mz_value = handles.upper_limits_count(oo);
            low_bar = single(handles.lower_limit_mz_value);
            high_bar = single(handles.upper_limit_mz_value);
            for scan_numb = 1:numel(point_count)
                int_val = intensity_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
                mass_val = mass_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
                if ~isfield(handles, 'single_range_value')                    
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
                    lower_number_new = lower_number;
                    higher_number_new = higher_number;
                elseif isempty(handles.double_range_value)
                    if isempty(single_limit_mz_value)
                        uiwait
                    end
                    h_lower = imline(gca, [single_limit_mz_value single_limit_mz_value], [0 max(int_val(:))]);
                    api = iptgetapi(h_lower);
                    api.setColor([1 0 0]);
                    fcn = makeConstrainToRectFcn('imline', [0, max(mass_val(:))],...
                        [0, max(int_val(:))]);
                    api.setPositionConstraintFcn(fcn);
                    axis tight
                    low_bar = single(single_limit_mz_value);
                    single_number_forward = (find(mass_val >= low_bar,1,'first'));
                    single_number_backward = (find(mass_val > low_bar,1,'last'));
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
                end
                sum_of_intensities_temp3(1,scan_numb) = sum(int_val(lower_number_new:higher_number_new));
                normalize_data_lower_lim = get(handles.normalize_data_lower_limit,'string');
                normalize_data_lower_lim = single(str2num(normalize_data_lower_lim));
                normalize_data_higher_lim = get(handles.normalize_data_higher_limit,'string');
                normalize_data_higher_lim = single(str2num(normalize_data_higher_lim));
                if ~normalize_data_lower_lim
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
                    lower_number_new_normalize = lower_number_normalize;
                    higher_number_new_normalize = higher_number_normalize;
                    sum_of_intensities_normalize(1,scan_numb) = sum(int_val(lower_number_new_normalize:higher_number_new_normalize));
                end
            end
            if handles.normalize_data_mode == 1 && isempty(normalize_data_lower_lim)
                sum_of_intensities_temp3 = sum_of_intensities_temp3./total_intensity';
            elseif handles.normalize_data_mode == 1 && ~isempty(normalize_data_lower_lim)
                sum_of_intensities_temp3 = sum_of_intensities_temp3./sum_of_intensities_normalize;
                sum_of_intensities_temp3(isinf(sum_of_intensities_temp3)) = 0;
            end
            current_dir = pwd;
            cd(strcat(handles.pathname,handles.saveTempFilesToFolder))
            if i == 1
                sum_of_intensities_temp2 = sum_of_intensities_temp3;
                vname = sprintf('x%d',i);
                eval([vname, '=sum_of_intensities_temp2;'])
                save(strcat('sum_of_intensities',num2str(oo+1),'.mat'),vname)
                row_num = 1;
            else
                sum_of_intensities_temp2 = sum_of_intensities_temp3;
                vname = sprintf('x%d',i);
                eval([vname, '=sum_of_intensities_temp2;'])
                save(strcat('sum_of_intensities',num2str(oo+1),'.mat'),vname,'-append')
                if handles.stop_val == 1
                    break;
                end
            end
            cd(current_dir)
        end
        k = k + 1;
        row_num = row_num + 1;
        done_with_loop_time = toc(done_with_loop);
        inform_user('Process 1: Saving temporary files-', handles, i, done_with_loop_time, handles.count_2-1);
%         set(handles.inform_user,'String',['Process-1 : Line ' num2str(i) '/' num2str(handles.count_2-1) '. Time remaining- ' num2str(done_with_loop_time.*((handles.count_2-1)-i))]);
        pause(.0001);
    end
    current_dir = pwd;
    cd(strcat(handles.pathname,handles.saveTempFilesToFolder))
    for i = 1:size(handles.lower_limits_count,2)
        done_with_loop = tic;
        handles.sum_of_intensities2 = NaN([handles.org_sum_of_int1,handles.org_sum_of_int2]);
        load(strcat('sum_of_intensities',num2str(i+1),'.mat'));
        for j = 1:size(handles.sum_of_intensities2,1)
            vname = sprintf('x%d',j);
            eval_vname = size(eval(vname),2);
            handles.sum_of_intensities2(j,1:eval_vname) = eval(vname);
        end
        sum_of_intensities2 = handles.sum_of_intensities2; %#ok<*NASGU>
        save(strcat('sum_of_intensities',num2str(i+1),'.mat'),'sum_of_intensities2');
        done_with_loop_time = toc(done_with_loop);
        inform_user('Process 2: Saving temporary files-', handles, i, done_with_loop_time, size(handles.lower_limits_count,2));
%         set(handles.inform_user,'String',['Process-2 : Line ' num2str(i) '/' num2str(handles.count_2-1) '. Time remaining- ' num2str(done_with_loop_time.*((size(handles.lower_limits_count,2))-i))]);
        pause(.0001);
    end
    cd(current_dir)
    subplot_count = 1;
    pdf_count = 1;
    for gg = 1: size(handles.lower_limits_count,2)
        done_with_loop = tic;
        x5 = load(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,'sum_of_intensities',num2str(gg+1)));
        x5 = x5.sum_of_intensities2;
        if isfield(handles, 'apply_manipulations_to_all') && handles.apply_manipulations_to_all == 1;
            %% Avergae Image Pixels
            if handles.avg_image_pixels == 1
                max_val = get(handles.max_val,'string');
                lim_val = single(str2double(max_val));
                x5 = scale_image_to_fixed_limits(0, 100, x5);
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
            end            
            %% Align Image
            filename2 = handles.filename;
            x5 = interpolation_code(handles);
            %% Remove unwanted lines
            lines_to_remove_from_image = get(handles.remove_lines_edit_box, 'string');
            lines_to_remove_from_image = str2double(lines_to_remove_from_image);
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
            lower_limit_for_grayscale_color = str2double(lower_limit_for_grayscale_color);
            higher_limit_for_grayscale_color = str2double(higher_limit_for_grayscale_color);
        end
        xnorm = scale_image_to_fixed_limits(0, 100, x5);
        if isfield(handles, 'apply_manipulations_to_all') && handles.apply_manipulations_to_all == 1
            if ~isempty(lower_limit_for_grayscale_color)
                x5 = xnorm;
                x5(xnorm < lower_limit_for_grayscale_color) = lower_limit_for_grayscale_color;% - 5;
                x5(xnorm > higher_limit_for_grayscale_color) = higher_limit_for_grayscale_color;% + 5;
            end
        else
            xnorm = scale_image_to_fixed_limits(0, 100, x5);
            x5 = xnorm;
        end
        if gg == 1
            mkdir([handles.pathname, handles.saveTempFilesToFolder, filesep, 'Cluster_Temp'])
        end
        if subplot_count == 1
            axes(handles.axes39)
        elseif subplot_count == 2
            axes(handles.axes40)
        elseif subplot_count == 3
            axes(handles.axes41)
        elseif subplot_count == 4
            axes(handles.axes42)
        elseif subplot_count == 5
            axes(handles.axes43)
        elseif subplot_count == 6
            axes(handles.axes44)
        elseif subplot_count == 7
            axes(handles.axes45)
        elseif subplot_count == 8
            axes(handles.axes46)
        elseif subplot_count == 9
            axes(handles.axes47)
        elseif subplot_count == 10
            axes(handles.axes48)
        elseif subplot_count == 11
            axes(handles.axes49)
        elseif subplot_count == 12
            axes(handles.axes50)
        elseif subplot_count == 13
            axes(handles.axes51)
        elseif subplot_count == 14
            axes(handles.axes52)
        elseif subplot_count == 15
            axes(handles.axes53)
        end
        %% Adjust Aspect Ratio
        if isfield(handles, 'temp2')
            set(gca,'Position',[handles.temp5(1) handles.temp5(2) handles.temp5(3) handles.temp5(4)])
        end
        if isfield(handles, 'apply_manipulations_to_all') && handles.apply_manipulations_to_all == 1
            if isfield(handles, 'changed_aspect_ratio') && handles.changed_aspect_ratio == 1
                across_val = get(handles.aspect_ratio_across_edit,'string');
                down_val = get(handles.aspect_ratio_down_edit,'string');
                temp1 = get(gca,'Position');
                handles.temp2 = temp1;
                if isempty(handles.temp5)
                    handles.temp5 = temp1;
                end
                down_val = str2double(down_val);
                across_val = str2double(across_val);
                if down_val > across_val
                    width = (handles.temp2(3)*(across_val/down_val));
                    set(gca,'Position',[temp1(1) temp1(2) width temp1(4)]) % change axis position
                else
                    height = (handles.temp2(4)*(down_val/across_val));
                    set(gca,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
                end
            end
        end
        text_color = [1,0,0];
        x5 = remove_noise_spikes_from_image(x5, 20);
        x5 = scale_image_to_fixed_limits(0, 100, x5);
        imagesc(x5); colormap(handles.colormap_3d)
        title(strcat(' {\it mz } ', num2str(num(gg,1)),'-',num2str(num(gg,2))),'FontSize',6.5,'Color',text_color); colormap(strcat(handles.colormap_3d,'(32)'));%pause(.5);
        axis off
        if subplot_count == 15 || gg == size(handles.lower_limits_count,2)
            subplot_count = 0;
            fnout = [handles.pathname, handles.saveTempFilesToFolder, filesep, 'Cluster_Temp', filesep, 'images',num2str(pdf_count), '.pdf'];
            export_fig(handles.uipanel145, fnout);
            pdf_count = pdf_count + 1;
            for fig_axes_no = 39:53
                cla(handles.(['axes',num2str(fig_axes_no)]))
                title(handles.(['axes',num2str(fig_axes_no)]),' ')
            end
        end
        subplot_count = subplot_count + 1;
        if gg == 1;
            bb = x5;
        end
        done_with_loop_time = toc(done_with_loop);
        inform_user('Process 3: Drawing Images-', handles, gg, done_with_loop_time, size(handles.lower_limits_count,2));
%         set(handles.inform_user,'String',['Process-3 : mz ' num2str(gg) '/' num2str(size(handles.lower_limits_count,2)) '. Time remaining- ' num2str(done_with_loop_time.*((size(handles.lower_limits_count,2))-gg))]);
        pause(.0001);
    end
    if ispc
        status = system(['pdftk' ' ' strcat('"',handles.pathname, handles.saveTempFilesToFolder, filesep, 'Cluster_Temp',filesep,'*.pdf','"') ' ' 'output' ' ' strcat('"',handles.pathname,'Images',filesep,'pdf_list',new_no,'.pdf','"')]);
        if status
            warndlg('pdftk library might be missing, please download from this link and rename to pdftk.exe - https://www.pdflabs.com/tools/pdftk-server/')
            web('https://www.pdflabs.com/tools/pdftk-server/','-browser')
        end
    else
        warndlg('pdftk library is only available on Windows Platform, so MSI QuickView will not be able to save all images to a single pdf.')
    end
    xnorm = scale_image_to_fixed_limits(0, 100, bb);
    which_image_window(handles.image_window_to_display_value, xnorm, handles.lower_limits_count(1), handles.upper_limits_count(1), handles.colormap_3d, handles);
    handles.next_sum_folder = 1;
    handles.sum_of_intensities = xnorm;
    cd(current_dir2)
    handles = set_proven_variable(hObject, 'redoImageExcelfileName', handles.RedoFileName, handles);
    handles = set_proven_variable(hObject, 'redoImage', handles.RedoPathName, handles);
    handles = set_proven_variable(hObject, 'redoImageExcelSheetName', num2str(handles.redo_s), handles);
    redoanswer2_b = strjoin(handles.redoanswer2(1:2),', ');
    handles = set_proven_variable(hObject, 'redoImageExcelmzRows', redoanswer2_b, handles);
    redoanswer_b = strjoin(handles.redoanswer2(3),', ');
    handles = set_proven_variable(hObject, 'redoImagePDFno', redoanswer_b, handles);
    handles.execs{numel(handles.execs)+1} = 'redo_for_new_ranges_Callback(hObject,[],handles)';
    guidata(hObject,handles);
    disp('Done !!!')
    set(handles.software_free, 'BackgroundColor', 'green');
