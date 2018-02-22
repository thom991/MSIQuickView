function [handles, time_bar_val] = draw_plots_and_ion_image(hObject, handles)
switch handles.button
    case {'Yes', 'Use excel spreadsheet'}
        handles = start(handles);
        check_real_time = get(handles.text_for_number_of_scans,'string');
        check_real_time = single(str2double(check_real_time));
        if numel(handles.ll) < check_real_time
            last_filename = inputdlg('Please Enter Last Filename:', 'Required Input', [1 50],{handles.filename});
            last_filename = last_filename{:};
            list = auto_generate_filename(handles,last_filename);
            handles.ll = list';
        end
        [handles, time_bar_val] = start_process(handles);
        handles = continue_plotting(hObject, handles);
    case 'Define new m/z range'
        handles = start(handles);
        [handles, time_bar_val] = start_process(handles);
        handles.lower_limits_count(1) = handles.lower_limit_mz_value;
        handles.upper_limits_count(1) = handles.upper_limit_mz_value;
        handles.next_sum_folder = 1;
    case 'Cancel'
end

    function handles = start(handles)
        tic
        set(handles.software_free, 'BackgroundColor', 'red');
        handles.k_final_2 = 1; %Stops the Inf loop when user specified # of scans are reached or when the "stop" button is pressed
        handles.which_version = 1;  %Automatic or Manual mode
        handles.k = get(handles.start_with_line_number_editbox,'string');
        handles.k = single(str2double(handles.k));
        if isempty(handles.colormap_3d)
            handles.colormap_3d = 'gray'; %default colormap to gray
        end
    end

    function [handles, time_bar_val] = start_process(handles)
        if isempty(handles.instrument_bruker)
            handles = get_names(handles);
            cd(handles.pathname(1:end-1));
            for ex = 1:100000
                if exist(strcat(handles.pathname,handles.fake_name_next),'file') || exist(handles.cdf_filename,'file') || exist(handles.hdf_filename,'file') %If the raw file is present in user specified folder
                    if ~exist(strcat(handles.pathname,'CDF_Files',filesep, lower(handles.RAW_filename_new2_check)),'file') && ~exist(strcat(handles.pathname,'HDF_Files',filesep, (handles.RAW_filename_new2_check_hdf)),'file')
                        if ispc
                            cmd = sprintf ('C:\\Xcalibur\\system\\programs\\XConvert /SL /DA "%s" /O "%s"',handles.RAW_filename_new2,strcat(handles.pathname,'CDF_Files'));    %filename format for conversion into cdf
                            system (cmd);  %file conversion to cdf format begins and is saved onto the 'delete' folder in C drive. The delete folder is emptied automatically once the GUI is re-run
                        else
                            disp('File convertor only works on Windows platform')
                        end
                    end
                    set(handles.filename_display_for_int_freq_spec, 'String', handles.filename);   %displays filename in the edit box
                    if handles.k_final_2 < handles.number_of_scans+1   % If number of scans entered by user is more than the current #, then proceed
                        if strcmp(handles.ext, '.cdf') || strcmp(handles.ext, '.raw') || strcmp(handles.ext, '.RAW') || strcmp(handles.ext, '.mat')
                            api = cdf_files();
                            handles = api.read_cdf_file(handles);
                        elseif strcmp(handles.ext, '.hdf')
                            handles = read_hdf_file(handles);
                        end
                        %%SAVE HDF
                        if ~exist(handles.hdf_filename,'file')
                            hdf5write(handles.hdf_filename,'intensity_values',handles.intensity_values,'mass_values',handles.mass_values,'point_count',handles.point_count,'total_intensity',handles.total_intensity,'scan_acquisition_time',handles.scan_acquisition_time,'mass_range_max',handles.mass_range_max,'mass_range_min',handles.mass_range_min);
                        end
                        for time_bar_val = 1%:size(point_count,1)
                            sure1_intensity(1:handles.point_count(time_bar_val)) = handles.intensity_values(1:(handles.point_count(time_bar_val)));
                            sure1_mass(1:handles.point_count(time_bar_val)) = handles.mass_values(1:(handles.point_count(time_bar_val)));
                        end
                        if ~isfield(handles,'upper_limit_mz_value')
                            handles.upper_limit_mz_value = single(round(handles.mass_range_max(time_bar_val)-20));
                            handles.lower_limit_mz_value = single(round(handles.mass_range_min(time_bar_val)+20));
                        end
                        handles.start_size_sum_of_intensities = size(handles.point_count,1);
                        set(handles.upper_limit_mz_value_box, 'string', num2str(handles.upper_limit_mz_value))
                        set(handles.lower_limit_mz_value_box, 'string', num2str(handles.lower_limit_mz_value))
                        axes(handles.intensity_vs_frequency_spectrum);
                        plot(sure1_mass,sure1_intensity,'HitTest', 'off', 'ButtonDownFcn', ''); xlabel('m/z'); ylabel('Intensity');
                        axis tight
                        handles.max_intensity = max(sure1_intensity(:));
                        handles.max_mass = max(sure1_mass(:));
                        handles.h_upper = imline(gca, [handles.upper_limit_mz_value handles.upper_limit_mz_value], [0 handles.max_intensity]);
                        api = iptgetapi(handles.h_upper);
                        api.setColor([1 0 0]);
                        fcn = makeConstrainToRectFcn('imline', [0, handles.mass_range_max(time_bar_val)],...
                            [0, handles.max_intensity]);
                        api.setPositionConstraintFcn(fcn);
                        handles.h_lower = imline(gca, [handles.lower_limit_mz_value handles.lower_limit_mz_value], [0 handles.max_intensity]);
                        api = iptgetapi(handles.h_lower);
                        api.setColor([1 0 0]);
                        fcn = makeConstrainToRectFcn('imline', [0, handles.mass_range_max(time_bar_val)],...
                            [0, handles.max_intensity]);
                        api.setPositionConstraintFcn(fcn);
                        axis tight
                    end
                    break;
                else
                    pause(30)
                end
            end
            axes(handles.axes_for_mz_values_0);
            if numel(handles.scan_acquisition_time) < 10
                plot(handles.scan_acquisition_time, handles.total_intensity,'--b*');
            else
                plot(handles.scan_acquisition_time, handles.total_intensity);
            end
            handles.h_t = imline(gca, [handles.scan_acquisition_time(time_bar_val) handles.scan_acquisition_time(time_bar_val)], [0 max(handles.total_intensity(:))]);
            api = iptgetapi(handles.h_t);
            api.setColor([1 0 1]);
            fcn = makeConstrainToRectFcn('imline', [handles.scan_acquisition_time(1), handles.scan_acquisition_time(end)],...
                [0, max(handles.total_intensity(:))]);
            api.setPositionConstraintFcn(fcn);
            axis tight
            set(handles.axes_for_mz_values_0, 'buttondownfcn',@axes_for_mz_values_0_ButtonDownFcn);
            set(handles.software_free, 'BackgroundColor', 'green');
            handles.time_taken_to_save_whole_file = toc;
        elseif ~isempty(handles.instrument_bruker)
            handles = get_names(handles);
            cd(handles.pathname(1:end-1));
            cmd = sprintf ('"C:\\Program Files (x86)\\ProteoWizard\\ProteoWizard 3.0.3643\\msconvert" %s -o C:\\delete --mzXML',handles.RAW_filename_new2);
            system (cmd);
            set(handles.filename_display_for_int_freq_spec, 'String', handles.filename);   %displays filename in the edit box
            if handles.k_final_2 < handles.number_of_scans+1   % If number of scans entered by user is more than the current #, then proceed
                ii = [];%mzxmlread('C:\delete\nic_brain_mzxml_trial.mzXML');
                handles.mass_values = ii.scan(1,1).peaks.mz(1:2:end);
                handles.intensity_values = ii.scan(1,1).peaks.mz(2:2:end);
                handles.scan_acquisition_time = zeros(size(ii.scan,1),1);
                handles.point_count = zeros(size(ii.scan,1),1);
                for i_temp = 1:size(ii.scan,1)
                    handles.total_intensity(i_temp) = sum(ii.scan(i_temp,1).peaks.mz(2:2:end));
                    handles.scan_acquisition_time(i_temp) =  str2double(ii.scan(i_temp,1).retentionTime(3:end-1));
                    handles.point_count(i_temp) = size(ii.scan((i_temp),1).peaks.mz,1)/2;
                end
                handles.lower_limit_for_time = round((min(handles.scan_acquisition_time)*60)+20/60);
                handles.upper_limit_for_time = round((max(handles.scan_acquisition_time)*60)-20/60);
                handles.first_filename = handles.filename;
                handles.mass_range_max = max(handles.mass_values(:));
                handles.mass_range_min = min(handles.mass_values(:));
                for time_bar_val = 1
                    sure1_intensity(1:handles.point_count(time_bar_val)) = handles.intensity_values;
                    sure1_mass(1:handles.point_count(time_bar_val)) = handles.mass_values;
                end
                if ~isfield(handles,'upper_limit_mz_value')
                    handles.upper_limit_mz_value = single(round(handles.mass_range_max(time_bar_val)-20));
                    handles.lower_limit_mz_value = single(round(handles.mass_range_min(time_bar_val)+20));
                end
                handles.start_size_sum_of_intensities = size(handles.point_count,1);
                set(handles.upper_limit_mz_value_box, 'string', num2str(handles.upper_limit_mz_value))
                set(handles.lower_limit_mz_value_box, 'string', num2str(handles.lower_limit_mz_value))
                axes(handles.intensity_vs_frequency_spectrum);
                plot(sure1_mass,sure1_intensity); xlabel('m/z'); ylabel('Intensity');
                axis tight
                handles.max_intensity = max(sure1_intensity(:));
                handles.max_mass = max(sure1_mass(:));
                handles.h_upper = imline(gca, [handles.upper_limit_mz_value handles.upper_limit_mz_value], [0 handles.max_intensity]);
                api = iptgetapi(handles.h_upper);
                api.setColor([1 0 0]);
                fcn = makeConstrainToRectFcn('imline', [0, handles.mass_range_max(time_bar_val)],...
                    [0, handles.max_intensity]);
                api.setPositionConstraintFcn(fcn);
                handles.h_lower = imline(gca, [handles.lower_limit_mz_value handles.lower_limit_mz_value], [0 handles.max_intensity]);
                api = iptgetapi(handles.h_lower);
                api.setColor([1 0 0]);
                fcn = makeConstrainToRectFcn('imline', [0, handles.mass_range_max(time_bar_val)],...
                    [0, handles.max_intensity]);
                api.setPositionConstraintFcn(fcn);
                axis tight
            end
            axes(handles.axes_for_mz_values_0);
            if numel(handles.scan_acquisition_time) < 10
                plot(handles.scan_acquisition_time, handles.total_intensity,'--b*');
            else
                plot(handles.scan_acquisition_time, handles.total_intensity);
            end
            handles.h_t = imline(gca, [handles.scan_acquisition_time(time_bar_val) handles.scan_acquisition_time(time_bar_val)], [0 max(handles.total_intensity(:))]);
            api = iptgetapi(handles.h_t);
            api.setColor([1 0 1]);
            fcn = makeConstrainToRectFcn('imline', [handles.scan_acquisition_time(1), handles.scan_acquisition_time(end)],...
                [0, max(handles.total_intensity(:))]);
            api.setPositionConstraintFcn(fcn);
            axis tight
            set(handles.software_free, 'BackgroundColor', 'green');
        end
        handles.lower_limits_count(1) = handles.lower_limit_mz_value;
        handles.upper_limits_count(1) = handles.upper_limit_mz_value;
        handles.next_sum_folder = 1;
        time = toc;
        fprintf('Converted %s in %f seconds \n', handles.fake_name2, time)
    end

    function handles = get_names(handles)
        if isempty(handles.instrument_bruker)
            handles.fake_name2 = handles.ll{1,handles.k};%filename(1:size(filename,2)-5);
            handles.fake_name_next = handles.ll{1,handles.k+1};
            handles.RAW_filename_new2 = strcat(handles.pathname,handles.fake_name2);
            handles.RAW_filename_new2_check = [handles.fake_name2(1:end-4) '.cdf' ];
            handles.RAW_filename_new2_check_hdf = [handles.fake_name2(1:end-4) '.hdf' ];
            fprintf('Converting %s \n', handles.fake_name2)
            cdf_begin = strcat(handles.pathname,'CDF_Files',filesep,handles.fake_name2);
            hdf_begin = strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2);
            handles.cdf_filename = [cdf_begin(1:end-4) '.cdf' ];
            handles.hdf_filename = [hdf_begin(1:end-4) '.hdf' ];
        elseif ~isempty(handles.instrument_bruker)
            handles.fake_name2 = handles.ll{1,handles.k};
            handles.fake_name_next = handles.ll{1,handles.k+1};
            handles.RAW_filename_new2 = strcat(handles.pathname,'Analysis.yep');
            cdf_begin = strcat('C:\delete\',handles.fake_name2);
            handles.cdf_filename = [cdf_begin(1:end-4) '.mzXML' ];
        end
    end
end