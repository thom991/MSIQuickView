function handles = continue_plotting(hObject, handles)
    set(handles.software_free, 'BackgroundColor', 'red');
    handles.k_final_2 = 1;
    handles.sum_of_intensities = zeros(handles.number_of_scans, numel(handles.point_count));
    sum_of_intensities_temp = zeros(1, numel(handles.point_count));
    handles.user_input_for_mode_auto = 1;
    handles.k = get(handles.start_with_line_number_editbox,'string');
    handles.k = single(str2double(handles.k)); %k tells us which line # to start from ...for eg, ROW 3-3.raw...So user will enter 3.
    k_start = handles.k;  %renaming k since the variable k is used again
    %% End of Use to initialize sum_of_intensities with NAN'S
    handles.count_2 = 1;
    handles.sliderValue_m = 1;
    handles.sliderValue_n = 1;
    fake_name2 = handles.ll{1,handles.k};
    set(handles.filename_display_for_int_freq_spec, 'String', fake_name2);
    handles.cdf_begin = strcat(handles.pathname,'CDF_Files',filesep,fake_name2);
    handles.cdf_filename = [handles.cdf_begin(1:end-4) '.cdf' ];
    cd(handles.pathname(1:end-1));
    min_time_final = min(handles.scan_acquisition_time(:));
    max_time_final = max(handles.scan_acquisition_time(:));
    low_bar = handles.lower_limit_mz_value;
    high_bar = handles.upper_limit_mz_value;
    for scan_numb = 1:numel(handles.point_count)
        int_val = handles.intensity_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
        mass_val = handles.mass_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
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
            end
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
        lower_number_new = lower_number;%(1);%(1) + sum(point_count(2:i2));
        higher_number_new = higher_number;%(end);%(1) + sum(point_count(2:i2));
        handles.sum_of_intensities(handles.count_2,scan_numb) = sum(int_val(lower_number_new:higher_number_new));
    end
    hold off
    xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    xnorm = remove_noise_spikes_from_image(xnorm, 20);
    xnorm = scale_image_to_fixed_limits(0, 100, xnorm);
    
    if strcmp(handles.button,'Use excel spreadsheet')
        [num, handles.lower_limits_count, handles.upper_limits_count] = redo_mz_ranges_excel_real_time(1);
    end
    if handles.image_window_to_display_value == 1
        axes(handles.zone_specified_plot);
    else
        axes(handles.zone_specified_plot2);
    end
    PSF = fspecial('average', [handles.sliderValue_m handles.sliderValue_n]);
    imagesc(imfilter(xnorm(1:size(xnorm,1), 1:size(xnorm,2)), PSF));
    xlabel('Scans'); ylabel('Lines');
    colormap(handles.colormap_3d); set_colorbar();
    %% Multiple MZ values for each row
    handles.enter_multiple_values = get(handles.enter_vals_for_multiple_mz,'string');
    handles.enter_multiple_values = single(str2num(handles.enter_multiple_values)); 
    threshold_values = get(handles.editbox_for_enter_threshold_value,'string');
    threshold_values = single(str2num(threshold_values)); %#ok<*ST2NM>
    if ~isempty(handles.enter_multiple_values)
        for number_of_mz_values = 1:size(handles.enter_multiple_values,2)
            if ~isempty(threshold_values)
                upper_limit_mz_value2 = handles.enter_multiple_values(number_of_mz_values) + threshold_values;
                lower_limit_mz_value2 = handles.enter_multiple_values(number_of_mz_values) - threshold_values;
                low_bar2 = single(lower_limit_mz_value2);
                high_bar2 = single(upper_limit_mz_value2);
                for scan_numb = 1:size(handles.point_count,1)
                    int_val = handles.intensity_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
                    mass_val = handles.mass_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
                    single_number_forward = (find(mass_val >= low_bar2,1,'first'));
                    single_number_backward = (find(mass_val < low_bar2,1,'last'));
                    diff_forward = abs(low_bar2 - mass_val(single_number_forward(1)));
                    if ~isempty(single_number_backward)
                        diff_backward = abs(low_bar2 - mass_val(single_number_backward(end)));
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
                        end
                    end
                    high_single_number_forward = (find(mass_val >= high_bar2,1,'first'));
                    high_single_number_backward = (find(mass_val < high_bar2,1,'last'));
                    high_diff_forward = abs(high_bar2 - mass_val(high_single_number_forward(1)));
                    if ~isempty(high_single_number_backward)
                        high_diff_backward = abs(high_bar2 - mass_val(high_single_number_backward(end)));
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
                    sum_of_intensities_temp(1,scan_numb) = sum(int_val(lower_number_new:higher_number_new));
                end
            end
            if number_of_mz_values == 1
                axes(handles.axes_for_mz_values_1);plot(handles.scan_acquisition_time, sum_of_intensities_temp); set(handles.mz_value_1, 'String', handles.enter_multiple_values(1)); %#ok<*LAXES>
            elseif number_of_mz_values == 2
                axes(handles.axes_for_mz_values_2);plot(handles.scan_acquisition_time, sum_of_intensities_temp); set(handles.mz_value_2, 'String', handles.enter_multiple_values(2));
            elseif number_of_mz_values == 3
                axes(handles.axes_for_mz_values_3);plot(handles.scan_acquisition_time, sum_of_intensities_temp); set(handles.mz_value_3, 'String', handles.enter_multiple_values(3));
            elseif number_of_mz_values == 4
                axes(handles.axes_for_mz_values_4);plot(handles.scan_acquisition_time, sum_of_intensities_temp); set(handles.mz_value_4, 'String', handles.enter_multiple_values(4));
            elseif number_of_mz_values == 5
                axes(handles.axes_for_mz_values_5);plot(handles.scan_acquisition_time, sum_of_intensities_temp); set(handles.mz_value_5, 'String', handles.enter_multiple_values(5));
            elseif number_of_mz_values == 6
                axes(handles.axes_for_mz_values_6);plot(handles.scan_acquisition_time, sum_of_intensities_temp); set(handles.mz_value_6, 'String', handles.enter_multiple_values(6));
            end
        end
    end
    if handles.number_of_scans > 1
        handles.count_2 = handles.count_2 + 1;
        handles.k = handles.k + 1;
        if handles.user_input_for_mode_auto == 1
            cd(handles.pathname);
            handles.time_taken_to_save_whole_file = zeros(1,numel(handles.number_of_scans));
            tcount = 1;
            for i_key = 1:10000
                tic
                pause(.5);
                fake_name2 = handles.ll{1,handles.k};
                if handles.k+1 <= handles.number_of_scans
                    fake_name_next = handles.ll{1,handles.k+1};%fake_name2;
                else
                    if isempty(handles.repeat_time)
                        max_time = max(handles.time_taken_to_save_whole_file(:));
                        pause(max_time)
                    end
                    fake_name_next = fake_name2;
                end
                fprintf('Converting %s \n', fake_name2);
                set(handles.filename_display_for_int_freq_spec, 'String', fake_name2);
                handles.RAW_filename_new2 = strcat(handles.pathname,fake_name2);
                handles.cdf_begin = strcat(handles.pathname,'CDF_Files',filesep,fake_name2);
                hdf_begin = strcat(handles.pathname,'HDF_Files',filesep,fake_name2);
                handles.cdf_filename = [handles.cdf_begin(1:end-4) '.cdf' ];
                hdf_filename = [hdf_begin(1:end-4) '.hdf' ];
                cd(handles.pathname(1:end-1));
                for it = 1:40
                    if exist(strcat(handles.pathname,fake_name_next), 'file') || exist(handles.cdf_filename, 'file') || exist(hdf_filename, 'file')
                        break;
                    else
                        pause(30)
                    end
                end
                if exist(strcat(handles.pathname,fake_name_next),'file')|| exist(handles.cdf_filename,'file') || exist(hdf_filename,'file')
                    if ~exist(handles.cdf_filename,'file') || ~exist(hdf_filename,'file')
                        cmd = sprintf ('C:\\Xcalibur\\system\\programs\\XConvert /SL /DA "%s" /O "%s"',handles.RAW_filename_new2,strcat(handles.pathname,'CDF_Files'));    %filename format for conversion into cdf
                        system (cmd);
                        for bg = 1:281474976710655
                            if exist(handles.cdf_filename, 'file') || exist(hdf_filename, 'file');
                                break;
                            end
                        end
                        pause(.5);
                    end
                    if handles.k_final_2 < handles.number_of_scans+1
                        if strcmp(handles.ext, '.cdf') || strcmp(handles.ext, '.raw') || strcmp(handles.ext, '.RAW')  || strcmp(handles.ext, '.mat')
                            api = cdf_files();
                            handles = api.read_cdf_file(handles);
                        elseif strcmp(handles.ext, '.hdf')
                            handles = read_hdf_file(handles);
                        end
                        min_time = min(handles.scan_acquisition_time(:)); max_time = max(handles.scan_acquisition_time(:));
                        min_time_final = max([min_time_final min_time]); max_time_final = min([max_time_final max_time]);
                        %%SAVE HDF
                        if ~exist(hdf_filename,'file')
                            hdf5write(hdf_filename,'intensity_values',handles.intensity_values,'mass_values',handles.mass_values,'point_count',handles.point_count,'total_intensity',handles.total_intensity,'scan_acquisition_time',handles.scan_acquisition_time,'mass_range_max',handles.mass_range_max,'mass_range_min',handles.mass_range_min);
                        end
                        for time_bar_val = 1%:size(point_count,1)
                            sure1_mass(1:handles.point_count(time_bar_val)) = handles.mass_values(1:(handles.point_count(time_bar_val)));%+start_val-1));
                            sure1_intensity(1:handles.point_count(time_bar_val)) = handles.intensity_values(1:(handles.point_count(time_bar_val)));%+start_val-1));
                        end
                        handles.max_intensity = (max(sure1_intensity(:)));
                        handles.max_mass = max(sure1_mass(:));
                        axes(handles.intensity_vs_frequency_spectrum); 
                        plot(sure1_mass,sure1_intensity); xlabel('m/z'); ylabel('Intensity');
                        if ~isfield(handles,'single_range_value')
                            if ~isfield(handles,'upper_limit_mz_value')
                                uiwait
                            end
                            handles = delete_timeplot_UnL_lines(handles);
                            handles.h_upper = imline(gca, [handles.upper_limit_mz_value handles.upper_limit_mz_value], [0 max(sure1_intensity(:))]);
                            api = iptgetapi(handles.h_upper);
                            api.setColor([1 0 0]);
                            fcn = makeConstrainToRectFcn('imline', [0, max(sure1_mass(:))],...
                                [0, max(sure1_intensity(:))]);
                            api.setPositionConstraintFcn(fcn);
                            handles.h_lower = imline(gca, [handles.lower_limit_mz_value handles.lower_limit_mz_value], [0 max(sure1_intensity(:))]);
                            api2 = iptgetapi(handles.h_lower);
                            api2.setColor([1 0 0]);
                            fcn = makeConstrainToRectFcn('imline', [0, max(sure1_mass(:))],...
                                [0, max(sure1_intensity(:))]);
                            api2.setPositionConstraintFcn(fcn);
                            axis tight
                        end
                        low_bar = single(handles.lower_limit_mz_value);
                        high_bar = single(handles.upper_limit_mz_value);
                        for scan_numb = 1:size(handles.point_count,1)
                            int_val = handles.intensity_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
                            mass_val = handles.mass_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
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
                            handles.sum_of_intensities(handles.count_2,scan_numb) = sum(int_val(lower_number_new:higher_number_new));
                        end
                        xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
                        xnorm = remove_noise_spikes_from_image(xnorm, 20);
                        xnorm = scale_image_to_fixed_limits(0, 100, xnorm);
                        handles.sum_of_intensities = single(handles.sum_of_intensities);
                        if strcmp(handles.button,'Use excel spreadsheet')
                            redo_mz_ranges_excel_real_time_freq(handles.k, num)
                        end
                        if isempty(handles.image_window_to_display_value)
                            handles.image_window_to_display_value = 1;
                        end
                        if handles.image_window_to_display_value == 1
                            axes(handles.zone_specified_plot);
                        else
                            axes(handles.zone_specified_plot2);
                        end
                        imagesc(imfilter(xnorm(1:size(xnorm,1), 1:size(xnorm,2)), PSF));%(sum_of_intensities(1:size(sum_of_intensities,1), 1:size(sum_of_intensities,2)), PSF));%, 'corr', 'symmetric'));
                        xlabel('Scan'); ylabel('Line');
                        colormap(handles.colormap_3d); set_colorbar();
                        handles.k_final_2 = handles.count_2;
                        handles.count_2 = handles.count_2 + 1;
                        handles.k = handles.k + 1;
                    end
                    
                end
                %% Multiple MZ values for each row (for generating the spectral plots)
                if ~isempty(handles.enter_multiple_values)
                    for number_of_mz_values = 1:size(handles.enter_multiple_values,2)
                        if ~isempty(threshold_values)
                            upper_limit_mz_value2 = handles.enter_multiple_values(number_of_mz_values) + threshold_values;
                            lower_limit_mz_value2 = handles.enter_multiple_values(number_of_mz_values) - threshold_values;
                            low_bar2 = single(lower_limit_mz_value2);
                            high_bar2 = single(upper_limit_mz_value2);
                            sum_of_intensities_temp = zeros(1,numel(handles.point_count));
                            for scan_numb = 1:size(handles.point_count,1)
                                int_val = handles.intensity_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
                                mass_val = handles.mass_values(sum(handles.point_count(1:scan_numb-1))+1:sum(handles.point_count(1:scan_numb)));
                                single_number_forward = (find(mass_val >= low_bar2,1,'first'));
                                single_number_backward = (find(mass_val < low_bar2,1,'last'));
                                diff_forward = abs(low_bar2 - mass_val(single_number_forward(1)));
                                if ~isempty(single_number_backward)
                                    diff_backward = abs(low_bar2 - mass_val(single_number_backward(end)));
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
                                    end
                                end
                                high_single_number_forward = (find(mass_val >= high_bar2,1,'first'));
                                high_single_number_backward = (find(mass_val < high_bar2,1,'last'));
                                high_diff_forward = abs(high_bar2 - mass_val(high_single_number_forward(1)));
                                if ~isempty(high_single_number_backward)
                                    high_diff_backward = abs(high_bar2 - mass_val(high_single_number_backward(end)));
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
                                sum_of_intensities_temp(1,scan_numb) = sum(int_val(lower_number_new:higher_number_new));
                            end
                        end
                        if number_of_mz_values == 1
                            axes(handles.axes_for_mz_values_1);plot(handles.scan_acquisition_time, sum_of_intensities_temp); %set(handles.mz_value_1, 'String', enter_multiple_values(1));
                        elseif number_of_mz_values == 2
                            axes(handles.axes_for_mz_values_2);plot(handles.scan_acquisition_time, sum_of_intensities_temp); %set(handles.mz_value_2, 'String', enter_multiple_values(2));
                        elseif number_of_mz_values == 3
                            axes(handles.axes_for_mz_values_3);plot(handles.scan_acquisition_time, sum_of_intensities_temp); %set(handles.mz_value_3, 'String', enter_multiple_values(3));
                        elseif number_of_mz_values == 4
                            axes(handles.axes_for_mz_values_4);plot(handles.scan_acquisition_time, sum_of_intensities_temp); %set(handles.mz_value_4, 'String', enter_multiple_values(4));
                        elseif number_of_mz_values == 5
                            axes(handles.axes_for_mz_values_5);plot(handles.scan_acquisition_time, sum_of_intensities_temp); %set(handles.mz_value_5, 'String', enter_multiple_values(5));
                        elseif number_of_mz_values == 6
                            axes(handles.axes_for_mz_values_6);plot(handles.scan_acquisition_time, sum_of_intensities_temp); %set(handles.mz_value_6, 'String', enter_multiple_values(6));
                        end
                    end
                end
                time_taken_for_line_number = toc;
                handles.time_taken_to_save_whole_file(1,tcount) = time_taken_for_line_number;
                tcount = tcount + 1;
                fprintf('Converted %s in %f seconds \n', fake_name2, time_taken_for_line_number);
                if (handles.k_final_2 < handles.number_of_scans)
                    fprintf('Estimated time is %f seconds \n', (time_taken_for_line_number*(handles.number_of_scans - handles.k_final_2)));
                end
                drawnow
                pause(.5)
                if (handles.k_final_2 == handles.number_of_scans)|(handles.k_final_3 == handles.number_of_scans+1)|(handles.user_input_for_mode_auto == 2) %#ok<*OR2>
                    axes(handles.intensity_vs_frequency_spectrum);
                    handles.k_final_3 = handles.k_final_3 - 1;
                    break;
                end
                if (k_start > 1 && handles.k_final_2 == handles.number_of_scans + k_start - 1)
                    axes(handles.intensity_vs_frequency_spectrum);
                    break;
                end
            end
        end
    end
    handles.sum_of_intensities6 = xnorm;
    handles.org_sum_of_int1 = size(handles.sum_of_intensities6,1);
    handles.org_sum_of_int2 = size(handles.sum_of_intensities6,2);
    handles.repeat_time = 1;
    handles.time_bar_val = time_bar_val;
    current_dir = pwd;
    cd(strcat(handles.pathname,handles.saveTempFilesToFolder))
    sum_of_intensities2 = handles.sum_of_intensities;  %#ok<*NASGU>
    save(strcat('sum_of_intensities',num2str(1),'.mat'),'sum_of_intensities2')
    cd(current_dir)
    set(handles.software_free, 'BackgroundColor', 'green');
    comb = strjoin({num2str(handles.lower_limit_mz_value), num2str(handles.upper_limit_mz_value)},', ');
    handles = set_proven_variable(hObject, 'mzRange', comb, handles);
    handles = set_proven_variable(hObject, 'numRawFiles', num2str(handles.number_of_scans), handles);

    function handles = delete_timeplot_UnL_lines(handles)
    % handles = guidata(hObject);
        delete(handles.h_lower);
        delete(handles.h_upper);
    end

end