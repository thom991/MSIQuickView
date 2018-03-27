function varargout = MSI_QuickView_Real_Time_Visualization_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',  mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MSI_QuickView_Real_Time_Visualization_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @MSI_QuickView_Real_Time_Visualization_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else 
    gui_mainfcn(gui_State, varargin{:}); 
end


function MSI_QuickView_Real_Time_Visualization_GUI_OpeningFcn(hObject,eventdata, varargin)
pathname2 = [];
handles = guidata(hObject);
handles.output = hObject;
handles = set_default_handles(handles);
% Initialise tabs
handles.tabManager = TabManager( hObject );
set(handles.Toolbar_radiobutton,'Value',1)
set(handles.output,'Name','MSI QuickView Real Time Visualization Tool');
if ~isempty(pathname2)
    [browseOutput] = browse_for_image_Callback(hObject, [], []);
    if exist([pathname2 filesep 'Saved_Parameters.mat'],'file')
        start_Callback(hObject,eventdata,handles)
    end
end
guidata(hObject,handles);


function varargout = MSI_QuickView_Real_Time_Visualization_GUI_OutputFcn(hObject, ~, ~)
handles = guidata(hObject);
varargout{1} = handles.output;
maxfig(gcf,1)


function browse_for_image_Callback(hObject, ~, ~) %%#ok<DEFNU>
autoflow = 0;
handles = guidata(hObject);
[isset, handles] = setProvenDummyValues(handles, 1);
pathname2 = [];
handles.colormap_3d = 'hot';
api = config_file;
handles = api.load_config_file_info(api, handles);
api2 = elasticModule;
api2.addpath([pwd filesep 'Python']);
try
    if isset
        set(handles.software_free, 'BackgroundColor', 'green')
        if isempty(pathname2)
            [filename, pathname, filterindex] = uigetfile( ...
                {  '*.yep;*.baf;*.RAW;*.cdf;*.hdf;*.mat';'*.*'}, ...
                'Pick a file');
        elseif ~isempty(pathname2) && exist([pathname2 filesep 'Saved_Parameters.mat'],'file')
            filename = 'Saved_Parameters.mat';
            pathname = [pathname2 filesep];
        elseif ~isempty(pathname2) && ~exist([pathname2 filesep 'Saved_Parameters.mat'],'file')
            [filename, pathname, filterindex] = uigetfile( ...
                {  '*.yep;*.baf;*.RAW;*.cdf;*.hdf;*.mat';'*.*'}, ...
                'Pick a file', pathname2);
        end
        if numel(filename) > 1
            [~, ~, ext] = fileparts(filename);
            delete_logs(handles);
            start_logging(handles);
            if strcmp(ext,'.cdf') || strcmp(ext,'.hdf')
                pathname = pathname(1:end-10);
            end
            if strcmp(ext,'.mat')
                handles = load_presaved_matfile(pathname, list, handles);
            end
            if (~isdeployed)
                addpath(pathname);
            end
            if strcmp(ext,'.raw') || strcmp(ext,'.RAW')
                create_folder(pathname, 'saveHDFFiles')
                create_folder(pathname, 'saveCDFFiles')
            end
            api = config_file;
            keys = api.read_config_keys('Folder');
            for folderNo = 1:numel(keys); create_folder(pathname, keys{folderNo,1}); end
            set(handles.textbox_for_browsed_image,'string',filename);
            % Convert Xcalibur RAW file to CDF file
            RAW_filename = strcat(pathname,filename);
            if strcmp(RAW_filename(end-2:end),'RAW')||strcmp(RAW_filename(end-2:end),'raw')
                cdf_filename = [RAW_filename(1:end-4) '.cdf' ];
            else
                cdf_filename = [RAW_filename(1:end-4) '.cdf' ];
                instrument_bruker = 1;
            end
            local_mfiles = pwd;
            if (~isdeployed)
                addpath(pwd);
            end
            A = dir([pathname '*.RAW']);
            [~,idx] = sort([A.datenum]);
            ll = {A(idx).name};
            loc = find(strcmp(filename, ll));
            number_of_scans = size(ll,2)-loc+1;
            set(handles.start_with_line_number_editbox,'string',num2str(loc));
            set(handles.text_for_number_of_scans,'string',num2str(number_of_scans));
        end
    end
    handles.filename = filename; handles.pathname = pathname; handles.filterindex = filterindex; handles.ext = ext; handles.autoflow = autoflow; handles.number_of_scans = number_of_scans; handles.ll = ll; handles.instrument_bruker = []; handles.execs = [];
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function textbox_for_browsed_image_Callback(~, ~, ~) %%#ok<DEFNU>


function textbox_for_browsed_image_CreateFcn(hObject, ~, ~) %%#ok<DEFNU>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function stop_running_loop_Callback(hObject, ~, ~) %%#ok<DEFNU>
try
    handles = guidata(hObject);
    start_logging(handles);
    if handles.which_version == 1
        handles.k_final_3 = handles.number_of_scans+1;
    elseif handles.which_version == 2
        handles.k_final_2 = handles.number_of_scans+1;
    end
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function start_Callback(hObject,~,~) %#ok<*DEFNU>
button_state = get(hObject,'Value');
handles = guidata(hObject);
if button_state == get(hObject,'Max')  
    [handles.org_sum_of_int1, handles.org_sum_of_int2, handles.sum_of_intensities, handles.k_final_3, handles.user_input_for_mode_auto, handles.k_final_2, handles.k, handles.max_mass, handles.sum_of_intensities6, handles.repeat_time, handles.check_point_count, handles.highest_row_val, handles.time_taken_to_save_whole_file, handles.RAW_filename_new2, handles.sure1_temp] = deal([]);
    try
        start_logging(handles);
        if ~isfield(handles,'round_no')
            handles.button = questdlg('Use default or user-selected m/z range for ion map ??',...
                'Warning',...
                'Yes','Define new m/z range','Use excel spreadsheet', 'Yes');
        else
            handles.button = 'Yes';
        end
        handles.round_no = 1;
        set(handles.start,'string','Stop');
        [handles, time_bar_val] = draw_plots_and_ion_image(hObject, handles);
        handles = set_proven_variable(hObject, 'folderLocation', handles.pathname, handles);
        handles.time_bar_val = time_bar_val;
        handles.execs{numel(handles.execs)+1} = 'start_Callback(hObject,[],handles)';
        stop_logging();
    catch MExc
        show_error(MExc);
    end
    set(hObject, 'Value', 0);
    set(handles.start,'string','Start');
elseif button_state == get(hObject,'Min')
    stop_running_loop_Callback(hObject,[],handles);
    set(handles.start,'string','Start');
end
guidata(hObject,handles);


function text_for_number_of_scans_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.number_of_scans = get(handles.text_for_number_of_scans,'string');
    handles.number_of_scans = single(str2double(handles.number_of_scans));
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function text_for_number_of_scans_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lower_limit_mz_value_box_Callback(hObject, ~, ~)
upper_lower_mz_value_box('lower', hObject);

function lower_limit_mz_value_box_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function upper_limit_mz_value_box_Callback(hObject, ~, ~)
upper_lower_mz_value_box('upper', hObject);


function upper_lower_mz_value_box(direction, hObject)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.([direction '_limit_mz_value']) = get(handles.([direction '_limit_mz_value_box']),'string');
    handles.([direction '_limit_mz_value']) = single(str2double(handles.([direction '_limit_mz_value'])));
    axes(handles.intensity_vs_frequency_spectrum);
    delete(handles.(['h_' direction]))
    handles.(['h_' direction]) = imline(gca, [handles.([direction '_limit_mz_value']) handles.([direction '_limit_mz_value'])], [0 handles.max_intensity]);
    api2 = iptgetapi(handles.(['h_' direction]));
    api2.setColor([1 0 0]);
    fcn = makeConstrainToRectFcn('imline', [0, handles.max_mass],...
        [0, handles.max_intensity]);
    api2.setPositionConstraintFcn(fcn);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function upper_limit_mz_value_box_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = freq_range_selected_Callback(hObject,~,handles)
try
    start_logging(handles);
    handles = get_line_info_Callback(hObject,[], [], false);
    handles = continue_plotting(hObject, handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function lower_limit_for_time_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function next_for_converting_files_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    n6 = size(handles.filename,2);
    fake_name2(1:n6-5) = handles.filename(1:n6-5);
    cd(handles.pathname);
    if handles.k < 10
        fake_name2(size(handles.filename,2)-4) = num2str(handles.k);
        fake_name2(size(handles.filename,2)-3:size(handles.filename,2)) = '.raw';
    else
        if handles.k == 10 && fake_name2(size(handles.filename,2)-5) == '0'
            fake_name2(size(handles.filename,2)-5:size(handles.filename,2)-4) = num2str(handles.k);
            fake_name2(size(handles.filename,2)-3:size(handles.filename,2)) = '.raw';
            handles.O_was_present = 1;
        elseif handles.k>10 && ~isempty(handles.O_was_present)% == 1
            fake_name2(size(handles.filename,2)-5:size(handles.filename,2)-4) = num2str(handles.k);
            fake_name2(size(handles.filename,2)-3:size(handles.filename,2)) = '.raw';
        else
            fake_name2(size(handles.filename,2)-4:size(handles.filename,2)-3) = num2str(handles.k);
            fake_name2(size(handles.filename,2)-2:size(handles.filename,2)+1) = '.raw';
        end
    end
    set(handles.filename_display_for_int_freq_spec, 'String', fake_name2);
    RAW_filename_new2 = strcat(handles.pathname,fake_name2);
    cdf_begin = strcat('C:\delete\',fake_name2);
    handles.cdf_filename = [cdf_begin(1:end-4) '.cdf' ];
    cd(handles.pathname(1:end-1));
    if exist(fake_name2, 'file') && ~exist(handles.cdf_filename, 'file')
        cmd = sprintf ('C:\\Xcalibur\\system\\programs\\XConvert /SL /DA "%s" /O C:\\delete',RAW_filename_new2);
        system (cmd);
        if handles.k_final_2 < handles.number_of_scans+1
            intensity_values = ncread(handles.cdf_filename,'intensity_values');
            mass_values = ncread(handles.cdf_filename,'mass_values');
            point_count = ncread(handles.cdf_filename,'point_count');
            r = isequal(point_count(1), point_count(2)); 
            if r == 0 
                [max_num,n_num] = max(point_count);
                sure1 = zeros(max_num,size(point_count,1),'single');
                sure1_check = zeros(max_num,size(point_count,1),'single');
                sure1_mass = zeros(max_num,size(point_count,1),'single');
                sure1_intensity = zeros(max_num,size(point_count,1),'single');
                start_val = 1;
                for i = 1:size(point_count,1)
                    sure1_intensity(1:point_count(i),i) = intensity_values(start_val:(point_count(i)+start_val-1));
                    sure1_mass(1:point_count(i),i) = mass_values(start_val:(point_count(i)+start_val-1));
                    start_val = start_val + point_count(i);
                end
                i3 = 1;
                for j = 1:size(point_count,1)
                    for i2 = 1:point_count(i3)
                        y_val = find(sure1_mass(i2,j)==sure1_mass(:,n_num));
                        if ~isempty(y_val)
                            sure1(y_val,j) = sure1_intensity(i2,j);
                            sure1_check(y_val,j) = sure1_mass(i2,j);
                        end
                    end
                    i3 = i3 + 1;
                end
            else
                sure1 = reshape(intensity_values,point_count(1),size(point_count,1));
            end
            if size(point_count,1) < handles.start_size_sum_of_intensities
                sure1(:,end:handles.start_size_sum_of_intensities) = 0;
            elseif handles.start_size_sum_of_intensities < size(point_count,1)
                handles.sum_of_intensities(:,end:size(point_count,1)) = 0;
                handles.start_size_sum_of_intensities = size(point_count,1);
            end
            mean_val = mean(sure1(:,1:size(point_count,1)),2);
            max_intensity = max(mean_val(:));
            axes(handles.intensity_vs_frequency_spectrum);
            if r == 0 
                plot(sure1_check(:,n_num),mean_val); xlabel('m/z'); ylabel('Intensity');
                max_mass = max(sure1_check(:,n_num));
            else
                plot(mass_values(1:point_count(1)),mean_val); xlabel('m/z'); ylabel('Intensity');
                max_mass = max(mass_values(1:point_count(1)));
            end
            if isempty(handles.upper_limit_mz_value)
                uiwait
            end
            handles.h_upper = imline(gca, [handles.upper_limit_mz_value handles.upper_limit_mz_value], [0 max_intensity]);
            api = iptgetapi(handles.h_upper);
            api.setColor([1 0 0]);
            fcn = makeConstrainToRectFcn('imline', [0, max_mass],...
                [0, max_intensity]);
            api.setPositionConstraintFcn(fcn);
            handles = delete_timeplot_UnL_lines(handles);
            handles.h_lower = imline(gca, [handles.lower_limit_mz_value handles.lower_limit_mz_value], [0 max_intensity]);
            api2 = iptgetapi(handles.h_lower);
            api2.setColor([1 0 0]);
            fcn = makeConstrainToRectFcn('imline', [0, max_mass],...
                [0, max_intensity]);
            api2.setPositionConstraintFcn(fcn);
            axis tight
            low_bar = handles.lower_limit_mz_value;
            high_bar = handles.upper_limit_mz_value;
            if r == 0 
                single_number_forward = (find(sure1_check(:,n_num) >= low_bar));
                single_number_backward = (find(sure1_check(:,n_num) > low_bar - 1));
                diff_forward = abs(low_bar - mass_values(single_number_forward(1)));
                diff_backward = abs(low_bar - mass_values(single_number_backward(end)));
                if diff_forward < diff_backward
                    lower_number = single_number_forward(1);
                else
                    lower_number = single_number_backward(end);
                end                
                high_single_number_forward = (find(sure1_check(:,n_num) >= high_bar));
                high_single_number_backward = (find(sure1_check(:,n_num) > high_bar - 1));
                high_diff_forward = abs(high_bar - mass_values(high_single_number_forward(1)));
                high_diff_backward = abs(high_bar - mass_values(high_single_number_backward(end)));
                if high_diff_forward < high_diff_backward
                    higher_number = high_single_number_forward(1);
                else
                    higher_number = high_single_number_backward(end);
                end
                lower_number_new = lower_number(1);
                higher_number_new = higher_number(end);
            else
                single_number_forward = (find(mass_values(1:point_count(1)) >= low_bar & mass_values(1:point_count(1)) < low_bar+1));
                single_number_backward = (find(mass_values(1:point_count(1)) > low_bar - 1 & mass_values(1:point_count(1)) < low_bar));
                diff_forward = abs(low_bar - mass_values(single_number_forward(1)));
                diff_backward = abs(low_bar - mass_values(single_number_backward(end)));
                if diff_forward < diff_backward
                    lower_number = single_number_forward(1);
                else
                    lower_number = single_number_backward(end);
                end                
                high_single_number_forward = (find(mass_values(1:point_count(1)) >= high_bar & mass_values(1:point_count(1)) < high_bar+1));
                high_single_number_backward = (find(mass_values(1:point_count(1)) > high_bar - 1 & mass_values(1:point_count(1)) < high_bar));
                high_diff_forward = abs(high_bar - mass_values(high_single_number_forward(1)));
                high_diff_backward = abs(high_bar - mass_values(high_single_number_backward(end)));
                if high_diff_forward < high_diff_backward
                    higher_number = high_single_number_forward(1);
                else
                    higher_number = high_single_number_backward(end);
                end
                lower_number_new = lower_number(1);
                higher_number_new = higher_number(end);
            end
            handles.sum_of_intensities(handles.count_2,:) = sum(sure1(lower_number_new:higher_number_new,1:handles.start_size_sum_of_intensities),1);
            handles.sum_of_intensities6 = handles.sum_of_intensities;
            xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
            xnorm = remove_noise_spikes_from_image(xnorm, 20);
            xnorm = scale_image_to_fixed_limits(0, 100, xnorm);
            PSF = fspecial('average', [handles.sliderValue_m handles.sliderValue_n]);
            if isempty(handles.image_window_to_display_value)
                handles.image_window_to_display_value = 1;
            end
            handle_display_image_window(handles, false);
            imagesc(imfilter(xnorm(1:size(xnorm,1), 1:size(xnorm,2)), PSF));
            xlabel('Scan'); ylabel('Line');
            colormap(handles.colormap_3d); set_colorbar();
            ind = find(handles.cdf_filename == '\');
            save_filename = handles.cdf_filename(ind(end)+1:end-3);
            save_filename = strcat(save_filename,'mat');
            current_dir = pwd;
            cd(handles.saveTempFilesToFolder)
            save(save_filename,'sure1')
            if r == 0 
                mass_values_list = sure1_check(:,n_num); %#ok<*NASGU>
            else
                mass_values_list = mass_values(1:point_count(1));
            end
            save('mz_values','mass_values_list')
            cd(current_dir)
            handles.count_2 = handles.count_2 + 1;
            handles.k = handles.k + 1;
            handles.number_of_scans = handles.k;
            axes(handles.intensity_vs_frequency_spectrum);
        end
    end
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function clear_all_button_Callback(~, ~, handles)
stop_logging();
current_dir = pwd;
closeGUI = handles.figure1; %handles.figure1 is the GUI figure
close(closeGUI); %close the old GUI
guiName = 'MSI_QuickView_Real_Time_Visualization_GUI';
eval(guiName) %call the GUI again
maxfig(gcf,1)
% h = waitbar(0.25,'Loading Fiji/ImageJ Settings...');
if ~isdeployed
    addpath(genpath(current_dir));
    % Miji%(false)
else
    % Miji%(false)
end
clear all; %#ok<*CLALL>
clc;
evalin('base','clear all');
handles = guidata(gcf);
handles.myobj = gov.pnnl.proven.api.producer.ProvenanceProducer('testApp','1.0');
handles.startMsg = handles.myobj.createMessage('StartApplication');
guidata(gcf,handles);

function handles = get_line_info_Callback(hObject,~,~, restart)
try
    handles = guidata(hObject);
    start_logging(handles);
    axes(handles.intensity_vs_frequency_spectrum);
    handles.upper_limit_mz_value = getPosition(handles.h_upper);
    handles.upper_limit_mz_value = (handles.upper_limit_mz_value(1));
    handles.h_upper3 = handles.upper_limit_mz_value;
    handles.lower_limit_mz_value = getPosition(handles.h_lower);
    handles.lower_limit_mz_value = (handles.lower_limit_mz_value(1));
    limit_mz_value_box(num2str(handles.lower_limit_mz_value), num2str(handles.upper_limit_mz_value), handles)
    handles.h_l3 = handles.lower_limit_mz_value;
    guidata(hObject,handles);
    if restart
        start_Callback(hObject,[],[]);
    end
    stop_logging();
catch MExc
    show_error(MExc);
end


function popupmenu_for_colormap3d_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    [colormap3d_value, handles] = get_colormap_3d(handles);
    if isempty(handles.image_window_to_display_value)
        handles.image_window_to_display_value = 1;
    end
    handle_display_image_window(handles, false)
    if strcmp(handles.colormap_3d,'Personal')
        for i = 1:13; handles.(['color',num2str(i),'_colormap3d_value']) = i; end;
        for i = 1:12; set(handles.(['color', num2str(i)]),'Value',handles.(['color',num2str(i),'_colormap3d_value'])); end;
    else
        colormap(handles.colormap_3d);
    end
    colormap3d_value2 = num2str(colormap3d_value);
    handles = set_proven_variable(hObject, 'colorMap', colormap3d_value2, handles);
    handles.execs{numel(handles.execs)+1} = 'popupmenu_for_colormap3d_Callback(hObject,[],handles)';
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function popupmenu_for_colormap3d_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function aspect_ratio_across_edit_Callback(~, ~, ~)


function aspect_ratio_across_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function aspect_ratio_down_edit_Callback(~, ~, ~)


function aspect_ratio_down_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_or_reset_scale_Callback(hObject,~,~)
handles = guidata(hObject);
button_state = get(handles.set_or_reset_scale,'Value');
handles.execs{numel(handles.execs)+1} = ['set(handles.set_or_reset_scale,''','Value''',',' num2str(button_state) ')'];
handles.execs{numel(handles.execs)+1} = 'set_or_reset_scale_Callback(hObject,[],[])'; 
if button_state == get(hObject,'Max')
    handles = enter_scaling_values_Callback(hObject,[],handles);
    set(handles.set_or_reset_scale,'string','Reset');
elseif button_state == get(hObject,'Min')
    handles = reset_scale_button_Callback(hObject,[],handles);
    set(handles.set_or_reset_scale,'string','Apply');
end
guidata(hObject,handles);


function handles = enter_scaling_values_Callback(hObject,~,handles)
try
    start_logging(handles);
    handles.plot_val = 1;
    image_window_to_display_value = handles.image_window_to_display_value;
    for image_window_to_display_value = 1:2
        if image_window_to_display_value == 1
            cla(handles.zone_specified_plot);
            axes(handles.zone_specified_plot); %#ok<*LAXES>
        else
            cla(handles.zone_specified_plot2);
            axes(handles.zone_specified_plot2);
        end
        handles = aspect_ratio(handles);
        handles.temp1 = get(gca,'Position');
        handles.temp2 = handles.temp1;
        if ~isfield(handles, 'temp5')
            handles.temp5 = handles.temp1;
        end
        if ~isfield(handles, 'temp2')
            handles = reset_scale_button_Callback([],[],handles);
        end
        handles.down_val = str2double(handles.down_val);
        handles.across_val = str2double(handles.across_val);
        if handles.down_val > handles.across_val
            handles.width = (handles.temp2(3)*(handles.across_val/handles.down_val));
            set(gca,'Position',[handles.temp1(1) handles.temp1(2) handles.width handles.temp1(4)]); % change axis position
        else
            height = (handles.temp2(4)*(handles.down_val/handles.across_val));
            set(gca,'Position',[handles.temp1(1) handles.temp1(2) handles.temp1(3) height]); % change axis position
        end
        imagesc(handles.sum_of_intensities); set_colorbar();
        handles.changed_aspect_ratio = 1;
        comb = strjoin({num2str(handles.down_val), num2str(handles.across_val)},', ');
        handles = set_proven_variable(hObject, 'aspectRatio', comb, handles);
    end
    stop_logging();
catch MExc
    show_error(MExc);
end


function handles = reset_scale_button_Callback(~, ~, handles)
try
    start_logging(handles);
    image_window_to_display_value = handles.image_window_to_display_value;
    for image_window_to_display_value = 1:2
        if handles.plot_val == 1
            if image_window_to_display_value == 1
                axes(handles.zone_specified_plot);
            else
                axes(handles.zone_specified_plot2);
            end
            set(gca,'Position',[handles.temp5(1) handles.temp5(2) handles.temp5(3) handles.temp5(4)]) % change axis position
        else
            axes(handles.grayscale_plot_enlarged);
            set(gca,'Position',[handles.temp6(1) handles.temp6(2) handles.temp6(3) handles.temp6(4)]) % change axis position
        end
        handles.changed_aspect_ratio = 0;
    end
    stop_logging();
catch MExc
    show_error(MExc);
end


function open_enlarged_view_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.plot_val = 2;
    if ~isfield(handles, 'temp6')
        handles = reset_scale_button_Callback(hObject,[],handles);
    end
    axes(handles.grayscale_plot_enlarged);
    handles = aspect_ratio(handles);
    temp3 = get(gca,'Position');
    temp4 = temp3;
    if ~isfield(handles, 'temp6')
        handles.temp6 = temp3;
    end
    handles.down_val = str2double(handles.down_val);
    handles.across_val = str2double(handles.across_val);
    if handles.down_val > handles.across_val
        width = (temp4(3)*(handles.across_val/handles.down_val));
        set(gca,'Position',[temp3(1) temp3(2) width temp3(4)]) % change axis position
    elseif handles.across_val > handles.down_val
        height = (temp4(4)*(handles.down_val/handles.across_val));
        set(gca,'Position',[temp3(1) temp3(2) temp3(3) height]) % change axis position
    end
    if ~isfield(handles,'radius_val')
        handles.radius_val = 0.1;
    end
    if handles.radius_val == 0
        handles.radius_val = 0.1;
    end
    PSF = fspecial('disk', handles.radius_val);
    imagesc(imfilter(handles.sum_of_intensities(1:size(handles.sum_of_intensities,1), 1:size(handles.sum_of_intensities,2)), PSF,'replicate'));
    xlabel('Scan'); ylabel('Line'); colormap(handles.colormap_3d); set_colorbar();
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function edit_box_for_chaging_intensity_values_Callback(~, ~, ~)


function edit_box_for_chaging_intensity_values_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editbox_avg_filter_val_demo_Callback(~, ~, ~)


function editbox_avg_filter_val_demo_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function save_grayscale_image_as_tiff_Callback(hObject,~,~)
 try
    handles = guidata(hObject);
    set(handles.software_free, 'BackgroundColor', 'red');
    start_logging(handles);
    handles.contents = get(handles.listbox_for_mz_values,'Value');
    pathfile = length(handles.pathname);
    locations = find(handles.pathname == filesep);
    if locations(end)+2 < pathfile
        foldername = handles.pathname(locations(end)+1 : end);
    else
        foldername = handles.pathname(locations(end-1) + 1 : locations(end) - 1);
    end
    if isa(handles.colormap_3d,'double')
        colormap_name = 'personal_colormap';
    else
        colormap_name = handles.colormap_3d;
    end
    if isempty(handles.image_window_to_display_value)
        handles.image_window_to_display_value = 1;
    end
    handles.plot_val = 2;
    %% Enable this section to make the saving of mat file optional along with images
    axes(handles.grayscale_plot_enlarged);
    handles = aspect_ratio(handles);
    temp3 = get(gca,'Position');
    temp4 = temp3;
    if ~isfield(handles, 'temp6')
        handles.temp6 = temp3;
    end
    if ~isfield(handles, 'temp6')
        handles = reset_scale_button_Callback(hObject,[],handles);
    end
    handles.down_val = str2double(handles.down_val);
    handles.across_val = str2double(handles.across_val);
    if handles.down_val > handles.across_val
        width = (temp4(3)*(handles.across_val/handles.down_val));
        set(gca,'Position',[temp3(1) temp3(2) width temp3(4)]) % change axis position
    elseif handles.across_val > handles.down_val
        height = (temp4(4)*(handles.down_val/handles.across_val));
        set(gca,'Position',[temp3(1) temp3(2) temp3(3) height]) % change axis position
    end
    if ~isfield(handles, 'radius_val') || handles.radius_val == 0
        handles.radius_val = 0.1;
    end
    PSF = fspecial('disk', handles.radius_val);
    matrix = zeros(size(handles.contents,2),(size(handles.sum_of_intensities,1)*size(handles.sum_of_intensities,2))+1);
    api = config_file;
    matFile = api.read_config_values('SaveImage', 'saveMatFile');
    excelFile = api.read_config_values('SaveImage', 'saveExcelFile');
    guidata(hObject,handles);
    for list_box_i = 1:size(handles.contents,2)
        time_val = tic;
        set(handles.mz_list_ion_image,'Value',handles.contents(list_box_i))        
        handles = mz_list_ion_image_Callback(hObject,[],handles);
        set(handles.software_free, 'BackgroundColor', 'red');
        if isfield(handles, 'new_x') && isempty(handles.new_x)
            j = [handles.new_x',handles.new_y'];
            for ii = 1:size(j,1);handles.sum_of_intensities(j(ii,2),j(ii,1)) = max(handles.sum_of_intensities(:))+1;end
        end
        h = figure(55);
        imagesc(imfilter(handles.sum_of_intensities(1:size(handles.sum_of_intensities,1), 1:size(handles.sum_of_intensities,2)), PSF,'replicate'));
        colormap(handles.colormap_3d);
        [handles.across_val, handles.down_val] = check_aspect_ratio_values(handles.across_val, handles.down_val);
        h.Position = [100 100 handles.across_val*100 handles.down_val*100];
        if isfield(handles, 'axis_save') && handles.axis_save == 1
            xlabel('Scan'); ylabel('Line'); colormap(handles.colormap_3d); h2 = colorbar('location','eastoutside'); set(h2, 'YColor', [0 0 0]);
        else
            axis off
            colorbar('off')
        end
        handles = get_lower_and_upper_grayscale_color(handles);
        handles = set_get_val_across_interpolated_data(handles);
        if ~isfield(handles, 'new_x')
            handles.name = ['mz' num2str(handles.lower_limit_mz_value) '_' num2str(handles.upper_limit_mz_value) 'fn' foldername 'ns' num2str(handles.number_of_scans) 'LC' num2str(handles.lower_limit_for_grayscale_color) 'HC' num2str(handles.higher_limit_for_grayscale_color) 'IV' num2str(handles.val_across_interpolated_data) '_' num2str(handles.val_down_interpolated_data) 'C' colormap_name '.tif'];
        else
            handles.name = ['mz' num2str(handles.lower_limit_mz_value) '_' 'MASK' '_' num2str(handles.upper_limit_mz_value) 'fn' foldername 'ns' num2str(handles.number_of_scans) 'LC' num2str(handles.lower_limit_for_grayscale_color) 'HC' num2str(handles.higher_limit_for_grayscale_color) 'IV' num2str(handles.val_across_interpolated_data) '_' num2str(handles.val_down_interpolated_data) 'C' colormap_name '.tif'];
        end
        [dpi, mag] = get_dpi_and_mag(handles);
        export_fig([handles.pathname 'Images' filesep handles.name], gcf,sprintf('-m%g', mag));
        if ~isfield(handles, 'new_x')
            if strcmp(matFile, 'yes')
                save([handles.pathname 'Images' filesep handles.name(1:end-3) 'mat'],'sum_of_intensities')
            end
            if strcmp(excelFile, 'yes')
                dlmwrite([handles.pathname 'Images' filesep handles.name(1:end-3) 'csv'], handles.sum_of_intensities, 'precision','%i')
            end
        end
        close(h)
        matrix(list_box_i,1) = handles.lower_limit_mz_value;
        matrix(list_box_i,2:((size(handles.sum_of_intensities,1)*size(handles.sum_of_intensities,2)+1))) = reshape(handles.sum_of_intensities',[1, size(handles.sum_of_intensities,1)*size(handles.sum_of_intensities,2)]);
        done_with_loop_time = toc(time_val)*(size(handles.contents,2)-list_box_i);
        inform_user('Process 4: Saving Ion Image - ', handles, list_box_i, done_with_loop_time, size(handles.contents,2))
    end
    dlmwrite([handles.pathname handles.saveDataToFolder filesep 'matrix.txt'],matrix);
    contents_t = strjoin(arrayfun(@(x) num2str(x),handles.contents,'UniformOutput',false),', ');
    handles = set_proven_variable(hObject, 'dpiVal', num2str(dpi), handles);
    handles = set_proven_variable(hObject, 'imageListToSave', contents_t, handles);
    handles.execs{numel(handles.execs)+1} = 'save_grayscale_image_as_tiff_Callback(hObject,[],handles)';
    guidata(hObject,handles);
    stop_logging();
    set(handles.software_free, 'BackgroundColor', 'green');
catch MExc
    show_error(MExc);
end


function move_upper_bar_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    axes(handles.intensity_vs_frequency_spectrum);
    if isempty(handles.limits_not_working)
        handles.upper_limit_mz_value = getPosition(handles.h_upper);
        handles.upper_limit_mz_value = round(handles.upper_limit_mz_value(1));
        handles.upper_limit_mz_value = handles.upper_limit_mz_value + 1;
    else
        handles.upper_limit_mz_value = round(handles.h_upper(1));
        handles.upper_limit_mz_value = handles.upper_limit_mz_value + 1;
        handles.limits_not_working = [];
    end
    set(handles.upper_limit_mz_value_box, 'string', num2str(handles.upper_limit_mz_value))
    limit_mz_value_box(nan, num2str(handles.upper_limit_mz_value), handles)
    if isempty(handles.limits_not_working)
        delete(handles.h_upper)
    else
        handles.limits_not_working = [];
    end
    axes(handles.intensity_vs_frequency_spectrum);
    handles.h_upper = imline(gca, [handles.upper_limit_mz_value handles.upper_limit_mz_value], [0 handles.max_intensity]);
    api = iptgetapi(handles.h_upper);
    api.setColor([1 0 0]);
    fcn = makeConstrainToRectFcn('imline', [0, handles.max_mass],...
        [0, handles.max_intensity]);
    api.setPositionConstraintFcn(fcn);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function move_lower_bar_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    axes(handles.intensity_vs_frequency_spectrum);
    if isempty(handles.limits_not_working)
        handles.lower_limit_mz_value = getPosition(handles.h_lower);
        handles.lower_limit_mz_value = round(handles.lower_limit_mz_value(1));
        handles.lower_limit_mz_value = handles.lower_limit_mz_value - 1;
    else
        handles.lower_limit_mz_value = round(handles.h_lower(1));
        handles.lower_limit_mz_value = handles.lower_limit_mz_value - 1;
        handles.limits_not_working = [];
    end
    limit_mz_value_box(num2str(handles.lower_limit_mz_value),nan, handles)
    if isempty(handles.limits_not_working)
        delete(handles.h_lower)
    else
        handles.limits_not_working = [];
    end
    axes(handles.intensity_vs_frequency_spectrum);
    handles.h_lower = imline(gca, [handles.lower_limit_mz_value handles.lower_limit_mz_value], [0 handles.max_intensity]);
    api2 = iptgetapi(handles.h_lower);
    api2.setColor([1 0 0]);
    fcn = makeConstrainToRectFcn('imline', [0, handles.max_mass],...
        [0, handles.max_intensity]);
    api2.setPositionConstraintFcn(fcn);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function move_upper_bar_backward_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    axes(handles.intensity_vs_frequency_spectrum);
    if isempty(handles.limits_not_working)
        handles.upper_limit_mz_value = getPosition(handles.h_upper);
        handles.upper_limit_mz_value = round(handles.upper_limit_mz_value(1));
        handles.upper_limit_mz_value = handles.upper_limit_mz_value - 1;
    else
        handles.upper_limit_mz_value = round(handles.h_upper(1));
        handles.upper_limit_mz_value = handles.upper_limit_mz_value - 1;
        handles.limits_not_working = [];
    end
    limit_mz_value_box(nan, num2str(handles.upper_limit_mz_value), handles)
    if isempty(handles.limits_not_working)
        delete(handles.h_upper)
    else
        handles.limits_not_working = [];
    end
    axes(handles.intensity_vs_frequency_spectrum);
    handles.h_upper = imline(gca, [handles.upper_limit_mz_value handles.upper_limit_mz_value], [0 handles.max_intensity]);
    api = iptgetapi(handles.h_upper);
    api.setColor([1 0 0]);
    fcn = makeConstrainToRectFcn('imline', [0, handles.max_mass],...
        [0, handles.max_intensity]);
    api.setPositionConstraintFcn(fcn);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function move_lower_bar_forward_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    axes(handles.intensity_vs_frequency_spectrum);
    if isempty(handles.limits_not_working)
        handles.lower_limit_mz_value = getPosition(handles.h_lower);
        handles.lower_limit_mz_value = round(handles.lower_limit_mz_value(1));
        handles.lower_limit_mz_value = handles.lower_limit_mz_value + 1;
    else
        handles.lower_limit_mz_value = round(handles.h_lower(1));
        handles.lower_limit_mz_value = handles.lower_limit_mz_value + 1;
    end
    limit_mz_value_box(num2str(handles.lower_limit_mz_value),nan, handles)
    if isempty(handles.limits_not_working)
        delete(handles.h_lower)
    else
        handles.limits_not_working = [];
    end
    axes(handles.intensity_vs_frequency_spectrum);
    handles.h_lower = imline(gca, [handles.lower_limit_mz_value handles.lower_limit_mz_value], [0 handles.max_intensity]);
    api2 = iptgetapi(handles.h_lower);
    api2.setColor([1 0 0]);
    fcn = makeConstrainToRectFcn('imline', [0, handles.max_mass],...
        [0, handles.max_intensity]);
    api2.setPositionConstraintFcn(fcn);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function display_grayscale_image_with_new_limits_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles = get_lower_and_upper_grayscale_color(handles);
    xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    xnorm(xnorm < handles.lower_limit_for_grayscale_color) = handles.lower_limit_for_grayscale_color;
    xnorm(xnorm > handles.higher_limit_for_grayscale_color) = handles.higher_limit_for_grayscale_color;
    if isempty(handles.image_window_to_display_value)
        handles.image_window_to_display_value = 1;
    end
    handle_display_image_window(handles, true);
    imagesc(xnorm);
    xlabel('Scan'); ylabel('Line');
    colormap(handles.colormap_3d); set_colorbar();
    handles.sum_of_intensities = xnorm;
    handles.sum_of_intensities2 = handles.sum_of_intensities;
    comb = strjoin({num2str(handles.lower_limit_for_grayscale_color), num2str(handles.higher_limit_for_grayscale_color)},', ');
    handles = set_proven_variable(hObject, 'scaleImageValues', comb, handles);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function personal_colormap_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    white = [255 255 255];
    blue = [0,0,255]; 
    green = [0,255,0]; 
    red = [255,0,0]; 
    yellow = [255,255,0]; 
    gray = [169,169,169]; 
    black = [0 0 0];
    cyan = [0, 255, 255];
    magenta = [255, 0, 255];
    copper = [210, 180, 140];
    orange = [255, 140, 0];
    brown = [165, 42, 42];
    pink = [255, 105, 180];
    colorList = {black, blue, red, green, yellow, gray, copper, orange, brown, cyan, pink, magenta, white};
    final_colormap = zeros(100,3);
    %Scale Vals
    for i = 1:25; temp.(['v' num2str(i)]) = str2double(get(handles.(['edit' num2str(1000+ i)]),'string')); end
    %Color List
    handles.final_colormap(1,:) = black;
    fieldNames = fieldnames(temp);
    for i = 1:length(fieldnames(temp))
        if temp.(fieldNames{i,1}) > 0
            cur_color = colorList{1, handles.color1_colormap3d_value};
            handles.final_colormap(fieldNames{i-1,1}:fieldNames{i,1},:) = repmat(cur_color,fieldNames{i,1}-fieldNames{i-1,1}+1,1);
        end
    end
    handles.final_colormap(99:100,:) = repmat(white,2,1);
    handles.colormap_3d = handles.final_colormap/255;
    colormap(handles.colormap_3d);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function edit1000_Callback(~, ~, ~)


function edit1000_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1002_Callback(hObject,~,~)
handles = guidata(hObject);
val_w1 = str2double(get(hObject,'String'));
max_val = get(handles.edit1001,'string');
lim_val = (str2double(max_val));
if lim_val > val_w1
    warndlg([num2str(val_w1) ' should be greater than previous number ' num2str(lim_val)],'!! Warning !!')
    set(handles.edit1002, 'String', num2str(lim_val));
elseif val_w1 > 98
    warndlg([num2str(val_w1) ' should be less than or equal to ' num2str(98)],'!! Warning !!')
    set(handles.edit1002, 'String', num2str(lim_val+1));    
end
guidata(hObject,handles);


function edit1002_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color1_Callback(hObject, ~, ~)
handles = guidata(hObject);
handles.color1_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);


function color1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1060_Callback(hObject,~,~)
handles = guidata(hObject);
set(handles.edit1060, 'String', num2str(99));
guidata(hObject,handles);

function edit1060_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1061_Callback(hObject,~,~)
handles = guidata(hObject);
set(handles.edit1061, 'String', num2str(100));
guidata(hObject,handles);


function edit1061_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color2_Callback(hObject, ~, ~)
handles = guidata(hObject);
handles.color2_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color2_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1004_Callback(~, ~, ~)


function edit1004_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1006_Callback(~, ~, ~)


function edit1006_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color3_Callback(hObject, ~, ~)
handles = guidata(hObject);
handles.color3_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color3_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1008_Callback(~, ~, ~)


function edit1008_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color4_Callback(hObject, ~, ~)
handles = guidata(hObject);
handles.color4_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color4_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1010_Callback(~, ~, ~)


function edit1010_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color5_Callback(hObject, ~, ~)
handles = guidata(hObject);
handles.color5_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color5_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1012_Callback(~, ~, ~)


function edit1012_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color6_Callback(hObject, ~, ~)
handles = guidata(hObject);
handles.color6_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color6_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function refresh_image_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if isempty(handles.image_window_to_display_value)
        handles.image_window_to_display_value = 1;
    end
    handle_display_image_window(handles, true);
    if isfield(handles, 'sum_of_intensities6') 
        check_folder = strcat(handles.pathname,'Images', filesep,'Grayscale_Data.mat');
        if exist(check_folder,'file')
            load(check_folder)
        end
        xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    else
        xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    end
    handle_display_image_window(handles, false);
    xnorm = remove_noise_spikes_from_image(xnorm, 20);
    xnorm = scale_image_to_fixed_limits(0, 100, xnorm);
    imagesc(xnorm);
    xlabel('Scan'); ylabel('Line');
    colormap(handles.colormap_3d);
    set_colorbar();
    handles.lower_limit_for_grayscale_color = 0;
    handles.higher_limit_for_grayscale_color = 100;
    handles.val_across_interpolated_data = [];
    handles.val_down_interpolated_data = [];
    handles.execs{numel(handles.execs)+1} = 'refresh_image_Callback(hObject,[],handles)';
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function editbox_across_interpolated_data_Callback(~, ~, ~)


function editbox_across_interpolated_data_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function show_interpolated_sum_of_intensities_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles = set_get_val_across_interpolated_data(handles);
    button = questdlg(['The current size of the image is ' num2str(size(handles.sum_of_intensities,1)) ' X ' num2str(size(handles.sum_of_intensities,2)) '. If the smoothing process is applied, the size will be ' num2str(size(handles.sum_of_intensities,1)*handles.val_down_interpolated_data) ' X ' num2str(size(handles.sum_of_intensities,2)*handles.val_across_interpolated_data) '. Only apply this if your system has enough RAM.'],...
        'Warning',...
        'OK','Cancel','OK');
    switch button
        case 'OK'
            handles.sum_of_intensities = imresize(handles.sum_of_intensities(:,:),[size(handles.sum_of_intensities,1)*handles.val_down_interpolated_data,size(handles.sum_of_intensities,2)*handles.val_across_interpolated_data],'bilinear');
            if isempty(handles.image_window_to_display_value)
                handles.image_window_to_display_value = 1;
            end
            handle_display_image_window(handles, true);
            handles.sum_of_intensities = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
            handles.sum_of_intensities = remove_noise_spikes_from_image(handles.sum_of_intensities, 20);
            handles.sum_of_intensities = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
            imagesc(handles.sum_of_intensities,[handles.lower_limit_for_grayscale_color, handles.higher_limit_for_grayscale_color]); %[lower_limit_for_grayscale_color-5, higher_limit_for_grayscale_color+5]);
            xlabel('Scan'); ylabel('Line');
            colormap(handles.colormap_3d);
            set_colorbar();
            comb = strjoin({num2str(handles.val_down_interpolated_data), num2str(handles.val_across_interpolated_data)},', ');
            handles = set_proven_variable(hObject, 'interpolatedDataValues', comb, handles);
        case 'Cancel'
    end
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function editbox_down_interpolated_data_Callback(~, ~, ~)


function editbox_down_interpolated_data_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function browse_grayscale_image_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    [filename, handles.pathname, ~] = uigetfile( ...
        {  '*.mat','MAT-files (*.mat)'}, ...
        'Pick a file');
    current_dir = pwd;
    cd(handles.pathname(1:end-1));
    set(handles.edit_for_browse_grayscale_image,'string',filename);
    handles.sum_of_intensities = load('Grayscale_Data.mat','-mat','sum_of_intensities');
    handles.sum_of_intensities = handles.sum_of_intensities.sum_of_intensities;
    handles.colormap_3d = load('Grayscale_Data.mat','-mat','colormap_3d');
    handles.colormap_3d = handles.colormap_3d.colormap_3d;
    handles.O_was_present = load('Grayscale_Data.mat','-mat','O_was_present');
    handles.O_was_present = handles.O_was_present.O_was_present;
    handles.check_point_count = load('Grayscale_Data.mat','-mat','check_point_count');
    handles.check_point_count = handles.check_point_count.check_point_count;
    handles.count_2 = load('Grayscale_Data.mat','-mat','count_2');
    handles.count_2 = handles.count_2.count_2;
    handles.double_range_value = load('Grayscale_Data.mat','-mat','double_range_value');
    handles.double_range_value = handles.double_range_value.double_range_value;
    handles.sum_of_intensities = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    which_image_window_without_set(handles.image_window_to_display_value, handles.sum_of_intensities, handles.colormap_3d, handles)
    handles.sum_of_intensities6 = handles.sum_of_intensities;
    guidata(hObject,handles);
    cd(current_dir)
    stop_logging();
catch MExc
    show_error(MExc);
end


function edit_for_browse_grayscale_image_Callback(~, ~, ~)


function edit_for_browse_grayscale_image_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function redo_for_new_ranges_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    redo_for_spreadsheet(hObject, handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function remove_lines_edit_box_Callback(~,~,~)


function remove_lines_edit_box_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function remove_lines_from_grayscale_image_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles = remove_lines_edit_box(handles);
    sum_of_intensities = handles.sum_of_intensities;
    current_folder = pwd;
    cd([handles.pathname filesep handles.saveTempFilesToFolder])
    save('org_sum_of_intensities','sum_of_intensities');
    cd(current_folder);
    original_number_of_lines = 1:size(handles.sum_of_intensities,1);
    unique_elements_after_removing_lines = setdiff(original_number_of_lines, handles.lines_to_remove_from_image);
    for i = 1:size(unique_elements_after_removing_lines,2)
        handles.sum_of_intensities(i,:) = handles.sum_of_intensities(unique_elements_after_removing_lines(i),:);
    end
    handles.sum_of_intensities = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    handles.sum_of_intensities(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
    which_image_window_without_set(handles.image_window_to_display_value, handles.sum_of_intensities, handles.colormap_3d, handles);
    handles = set_proven_variable(hObject, 'removeLines', handles.lines_to_remove_from_image, handles);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function start_with_line_number_editbox_Callback(~,~,~)


function start_with_line_number_editbox_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function select_image_to_display_Callback(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.image_window_to_display_value = get(hObject, 'Value');
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function select_image_to_display_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function enter_vals_for_multiple_mz_Callback(~,~,~)


function enter_vals_for_multiple_mz_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editbox_for_enter_threshold_value_Callback(~,~,~)


function editbox_for_enter_threshold_value_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function open_decon2ls_for_new_parameter_file_Callback(~,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if ispc
        if exist('C:\Program Files (x86)\Decon2LS','dir')
            dos('C:\Program Files (x86)\Decon2LS\Decon2LS.exe');
        elseif exist('C:\Program Files\Decon2LS','dir')
            dos('C:\Program Files\Decon2LS\Decon2LS.exe');
        else
            load('C:\vis_xcalibur_raw_files\Info_Path.mat')
            name = uu{1,1}{2,1}; %#ok<*NODEF>
            if exist(name,'dir')
                dos(name);
            else
                [filename_temp, pathname_temp, ~] = uigetfile( ...
                    {  '*.*'}, ...
                    'Determine Location for Decon2LS');
                loc = strcat(pathname_temp,filename_temp);
                uu{1,1}{2,1} = loc;
                save 'C:\vis_xcalibur_raw_files\Info_Path.mat' uu
            end
        end
    else
        disp('DECON only works on Windows Platform')
    end
    stop_logging();
catch MExc
    show_error(MExc);
end


function start_decon_tool_auto_Callback(~,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if ispc
        if exist('C:\Program Files (x86)\DeconTools AutoProcessor','dir')
            dos('C:\Program Files (x86)\DeconTools AutoProcessor\DeconToolsAutoProcessV1.exe');
        elseif exist('C:\Program Files\DeconTools AutoProcessor','dir')
            dos('C:\Program Files\DeconTools AutoProcessor\DeconToolsAutoProcessV1.exe');  else
            load('C:\vis_xcalibur_raw_files\Info_Path.mat')
            name = uu{1,1}{4,1};
            if exist(name,'dir')
                dos(name);
            else
                [filename_temp, pathname_temp, ~] = uigetfile( ...
                    {  '*.*'}, ...
                    'Determine Location for Decon2LS');
                loc = strcat(pathname_temp,filename_temp);
                uu{1,1}{4,1} = loc;
                save 'C:\vis_xcalibur_raw_files\Info_Path.mat' uu
            end
        end
    else
        disp('DECON only works on Windows Platform')
    end
    stop_logging();
catch MExc
    show_error(MExc);
end


function start_KeyPressFcn(~,~,~)


function move_lower_bar_KeyPressFcn(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if strcmp(get(gcf,'CurrentCharacter'),'h')
        move_lower_bar_Callback(hObject,[],handles)
    elseif strcmp(get(gcf,'CurrentCharacter'),'j')
        move_lower_bar_forward_Callback(hObject,[],handles)
    elseif strcmp(get(gcf,'CurrentCharacter'),'k')
        move_upper_bar_backward_Callback(hObject,[],handles)
    elseif strcmp(get(gcf,'CurrentCharacter'),'l')
        move_upper_bar_Callback(hObject,[],handles)
    end
    stop_logging();
catch MExc
    show_error(MExc);
end


function move_lower_bar_forward_KeyPressFcn(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if strcmp(get(gcf,'CurrentCharacter'),'h')
        move_lower_bar_Callback(hObject,[],handles)
    elseif strcmp(get(gcf,'CurrentCharacter'),'j')
        move_lower_bar_forward_Callback(hObject,[],handles)
    elseif strcmp(get(gcf,'CurrentCharacter'),'k')
        move_upper_bar_backward_Callback(hObject,[],handles)
    elseif strcmp(get(gcf,'CurrentCharacter'),'l')
        move_upper_bar_Callback(hObject,[],handles)
    end
    stop_logging();
catch MExc
    show_error(MExc);
end


function handles = next_time_for_mz_plot_Callback(hObject,~,handles)
try
    handles = delete_timeplot_line(handles);
    start_logging(handles);
    handles.time_bar_val = handles.time_bar_val + 1;
    handles = next_prev_sum(hObject, handles);
catch MExc
    show_error(MExc);
end


function handles = prev_time_for_mz_plot_Callback(hObject,~,handles)
try
    start_logging(handles);
    handles = delete_timeplot_line(handles);
    handles.time_bar_val = handles.time_bar_val - 1;
    handles = next_prev_sum(hObject, handles);
catch MExc
    show_error(MExc);
end

function handles = next_prev_sum(hObject, handles)
    loc = find(handles.RAW_filename_new2 == filesep);
    name = handles.RAW_filename_new2(loc(end)+1:end);
    cd(handles.pathname(1:end-1));
    set(handles.filename_display_for_int_freq_spec, 'String', name);   %displays filename in the edit box
    sure1_intensity(1:handles.point_count(handles.time_bar_val)) = handles.intensity_values(sum(handles.point_count(1:handles.time_bar_val-1))+1:sum(handles.point_count(1:handles.time_bar_val)));
    sure1_mass(1:handles.point_count(handles.time_bar_val)) = handles.mass_values(sum(handles.point_count(1:handles.time_bar_val-1))+1:sum(handles.point_count(1:handles.time_bar_val)));
    if ~isfield(handles,'upper_limit_mz_value')
        handles.upper_limit_mz_value = single(round(handles.mass_range_max(handles.time_bar_val)-20));
        handles.lower_limit_mz_value = single(round(handles.mass_range_min(handles.time_bar_val)+20));
    end
    handles.start_size_sum_of_intensities = size(handles.point_count,1);
    handles = delete_timeplot_UnL_lines(handles);
    limit_mz_value_box(num2str(handles.lower_limit_mz_value), num2str(handles.upper_limit_mz_value), handles)
    axes(handles.intensity_vs_frequency_spectrum);
    plot(sure1_mass,sure1_intensity); xlabel('m/z'); ylabel('Intensity');
    axis tight
    handles.max_intensity = max(sure1_intensity(:));
    handles = delete_timeplot_UnL_lines(handles);
    handles.h_upper = imline(gca, [handles.upper_limit_mz_value handles.upper_limit_mz_value], [0 handles.max_intensity]);
    api = iptgetapi(handles.h_upper);
    api.setColor([1 0 0]);
    fcn = makeConstrainToRectFcn('imline', [0, handles.mass_range_max(handles.time_bar_val)],...
        [0, handles.max_intensity]);
    api.setPositionConstraintFcn(fcn);
    handles.h_lower = imline(gca, [handles.lower_limit_mz_value handles.lower_limit_mz_value], [0 handles.max_intensity]);
    api = iptgetapi(handles.h_lower);
    api.setColor([1 0 0]);
    fcn = makeConstrainToRectFcn('imline', [0, handles.mass_range_max(handles.time_bar_val)],...
        [0, handles.max_intensity]);
    api.setPositionConstraintFcn(fcn);
    axis tight
    axes(handles.axes_for_mz_values_0);
    if numel(handles.scan_acquisition_time) < 10
        plot(handles.scan_acquisition_time, handles.total_intensity,'--b*');
    else
        plot(handles.scan_acquisition_time, handles.total_intensity);
    end
    handles = delete_timeplot_line(handles);
    handles.h_t = imline(gca, [handles.scan_acquisition_time(handles.time_bar_val) handles.scan_acquisition_time(handles.time_bar_val)], [0 max(handles.total_intensity(:))]);
    api = iptgetapi(handles.h_t);
    api.setColor([1 0 1]);
    fcn = makeConstrainToRectFcn('imline', [handles.scan_acquisition_time(1), handles.scan_acquisition_time(end)],...
        [0, max(handles.total_intensity(:))]);
    api.setPositionConstraintFcn(fcn);
    axis tight
    set(handles.axes_for_mz_values_0, 'buttondownfcn',@axes_for_mz_values_0_ButtonDownFcn);
    guidata(hObject,handles);
    stop_logging();


function normalize_data_checkbox_Callback(hObject,~,~)
handles = guidata(hObject);
handles.normalize_data_mode = (get(hObject, 'Value'));
guidata(hObject,handles);

function next_sum_of_intensities_number_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    h2 = waitbar(0.25,'Please wait...');
    set(handles.software_free, 'BackgroundColor', 'red');
    handles.next_sum_folder = handles.next_sum_folder + 1;
    if handles.next_sum_folder-1 > handles.size_count_limits
        handles.next_sum_folder = 2;
    end
    handles.sum_of_intensities = generate_ion_images_from_single_line_scans(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,'sum_of_intensities',num2str(handles.next_sum_folder)), handles.org_sum_of_int1, handles.org_sum_of_int2, handles.sum_of_intensities);
    handles = apply_manipulations_to_all_ion_images(handles);
    handles.sum_of_intensities = which_image_window(handles.image_window_to_display_value, handles.sum_of_intensities, handles.lower_limits_count(handles.next_sum_folder-1), handles.upper_limits_count(handles.next_sum_folder-1), handles.colormap_3d, handles);
    handles.lower_limit_mz_value = handles.lower_limits_count(handles.next_sum_folder-1);
    handles.upper_limit_mz_value = handles.upper_limits_count(handles.next_sum_folder-1);
    close(h2)
    guidata(hObject,handles);
    set(handles.software_free, 'BackgroundColor', 'green');
    stop_logging();
catch MExc
    show_error(MExc);
end


function handles = prev_sum_of_intensities_number_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    h2 = waitbar(0.25,'Please wait...');
    set(handles.software_free, 'BackgroundColor', 'red');
    handles.next_sum_folder = handles.next_sum_folder - 1;
    if handles.next_sum_folder-1 < 1
        handles.next_sum_folder = handles.size_count_limits+1;
    end
    handles.sum_of_intensities = generate_ion_images_from_single_line_scans(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,'sum_of_intensities',num2str(handles.next_sum_folder)), handles.org_sum_of_int1, handles.org_sum_of_int2,handles.sum_of_intensities);
    handles = apply_manipulations_to_all_ion_images(handles);
    handles.sum_of_intensities = which_image_window(handles.image_window_to_display_value, handles.sum_of_intensities, handles.lower_limits_count(handles.next_sum_folder-1), handles.upper_limits_count(handles.next_sum_folder-1), handles.colormap_3d, handles);
    handles.lower_limit_mz_value = handles.lower_limits_count(handles.next_sum_folder-1);
    handles.upper_limit_mz_value = handles.upper_limits_count(handles.next_sum_folder-1);
    close(h2)
    guidata(hObject,handles);
    set(handles.software_free, 'BackgroundColor', 'green');
    stop_logging();
catch MExc
    show_error(MExc);
end


function lower_limit_axes2_Callback(~,~,~)


function lower_limit_axes2_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function upper_limit_axes2_Callback(~,~,~)


function upper_limit_axes2_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lower_limit_axes1_Callback(~,~,~)


function lower_limit_axes1_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upper_limit_axes1_Callback(~,~,~)


function upper_limit_axes1_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function save_axis_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if handles.autoflow == 0
        handles.axis_save = (get(hObject, 'Value'));
    end
    handles = set_proven_variable(hObject, 'includeAxisImageSave', num2str(handles.axis_save), handles);
    handles.execs{numel(handles.execs)+1} = 'save_axis_Callback(hObject,[],handles)';
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function dpi_value_Callback(~,~,~)


function dpi_value_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function apply_manipulations_to_all_images_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.apply_manipulations_to_all = (get(hObject, 'Value'));
    handles = set_proven_variable(hObject, 'applyChangesToAllImages', num2str(handles.apply_manipulations_to_all), handles);
    handles.execs{numel(handles.execs)+1} = ['apply_manipulation(', num2str(handles.apply_manipulations_to_all), ',hObject)'];
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function apply_manipulation(value, hObject)
handles = guidata(hObject);
handles.apply_manipulations_to_all = value;
set(handles.apply_manipulations_to_all_images,'Value', value)
handles.execs{numel(handles.execs)+1} = ['apply_manipulation(', num2str(handles.apply_manipulations_to_all), ',hObject)'];
guidata(hObject,handles);

function export_pixel_vals_excel_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if handles.image_window_to_display_value == 1
        l_a = get(handles.lower_limit_axes1,'string');
        u_a = get(handles.upper_limit_axes1,'string');
    else
        l_a = get(handles.lower_limit_axes2,'string');
        u_a = get(handles.upper_limit_axes2,'string');
    end
    current_path = pwd;
    new_path = uigetdir;
    if isempty(handles.sum_of_intensities2)
        handles.sum_of_intensities2 = handles.sum_of_intensities;
    end
    cd(new_path)
    xlswrite(strcat('Pixel_Values_',num2str(l_a),'_',num2str(u_a),'.xlsx'),handles.sum_of_intensities2)
    cd(current_path)
    handles.execs{numel(handles.execs)+1} = 'export_pixel_vals_excel_Callback(hObject,[],handles)';
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function close_overlay_panel_Callback(~,~,~)


function popupmenu_overlay1_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    contents = cellstr(get(hObject,'String'));
    handles.overlay1_val = contents{get(hObject,'Value')};
    handles.overlay1_val = str2double(handles.overlay1_val);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function popupmenu_overlay1_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu_overlay2_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    contents = cellstr(get(hObject,'String'));
    handles.overlay2_val = contents{get(hObject,'Value')};
    handles.overlay2_val = str2double(handles.overlay2_val);
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function popupmenu_overlay2_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Overlay_images_button_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    temp_name = dir(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,'sum_of_intensities*.mat'));
    load(strcat(handles.pathname, handles.saveTempFilesToFolder,filesep,temp_name(handles.overlay1_val,1).name))
    handles.sum_of_intensities = sum_of_intensities2;
    if handles.apply_manipulations_to_all == 1
        %%Remove unwanted lines
        handles = remove_lines_edit_box(handles);
        if ~isempty(handles.lines_to_remove_from_image)
            original_number_of_lines = 1:size(handles.sum_of_intensities,1);
            unique_elements_after_removing_lines = setdiff(original_number_of_lines, handles.lines_to_remove_from_image);
            for i = 1:size(unique_elements_after_removing_lines,2)
                handles.sum_of_intensities(i,:) = handles.sum_of_intensities(unique_elements_after_removing_lines(i),:);                
            end
            handles.sum_of_intensities(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
        end
        %% Show Interpolated Values
        handles = set_get_val_across_interpolated_data(handles);
        if ~isempty(handles.val_across_interpolated_data)
            handles.sum_of_intensities = imresize(handles.sum_of_intensities(:,:),[size(handles.sum_of_intensities,1)*handles.val_down_interpolated_data,size(handles.sum_of_intensities,2)*handles.val_across_interpolated_data],'bilinear');
        end
        %% Adjust Scale
        handles = get_lower_and_upper_grayscale_color(handles);
    end
    xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    if handles.apply_manipulations_to_all == 1
        if ~isempty(handles.lower_limit_for_grayscale_color)
            xnorm(xnorm < handles.lower_limit_for_grayscale_color) = handles.lower_limit_for_grayscale_color;
            xnorm(xnorm > handles.higher_limit_for_grayscale_color) = handles.higher_limit_for_grayscale_color;
            handles.sum_of_intensities = xnorm;
        end
    end
    sum_of_intensities_temp1 = handles.sum_of_intensities;
    load(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,temp_name(handles.overlay2_val,1).name))
    handles.sum_of_intensities = sum_of_intensities2;
    if handles.apply_manipulations_to_all == 1
        %%Remove unwanted lines
        handles = remove_lines_edit_box(handles);
        if ~isempty(handles.lines_to_remove_from_image)
            original_number_of_lines = 1:size(handles.sum_of_intensities,1);
            unique_elements_after_removing_lines = setdiff(original_number_of_lines, handles.lines_to_remove_from_image);
            for i = 1:size(unique_elements_after_removing_lines,2)
                handles.sum_of_intensities(i,:) = handles.sum_of_intensities(unique_elements_after_removing_lines(i),:);
                
            end
            handles.sum_of_intensities(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
        end
        %% Show Interpolated Values
        handles = set_get_val_across_interpolated_data(handles);
        if ~isempty(handles.val_across_interpolated_data)
            handles.sum_of_intensities = imresize(handles.sum_of_intensities(:,:),[size(handles.sum_of_intensities,1)*handles.val_down_interpolated_data,size(handles.sum_of_intensities,2)*handles.val_across_interpolated_data],'bilinear');
        end
        %% Adjust Scale
        handles = get_lower_and_upper_grayscale_color(handles);
    end
    xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    if handles.apply_manipulations_to_all == 1
        if ~isempty(handles.lower_limit_for_grayscale_color)
            xnorm(xnorm < handles.lower_limit_for_grayscale_color) = handles.lower_limit_for_grayscale_color;
            xnorm(xnorm > handles.higher_limit_for_grayscale_color) = handles.higher_limit_for_grayscale_color;
            handles.sum_of_intensities = xnorm;
        end
    end
    if isempty(handles.method_for_overlay)
        handles.method_for_overlay = 1;
    end
    if handles.method_for_overlay == 1
        sum_of_intensities3 = sum_of_intensities_temp1 - handles.sum_of_intensities;
    elseif handles.method_for_overlay == 2
        sum_of_intensities3 = (sum_of_intensities_temp1 + handles.sum_of_intensities)/2;
    end
    if isempty(handles.image_window_to_display_value)
        handles.image_window_to_display_value = 1;
    end
    if handles.method_for_overlay == 3
        if isempty(handles.transperancy_val_image1)
            handles.transperancy_val_image1 = 0.5;
        end
        if isempty(handles.transperancy_val_image2)
            handles.transperancy_val_image2 = 0.5;
        end
        figure(1);
        h1 = imsc(sum_of_intensities_temp1,'jet'); axis off; colorbar('off');
        set(h1,'AlphaData',handles.transperancy_val_image1);
        hold on
        h = imsc(handles.sum_of_intensities,'hot'); axis off; colorbar('off');
        set(h,'AlphaData',handles.transperancy_val_image2);
        hold off
        xlabel('Scan'); ylabel('Line');
    else
        handle_display_image_window(handles, true);
        xnorm = scale_image_to_fixed_limits(0, 100, sum_of_intensities3);
        xnorm = remove_noise_spikes_from_image(xnorm, 20);
        xnorm = scale_image_to_fixed_limits(0, 100, xnorm);
        imagesc(xnorm);
        xlabel('Scan'); ylabel('Line');
        colormap(handles.colormap_3d); set_colorbar();
    end
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function overlay_method_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.method_for_overlay = get(hObject,'Value');
    guidata(hObject,handles);
    stop_logging();
catch MExc
    disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end


function overlay_method_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu_transperancy_factor_image1_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    contents = cellstr(get(hObject,'String'));
    handles.transperancy_val_image1 = contents{get(hObject,'Value')};
    handles.transperancy_val_image1 = str2double(handles.transperancy_val_image1);
    Overlay_images_button_Callback(hObject,[],handles)
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function popupmenu_transperancy_factor_image1_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu_transperancy_factor_image2_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    contents = cellstr(get(hObject,'String'));
    handles.transperancy_val_image2 = contents{get(hObject,'Value')};
    handles.transperancy_val_image2 = str2double(handles.transperancy_val_image2);
    Overlay_images_button_Callback(hObject,[],handles)
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function popupmenu_transperancy_factor_image2_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function align_sum_of_intensities_Callback(hObject,~,~)
handles = guidata(hObject);
[handles] = align_ion_image(handles);
which_image_window_without_set(handles.image_window_to_display_value, handles.sum_of_intensities2, handles.colormap_3d, handles)
handles.execs{numel(handles.execs)+1} = 'align_sum_of_intensities_Callback(hObject,[],handles)';
guidata(hObject,handles);

function normalize_data_lower_limit_Callback(~,~,~)


function normalize_data_lower_limit_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function normalize_data_higher_limit_Callback(~,~,~)


function normalize_data_higher_limit_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function save_settings_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    n1 = handles.filename;
    n2 = handles.count_2;
    n3 = handles.number_of_scans;
    n4 = size(handles.sum_of_intensities,1);
    n5 = size(handles.sum_of_intensities,2);
    n6 = handles.colormap_3d;
    n7 = handles.O_was_present;
    n8 = handles.lower_limit_mz_value;
    n9 = handles.upper_limit_mz_value;
    n10 = handles.single_range_value;
    n11 = handles.double_range_value;
    n12 = handles.check_point_count;
    n13 = handles.image_window_to_display_value;
    n14 = handles.next_sum_folder;
    n15 = handles.size_count_limits;
    n16 = handles.upper_limits_count;
    n17 = handles.lower_limits_count;
    n18 = handles.normalize_data_mode;     if isempty(n18); n18 = 0; end
    n19 = pwd;
    n20 = get(handles.start_with_line_number_editbox,'string');
    n21 = handles.pathname;
    n22 = handles.across_val;
    n23 = handles.down_val;
    n24 = handles.apply_manipulations_to_all; if isempty(n24); n24 = 0; end
    n25 = handles.user_input_for_mode_manual;
    n26 = handles.user_input_for_mode_auto;
    enter_multiple_values = get(handles.enter_vals_for_multiple_mz,'string');
    threshold_values = get(handles.editbox_for_enter_threshold_value,'string');
    handles = get_normalize_data_limit(handles);
    handles = remove_lines_edit_box(handles);
    n28 = handles.normalize_data_lower_lim;
    n29 = handles.normalize_data_higher_lim;
    handles = set_get_val_across_interpolated_data(handles);
    handles = get_lower_and_upper_grayscale_color(handles);
    xx = find(handles.pathname(1:end-1)=='\');
    list = {n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16,n17,n18,n19,n20,n21, enter_multiple_values,threshold_values,n22,n23,n24,n25,n26,handles.normalize_data_checkbox,n28,n29,handles.lines_to_remove_from_image,handles.val_across_interpolated_data,handles.val_down_interpolated_data,handles.higher_limit_for_grayscale_color,handles.lower_limit_for_grayscale_color,handles.org_sum_of_int1,handles.org_sum_of_int2};
    mat_filename = handles.pathname(xx(end)+1:end-1);
    save(strcat(handles.pathname,'Saved_Parameters','.mat'),'list');
    saveSettings.createDocNames = {'MSI_Settings_for_the_dataset';'Instrument_Settings'};
    saveSettings.saveDocNames = {'_saved_parameters';'_instrument_settings'};
    saveSettings.docNodeElements1 = {'filename';'count_2';'Number_of_scans';'size_sum_of_intensities1';'size_sum_of_intensities2';'colormap_3d';'O_present';'lower_limit_mz_values';'upper_limit_mz_value';'single_range_value';'double_range_value';'check_point_count';'image_window_to_display_value';'next_sum_folder';'size_count_limits';'upper_limits_count';'lower_limits_count';'normalize_data_mode';'pwd';'start_with_line_number';'pathname';'enter_multiple_values';'threshold_values';'across_val';'down_val';'apply_manipulations_to_all';'user_input_for_mode_manual';'user_input_for_mode_auto';'normalize_data_checkbox';'normalize_data_lower_lim';'normalize_data_higher_lim'; 'lines_to_remove_from_image';'val_across_interpolated_data';'val_down_interpolated_data';'higher_limit_for_grayscale_color';'lower_limit_for_grayscale_color';'org_sum_of_int1';'org_sum_of_int2'};
    saveSettings.docNodeElements2 = {'Instrument_Name';'HDF_Path';'ISOS_Path';'RAW_Path';'Image_Path';'Dataset_Name'};
    no_slashes = find(handles.pathname == '\');
    saveSettings.dataset_name = handles.pathname(no_slashes(end-1)+1:no_slashes(end)-1);
    saveSettings.docNodeVals1 = list;
    saveSettings.docNodeVals2 = {'Xcalibur',strcat(handles.pathname,'hdf\'),strcat(handles.pathname,'isos\'),strcat(handles.pathname,'raw\'),strcat(handles.pathname,'image\'),dataset_name};
    for j = 1:2
        docNode = com.mathworks.xml.XMLUtils.createDocument(saveSettings.createDocNames{j,1});
        docRootNode = docNode.getDocumentElement;        
        for i = 1:numel(saveSettings.(['docNodeElements', num2str(j)]))
            thisElement = docNode.createElement(saveSettings.(['docNodeElements', num2str(j)]){i,1});
            thisElement.appendChild(docNode.createTextNode(saveSettings.(['docNodeVals', num2str(j)]){1,i}));
            docRootNode.appendChild(thisElement);
        end
        xmlFileName = strcat(handles.pathname,mat_filename,saveSettings.saveDocNames{j,1},'.xml');
        xmlwrite(xmlFileName,docNode);    
    end
    stop_logging();
    handles.execs{numel(handles.execs)+1} = 'save_settings_Callback(hObject,[],handles)';
    guidata(hObject,handles);
catch MExc
    show_error(MExc);
end


function thickness_of_linescan_Callback(~,~,~)


function thickness_of_linescan_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function draw_line_scan_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    set(handles.software_free, 'BackgroundColor', 'red');
    %% Draw line on an image and get the endpoints
    if isempty(handles.colormap_3d)
        handles.colormap_3d = 'hot'; %default colormap to gray
    end
    handles.sum_of_intensities = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
    cla(handles.grayscale_plot_line_scan);
    axes(handles.grayscale_plot_line_scan);
    imagesc(handles.sum_of_intensities); colormap(handles.colormap_3d); set_colorbar();
    if ~isempty(handles.down_val)
        if handles.down_val > handles.across_val
            width = (handles.temp2(3)*(handles.across_val/handles.down_val));
            set(gca,'Position',[handles.temp1(1) handles.temp1(2) width handles.temp1(4)]) % change axis position
        else
            height = (handles.temp2(4)*(handles.down_val/handles.across_val));
            set(gca,'Position',[handles.temp1(1) handles.temp1(2) handles.temp1(3) height]) % change axis position
        end
    end
    h = imline;
    setColor(h,[0 1 0]);
    pos = getPosition(h);
    %% Get all the coordinate points between the endpoints
    a = [pos(1,1) pos(1,2)];
    b = [pos(2,1) pos(2,2)];
    x = [a(1) b(1)];
    y = [a(2) b(2)];
    linewidth = get(handles.thickness_of_linescan,'string');
    linewidth = single(str2double(linewidth)) + 1;
    line(x,y,'Color','r','LineWidth',linewidth);
    %% For center Line
    a = [pos(1,1) pos(1,2)];
    b = [pos(2,1) pos(2,2)];
    x = [a(1) b(1)];
    y = [a(2) b(2)];
    X = a(1):b(1);
    X = floor(X);
    Y = interp1(x,y,X);
    if isnan(Y(1))
        Y(1) = y(1);
    end
    if isnan(Y(end))
        Y(end) = y(2);
    end
    Y = floor(Y);
    X = sort(X);
    if b(2) < a(2)
        Y = sort(Y,'descend');
    end
    %% Getting the corresponding intensity values from SUM_OF_INTENSITIES
    line_scan = zeros(3,size(X,2),'single');
    for i = 1:size(X,2)
        line_scan(1,i) = handles.sum_of_intensities(Y(i),X(i));
    end
    if linewidth > 1
        count = 2;
        red_inc_val = 0.1;
        for thickness = 1:2:linewidth-1
            %%Higher
            a = [(pos(1,1)+ red_inc_val) pos(1,2)];
            b = [(pos(2,1)+ red_inc_val) pos(2,2)];
            x = [a(1) b(1)];
            y = [a(2) b(2)];
            X = a(1):b(1);
            X = floor(X);
            Y = interp1(x,y,X);
            if isnan(Y(1))
                Y(1) = y(1);
            end
            if isnan(Y(end))
                Y(end) = y(2);
            end
            Y = floor(Y);
            X = sort(X);
            if b(2) < a(2)
                Y = sort(Y,'descend');
            end
            %% Getting the corresponding intensity values from SUM_OF_INTENSITIES
            for i = 1:size(X,2)
                line_scan(count,i) = handles.sum_of_intensities(Y(i),X(i));
            end
            count = count + 1;
            %%Lower
            a = [(pos(1,1)- red_inc_val) pos(1,2)];
            b = [(pos(2,1)- red_inc_val) pos(2,2)];
            x = [a(1) b(1)];
            y = [a(2) b(2)];
            X = a(1):b(1);
            X = floor(X);
            Y = interp1(x,y,X);
            if isnan(Y(1))
                Y(1) = y(1);
            end
            if isnan(Y(end))
                Y(end) = y(2);
            end
            Y = floor(Y);
            X = sort(X);
            if b(2) < a(2)
                Y = sort(Y,'descend');
            end
            %% Getting the corresponding intensity values from SUM_OF_INTENSITIES
            for i = 1:size(X,2)
                line_scan(count,i) = handles.sum_of_intensities(Y(i),X(i));
            end
            count = count + 1;
            red_inc_val = red_inc_val+1;
        end
    end
    
    cla(handles.spectrum_line_scan);
    axes(handles.spectrum_line_scan);
    plot(X,mean(line_scan,1),'Color','r'); xlabel('x-pixel values'); ylabel('Intensity Values');
    handles.final_line_scan = mean(line_scan,1);
    set(handles.uitable1_line_scan, 'Data', handles.final_line_scan)
    set(handles.software_free, 'BackgroundColor', 'green');
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end



function open_line_scan_values_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if exist(strcat(handles.pathname,handles.saveDataToFolder,filesep,'LineScan.xlsx'),'file')
        delete(strcat(handles.pathname,handles.saveDataToFolder,filesep,'LineScan.xlsx'))
    end
    xlswrite(strcat(handles.pathname,handles.saveDataToFolder,filesep,'LineScan.xlsx'),handles.final_line_scan')
    stop_logging();
catch MExc
    show_error(MExc);
end


function save_line_scan_image_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    cd(strcat(handles.pathname,'Images'))
    handles.name = 'Line_Scan';
    [~, mag] = get_dpi_and_mag(handles);
    guidata(hObject,handles);
    export_fig(handles.name, handles.figure1,sprintf('-m%g', mag));
    stop_logging();
catch MExc
    show_error(MExc);
end


function transfer_to_alfresco_Callback(~,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    set(handles.software_free, 'BackgroundColor', 'red');
    prompt = {'Please Provide a Name for the Zip-Folder'};
    dlg_title = 'Required Inputs';
    num_lines = 1;
    zip_name = inputdlg(prompt,dlg_title,num_lines);
    zip_name = zip_name{1,1};
    waitbar(0.25,'Please wait...');
    delete(strcat(handles.pathname,'delete\*.cdf'));
    current_dir = pwd;
    cd(handles.pathname(1:end-1))
    zip(zip_name,{handles.pathname(1:end-1), strcat(handles.pathname,'CDF_Files')})
    cd(current_dir)
    close(h)
    set(handles.software_free, 'BackgroundColor', 'green');
    stop_logging();
catch MExc
    show_error(MExc);
end


function axes_for_mz_values_0_ButtonDownFcn(hObject, ~, ~)
try
    handles = guidata(hObject);
    start_logging(handles);
    set(handles.software_free, 'BackgroundColor', 'red');
    handles.coord = get(handles.axes_for_mz_values_0,'Currentpoint');
    time_val = handles.coord(1);
    [~,bin]=histc(time_val,handles.scan_acquisition_time);
    index=bin+1;
    if abs(time_val-handles.scan_acquisition_time(bin))<abs(time_val-handles.scan_acquisition_time(bin+1))
        handles.fclosest=handles.scan_acquisition_time(bin);
        index=bin;
    else
        handles.fclosest=handles.scan_acquisition_time(index);
    end
    handles = delete_timeplot_UnL_lines(handles);
    handles.time_bar_val = index;
    cd(handles.pathname(1:end-1));
    handles.h_t = imline(gca, [handles.scan_acquisition_time(handles.time_bar_val) handles.scan_acquisition_time(handles.time_bar_val)], [0 max(handles.total_intensity(:))]);
    api = iptgetapi(handles.h_t);
    api.setColor([1 0 1]);
    fcn = makeConstrainToRectFcn('imline', [handles.scan_acquisition_time(1), handles.scan_acquisition_time(end)],...
        [0, max(handles.total_intensity(:))]);
    api.setPositionConstraintFcn(fcn);
    axis tight
    set(handles.axes_for_mz_values_0, 'buttondownfcn',@axes_for_mz_values_0_ButtonDownFcn);
    stop_logging();
    handles = delete_timeplot_line(handles);
    handles = prev_time_for_mz_plot_Callback(hObject,[],handles);
    guidata(hObject,handles);
    set(handles.software_free, 'BackgroundColor', 'green');
catch MExc
    show_error(MExc);
end

% --- Executes on button press in mz_list_generate.
function mz_list_generate_Callback(hObject,~,~)
%Both uz4 and uz4_2 provides a list of mass to charge values from all the
%Decon txt files combined.
%It also displays the difference between every adjacent mass to charge
%values in the excel sheet
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.only_save_matrix = 1;
    handles.inc_pca = 1;
    isos_dir = uigetdir;
    disp('Getting combined list of m/z values from isos files')
    [handles.uz4_2, handles.uz2] = obtain_mz_vals_combined_from_isos_alone_new(handles.number_of_scans, handles.filename,isos_dir);
    uz2_diff = diff(handles.uz2);
    axes(handles.stats_plot1)
    plot(uz2_diff)
    set(handles.stats_table1,'Data', uz2_diff)
    guidata(hObject,handles);
    disp('Done!')
    stop_logging();
catch MExc
    show_error(MExc);
end


function threshold_peaks_Callback(hObject,~,~)
% start_end_loc_for_means :- list of 2 columns (start value and end value
% for each block).
% mz_means_list_for_each_block :- the mean values for each block, i.e., for
% each start_end_loc_for_means row
try
    handles = guidata(hObject);
    start_logging(handles);
    thresh_val = get(handles.threshold_for_peaks,'string');
    thresh_val = single(str2double(thresh_val));
    axes(handles.stats_plot1)
    [handles.start_end_loc_for_means, handles.mz_means_list_for_each_block, handles.locs] = generate_mz_means_list_for_each_block(handles.uz2, thresh_val);
    set(handles.stats_table1,'Data',handles.mz_means_list_for_each_block)
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function adjust_tolerance_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    tol_val = get(handles.threshold_for_peaks,'string');
    tol_val = single(str2double(tol_val));
    [handles.uz2,handles.mz_rows_to_remove] = generate_mz_rows_to_remove(handles.uz2,handles.locs, handles.mz_means_list_for_each_block, tol_val, handles.start_end_loc_for_means);
    set(handles.stats_table1,'Data',handles.mz_means_list_for_each_block)
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function close_stats_window_Callback(~,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    stop_logging();
catch MExc
    show_error(MExc);
end

function threshold_for_peaks_Callback(~,~,~)


function threshold_for_peaks_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function user_set_tol_val_Callback(~,~,~)


function user_set_tol_val_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tol_line_no_Callback(~,~,~)


function tol_line_no_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function reset_mz_list_Callback(~,~,~)
handles = guidata(hObject);
handles.uz2 = handles.uz4_2;
guidata(hObject,handles);

function stats_table1_CellSelectionCallback(~,~,~)


function save_excel_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    xlswrite(strcat(handles.pathname,'Images',filesep,'mz_list.xlsx'), handles.uz4_2, 'Org');
    xlswrite(strcat(handles.pathname,'Images',filesep,'mz_list.xlsx'), handles.mz_means_list_for_each_block, 'Mod');
    disp('Done Saving !')
    handles.execs{numel(handles.execs)+1} = 'save_excel_Callback(hObject,[],handles)';
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function create_matrix_from_reduced_list_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    if isempty(handles.isos_dir)
        handles.isos_dir = uigetdir;
    end
    create_new_matrix_from_isos_using_full_mz_list(handles.number_of_scans, handles.filename,handles.isos_dir)
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function register_image_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.temp_mask = [];
    handles.new_y = [];
    handles.new_x = [];
    handles.unique_x_vals = [];
    handles.unique_y_vals = [];
    if isempty(handles.draw_method)
        handles.draw_method = 2;
    end
    choice2 = questdlg('Draw ROI on Optical Image ??', ...
        'User Input', ...
        'Yes','No','Yes');
    switch choice2
        case 'Yes'
            [opt_filename, opt_pathname, ~] = uigetfile( ...
                {  '*.tif;*.png;*.gif';'*.*'}, ...
                'Pick the Optical Image');
            if exist([handles.pathname 'TFORM.mat'],'file')
                choice = questdlg('Transformation file exists. Use same file ??', ...
                    'User Input', ...
                    'Yes','No','Yes');
                switch choice
                    case 'Yes'
                        disp([choice ' Using existing values.'])
                        handles.newData1 = importdata([opt_pathname opt_filename]);
                        handles.newData1 = rgb2gray(handles.newData1);
                        sum_of_intensities2 = handles.sum_of_intensities;
                        handles.sum_of_intensities = imresize(handles.sum_of_intensities,[size(handles.newData1,1),size(handles.newData1,2)],'nearest','Dither',false);
                        xnorm = scale_image_to_fixed_limits(0, 1, handles.sum_of_intensities);
                        load([handles.pathname 'TFORM.mat'])
                        z_opt = handles.z(1:2:end,:);
                        z_soi = handles.z(2:2:end,:);
                        handles.TFORM = cp2tform(z_opt, z_soi,  'affine'); %#ok<DCPTF>
                    case 'No'
                        disp([choice ' Re-register Image.'])
                        handles.newData1 = importdata([opt_pathname opt_filename]);
                        handles.newData1 = rgb2gray(handles.newData1);
                        sum_of_intensities2 = handles.sum_of_intensities;
                        handles.sum_of_intensities = imresize(handles.sum_of_intensities,[size(handles.newData1,1),size(handles.newData1,2)],'nearest','Dither',false);
                        xnorm = scale_image_to_fixed_limits(0, 1, handles.sum_of_intensities);
                        figure(1);
                        subplot(1,2,1); imshow(handles.newData1);
                        subplot(1,2,2); imshow(xnorm);
                        [x,y] = ginput;
                        handles.z = [x,y];
                        handles.z = round(handles.z);
                        disp(handles.z)
                        z_opt = handles.z(1:2:end,:);
                        z_soi = handles.z(2:2:end,:);
                        handles.TFORM = cp2tform(z_opt, z_soi,  'affine'); %#ok<DCPTF>
                        save([handles.pathname 'TFORM.mat'],'z')
                end
            else
                handles.newData1 = importdata([opt_pathname opt_filename]);
                handles.newData1 = rgb2gray(handles.newData1);
                sum_of_intensities2 = handles.sum_of_intensities;
                handles.sum_of_intensities = imresize(handles.sum_of_intensities,[size(handles.newData1,1),size(handles.newData1,2)],'nearest','Dither',false);
                xnorm = scale_image_to_fixed_limits(0, 1, handles.sum_of_intensities);
                figure(1);
                subplot(1,2,1); imshow(handles.newData1);%,[]);
                subplot(1,2,2); imshow(xnorm); colormap(handles.colormap_3d);
                [x,y] = ginput;
                handles.z = [x,y];
                handles.z = round(handles.z);
                z_opt = handles.z(1:2:end,:);
                z_soi = handles.z(2:2:end,:);
                handles.TFORM = cp2tform(z_opt, z_soi,  'affine'); %#ok<DCPTF>
                save([handles.pathname 'TFORM.mat'],'z')
            end
            handles.B = imtransform(handles.newData1,handles.TFORM, 'XYScale',1,...
                'XData', [1 size(handles.sum_of_intensities,2)],...
                'YData', [1 size(handles.sum_of_intensities,1)]);%#ok<DIMTRNS> 
        case 'No'
            sum_of_intensities2 = handles.sum_of_intensities;
            xnorm = scale_image_to_fixed_limits(0, 1, handles.sum_of_intensities);
    end
    close(figure(1))
    %% User Input : Excel spreadsheet name etc.
    prompt = {'Enter Excel File Name:','Enter sheet name (if any):'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'Set 1','Sheet1'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    %%
    switch choice2
        case 'Yes'
            figure(1);imshow(handles.B,[]);%sum_of_intensities, gray(64)); hold on; h = imshow(B, gray(256)); set(h, 'AlphaData', 0.6)
        case 'No'
            figure(1);imagesc(xnorm);
    end
    colormap(handles.colormap_3d)
    %% If imfreehand
    if handles.draw_method == 1
        H = imfreehand;BW = createMask(H);
        %% If Rect
    elseif handles.draw_method == 2
        H = imrect;BW = createMask(H);
    end
    %%
    [m,n] = find(BW == 1);
    handles.new_x = zeros(size(n,1),1);
    handles.new_y = zeros(size(n,1),1);
    for i = 1:size(m,1)
        handles.new_x(i) = n(i);
        handles.new_y(i) = m(i);
    end
    handles.new_x = floor(handles.new_x)';
    handles.new_y = floor(handles.new_y)';
    min_x = min(handles.new_x(:));
    min_y = min(handles.new_y(:));
    width_x_max = max(handles.new_x(:));
    height_y_max = max(handles.new_y(:));
    width_val = width_x_max - min_x;
    height_val = height_y_max - min_y;
    if handles.draw_method == 2
        %% If imrect
        subplot(2,1,1); imagesc(sum_of_intensities2)
        H2 = imrect(gca, [min_x min_y width_val height_val]);
        handles.unique_y_vals = unique(handles.new_y);
        handles.unique_x_vals = unique(handles.new_x);
        ROI_pts.unique_x_vals = handles.unique_x_vals;
        ROI_pts.unique_y_vals = handles.unique_y_vals;
        ROI_pts.full_x = handles.new_x;
        ROI_pts.full_y = handles.new_y;
        save([handles.pathname 'ROI_pts.mat'],'ROI_pts');
    elseif handles.draw_method == 1
        %% If imfreehand
        handles.temp_mask = zeros(size(sum_of_intensities2,1),size(sum_of_intensities2,2));
        for kj = 1:numel(handles.new_x)
            handles.temp_mask(handles.new_y(kj),handles.new_x(kj)) = 1;
        end
        subplot(2,1,1); imagesc(sum_of_intensities2)
        handles.unique_y_vals = unique(handles.new_y);
        handles.unique_x_vals = zeros(numel(handles.unique_y_vals),2);
        for i = 1:numel(handles.unique_y_vals)
            locs = find(handles.new_y == handles.unique_y_vals(i));
            cc = handles.new_x(locs); %#ok<FNDSB>
            handles.unique_x_vals(i,1) = min(cc(:));
            handles.unique_x_vals(i,2) = max(cc(:));
        end
        ROI_pts.unique_x_vals = handles.unique_x_vals;
        ROI_pts.unique_y_vals = handles.unique_y_vals;
        ROI_pts.full_x = handles.new_x;
        ROI_pts.full_y = handles.new_y;
        save([handles.pathname 'ROI_pts.mat'],'ROI_pts');
    end
    mean_list = zeros(numel(handles.lower_limits_count),1);
    std_list = mean_list;
    for repeat_for_all_mz_vals = 1:numel(handles.lower_limits_count)
        handles.sum_of_intensities = generate_ion_images_from_single_line_scans(strcat(handles.pathname,handles.saveTempFilesToFolder,filesep,'sum_of_intensities',num2str(repeat_for_all_mz_vals+1)), handles.org_sum_of_int1, handles.org_sum_of_int2,handles.sum_of_intensities);
        handles.sum_of_intensities = apply_manipulations_to_all_ion_images(handles);
        handles.unique_x_vals2 = unique(handles.new_x);
        check_IT_times_folder(handles.pathname);
        IT_times = get_max_IT_time(handles.pathname,handles.ll);
        [IT_mask_image, IT_mask_binary_image] = create_IT_mask(IT_times, handles.pathname, handles.ll, size(handles.sum_of_intensities,1));
        if ~exist('coordinates','var')
            coordinates = [ROI_pts.full_x; ROI_pts.full_y]';
            linearInd = sub2ind([size(handles.sum_of_intensities,1),size(handles.sum_of_intensities,2)], coordinates(:,2), coordinates(:,1));
            IT_mask_image_ROI = IT_mask_image(linearInd);
            IT_mask_binary_image_ROI = IT_mask_binary_image(linearInd);
        end
        [mean_val, std_val, coordinates, linearInd, IT_mask_image_ROI, IT_mask_binary_image_ROI] = display_average_ROI_with_std(ROI_pts, IT_mask_image, IT_mask_binary_image, handles.sum_of_intensities, coordinates, linearInd, IT_mask_image_ROI, IT_mask_binary_image_ROI);
        mean_list(repeat_for_all_mz_vals) = mean_val;
        std_list(repeat_for_all_mz_vals) = std_val;
        j = [handles.new_x',handles.new_y'];
        for ii = 1:size(j,1);sum_of_intensities2(j(ii,2),j(ii,1)) = max(sum_of_intensities2(:))+1;end
        sum_of_intensities2 = remove_noise_spikes_from_image(sum_of_intensities2, 20);
        sum_of_intensities2 = scale_image_to_fixed_limits(0, 100, sum_of_intensities2);
        axes(handles.zone_specified_plot)
        imagesc(sum_of_intensities2)
        if (repeat_for_all_mz_vals == numel(handles.lower_limits_count))
            break;
        end
    end
    save_grayscale_image_as_tiff_Callback(hObject,[],handles)
    handles.new_x = [];
    handles.new_y = [];
    stop_logging();
    matrix_to_save_to_xls = [handles.lower_limits_count',handles.upper_limits_count',mean_list,std_list];
    % Save to spreadsheet
    names = {'Lower m/z','Upper m/z','Mean Intensity','Std Dev'};
    xlswrite([handles.pathname 'Images' filesep answer{1,1} '_ROI.xlsx'], names,answer{2,1}, 'A1:D1')
    xlswrite([handles.pathname 'Images' filesep answer{1,1} '_ROI.xlsx'], matrix_to_save_to_xls,answer{2,1}, ['A2:D' num2str(size(matrix_to_save_to_xls,1))])
    msgbox('Files have been saved');
    guidata(hObject,handles);
catch MExc
    show_error(MExc);
end


function ROI_method_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    handles.contents = cellstr(get(hObject,'String'));
    handles.val = handles.contents{get(hObject,'Value')};
    if strcmp(handles.val,'Freehand')
        handles.draw_method = 1;
    else
        handles.draw_method = 2;
    end
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function ROI_method_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function overlay_using_imagej_Callback(hObject,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    MIJ.close();
    helpdlg('Select the images you wish to overlay from the folder. This will open up selected images in ImageJ. From the ImageJ Menu options, select Image --> Overlay --> Add Image and then select the images and transperancy %. You can close the images when done, but do not close the ImageJ Panel (this is a bug that prevents ImageJ from opening up again in the current session).',...
        'How to');
    [handles.filenames, handles.pathnames, ~] = uigetfile( ...
        {  '*.png;*.tif;*.jpg;*.fig'}, ...
        'Pick files to overlay', ...
        'MultiSelect', 'on',...
        [handles.pathname 'Images']);
    MIJ.start();
    for i = 1:size(handles.filenames,2)
        x = imread([handles.pathname 'Images' filesep handles.filenames{1,i}]);
        MIJ.createColor(handles.filenames{1,i},x, true);
    end
    guidata(hObject,handles);
    stop_logging();
catch MExc
    show_error(MExc);
end


function save_imagej_image_Callback(~,~,~)
try
    handles = guidata(hObject);
    start_logging(handles);
    sd3 = handles.sum_of_intensities;
    MIJ.createImage('result', sd3, true);
    MIJ.run('PNG...');
    stop_logging();
catch MExc
    show_error(MExc);
end


function max_val_Callback(~,~,~)


function max_val_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function display_avg_pixels_Callback(hObject,~,~)
handles = guidata(hObject);
handles.avg_image_pixels = 1;
if handles.avg_image_pixels == 1
    try
        start_logging(handles);
        max_val = get(handles.max_val,'string');
        lim_val = single(str2double(max_val));
        x5 = average_ion_pixels_based_on_user_input(lim_val, handles.sum_of_intensities);
        which_image_window_without_set(handles.image_window_to_display_value, x5, handles.colormap_3d, handles)
        handles.sum_of_intensities2 = handles.sum_of_intensities;
        handles.sum_of_intensities = x5;
        guidata(hObject,handles);
        stop_logging();
    catch MExc
        show_error(MExc);
    end
end


function adjust_colormap_Callback(hObject,~,~)
handles = guidata(hObject);
xnorm = scale_image_to_fixed_limits(0, 100, handles.sum_of_intensities);
figure(2);
subplot(2,1,1); imagesc(xnorm); colormap(handles.colormap_3d); set_colorbar();
title('Original Ion Map')
subplot(2,1,2); imagesc(xnorm); colormap(handles.colormap_3d); adjustableColorbar(gca)
title('Colormap Adjustable Ion Map')


function edit1001_Callback(hObject,~,~)
val_w1 = str2double(get(hObject,'String'));
handles = guidata(hObject);
set(handles.edit1002, 'String', num2str(val_w1 + 1));


function edit1001_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1003_Callback(hObject,~,~)
personal_colormap_vals(hObject, 1004, 1003, 1004, 21);


function edit1003_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1005_Callback(hObject,~,~)
personal_colormap_vals(hObject, 1006, 1005, 1006, 19);


function edit1005_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1007_Callback(hObject,~,~)
personal_colormap_vals(hObject, 1008, 1007, 1008, 17);


function edit1007_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1009_Callback(hObject,~,~)
personal_colormap_vals(hObject, 1010, 1009, 1010, 15);


function edit1009_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1011_Callback(hObject,~,~)
personal_colormap_vals(hObject, 1012, 1011, 1012, 13);


function edit1011_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1013_Callback(hObject,~,~)
personal_colormap_vals(hObject, 1014, 1012, 1014, 11);


function edit1013_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1014_Callback(hObject,~,~)
personal_colormap_vals(hObject, 1015, 1014, 1015, 10);


function edit1014_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function personal_colormap_vals(hObject, v1, v3, v4, v4_range)
v5 = 98;
handles = guidata(hObject);
val_w1 = str2double(get(hObject,'String'));
set(handles.(['edit' num2str(v1)]), 'String', num2str(val_w1 + 1));
max_val = get(handles.(['edit' num2str(v1-2)]),'string');
lim_val = (str2double(max_val));
if lim_val > val_w1
    warndlg([num2str(val_w1) ' should be greater than or equal to previous number ' num2str(lim_val)],'!! Warning !!')
    for i = 1:2
        set(handles.(['edit' num2str(v3+i-1)]), 'String', num2str(lim_val+i-1));
    end
elseif val_w1 > v5
    warndlg([num2str(val_w1) ' should be less than or equal to ' num2str(v5)],'!! Warning !!')
    for i = 1:2
        set(handles.(['edit' num2str(v3+i-1)]), 'String', num2str(lim_val+i-1));
    end
elseif val_w1 == v5
    for i = v4:(v4+v4_range)
        set(handles.(['edit',num2str(i)]), 'String', num2str(0)); 
    end;
end

function color7_Callback(hObject,~,~)
handles = guidata(hObject);
handles.color7_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color7_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1016_Callback(~,~,~)


function edit1016_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color8_Callback(hObject,~,~)
handles = guidata(hObject);
handles.color8_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color8_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1018_Callback(~,~,~)


function edit1018_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color9_Callback(hObject,~,~)
handles = guidata(hObject);
handles.color9_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color9_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1020_Callback(~,~,~)


function edit1020_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color10_Callback(hObject,~,~)
handles = guidata(hObject);
handles.color10_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color10_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1022_Callback(~,~,~)


function edit1022_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color11_Callback(hObject,~,~)
handles = guidata(hObject);
handles.color11_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color11_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1024_Callback(~,~,~)


function edit1024_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function color12_Callback(hObject,~,~)
handles = guidata(hObject);
handles.color12_colormap3d_value = get(hObject, 'Value');
guidata(hObject,handles);

function color12_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1015_Callback(hObject,~,~)
handles = guidata(hObject);
val_w1 = str2double(get(hObject,'String'));
set(handles.edit1016, 'String', num2str(val_w1 + 1));
max_val = get(handles.edit1014,'string');
lim_val = (str2double(max_val));
if lim_val > val_w1
    warndlg([num2str(val_w1) ' should be greater than or equal to previous number ' num2str(lim_val)],'!! Warning !!')
    set(handles.edit1015, 'String', num2str(lim_val));
    set(handles.edit1016, 'String', num2str(lim_val + 1));
elseif val_w1 > 98
    warndlg([num2str(val_w1) ' should be less than or equal to ' num2str(98)],'!! Warning !!')
    set(handles.edit1015, 'String', num2str(lim_val));
    set(handles.edit1016, 'String', num2str(lim_val + 1));
elseif val_w1 == 98
    for i = 1016:1025; set(handles.(['edit',num2str(i)]), 'String', num2str(0)); end;
end


function edit1015_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1017_Callback(hObject,~,~)
handles = guidata(hObject);
val_w1 = str2double(get(hObject,'String'));
set(handles.edit1018, 'String', num2str(val_w1 + 1));
max_val = get(handles.edit1016,'string');
lim_val = (str2double(max_val));
if lim_val > val_w1
    warndlg([num2str(val_w1) ' should be greater than or equal to previous number ' num2str(lim_val)],'!! Warning !!')
    set(handles.edit1017, 'String', num2str(lim_val));
    set(handles.edit1018, 'String', num2str(lim_val + 1));
elseif val_w1 > 98
    warndlg([num2str(val_w1) ' should be less than or equal to ' num2str(98)],'!! Warning !!')
    set(handles.edit1017, 'String', num2str(lim_val));
    set(handles.edit1018, 'String', num2str(lim_val + 1));
elseif val_w1 == 98
    for i = 1018:1025; set(handles.(['edit',num2str(i)]), 'String', num2str(0)); end;
end


function edit1017_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1019_Callback(hObject,~,~)
handles = guidata(hObject);
val_w1 = str2double(get(hObject,'String'));
set(handles.edit1020, 'String', num2str(val_w1 + 1));
max_val = get(handles.edit1018,'string');
lim_val = (str2double(max_val));
if lim_val > val_w1
    warndlg([num2str(val_w1) ' should be greater than or equal to previous number ' num2str(lim_val)],'!! Warning !!')
    set(handles.edit1019, 'String', num2str(lim_val));
    set(handles.edit1020, 'String', num2str(lim_val + 1));
elseif val_w1 > 98
    warndlg([num2str(val_w1) ' should be less than or equal to ' num2str(98)],'!! Warning !!')
    set(handles.edit1019, 'String', num2str(lim_val));
    set(handles.edit1020, 'String', num2str(lim_val + 1));
elseif val_w1 == 98
    for i = 1020:1025; set(handles.(['edit',num2str(i)]), 'String', num2str(0)); end;
end


function edit1019_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1021_Callback(hObject,~,~)
handles = guidata(hObject);
val_w1 = str2double(get(hObject,'String'));
set(handles.edit1022, 'String', num2str(val_w1 + 1));
max_val = get(handles.edit1020,'string');
lim_val = (str2double(max_val));
if lim_val > val_w1
    warndlg([num2str(val_w1) ' should be greater than or equal to previous number ' num2str(lim_val)],'!! Warning !!')
    set(handles.edit1021, 'String', num2str(lim_val));
    set(handles.edit1022, 'String', num2str(lim_val + 1));
elseif val_w1 > 98
    warndlg([num2str(val_w1) ' should be less than or equal to ' num2str(98)],'!! Warning !!')
    set(handles.edit1021, 'String', num2str(lim_val));
    set(handles.edit1022, 'String', num2str(lim_val + 1));
elseif val_w1 == 98
    for i = 1022:1025; set(handles.(['edit',num2str(i)]), 'String', num2str(0)); end;
end


function edit1021_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1023_Callback(hObject,~,~)
handles = guidata(hObject);
val_w1 = str2double(get(hObject,'String'));
set(handles.edit1024, 'String', num2str(val_w1 + 1));
max_val = get(handles.edit1022,'string');
lim_val = (str2double(max_val));
if lim_val > val_w1
    warndlg([num2str(val_w1) ' should be greater than or equal to previous number ' num2str(lim_val)],'!! Warning !!')
    set(handles.edit1023, 'String', num2str(lim_val));
    set(handles.edit1024, 'String', num2str(lim_val + 1));
elseif val_w1 > 98
    warndlg([num2str(val_w1) ' should be less than or equal to ' num2str(98)],'!! Warning !!')
    set(handles.edit1023, 'String', num2str(lim_val));
    set(handles.edit1024, 'String', num2str(lim_val + 1));
elseif val_w1 == 98
    set(handles.edit1024, 'String', num2str(0));
    set(handles.edit1025, 'String', num2str(0));
end


function edit1023_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1025_Callback(~,~,~)


function edit1025_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = mz_list_ion_image_Callback(hObject,~,handles)
handles.next_sum_folder = get(handles.mz_list_ion_image,'Value');
handles.next_sum_folder = handles.next_sum_folder + 2;
guidata(hObject,handles);
handles = prev_sum_of_intensities_number_Callback(hObject,[],[]);


function mz_list_ion_image_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function listbox_for_mz_values_Callback(~,~,~)


function listbox_for_mz_values_CreateFcn(hObject,~,~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function load_settings_Callback(hObject,~,~)
handles = guidata(hObject);
load([handles.pathname 'Saved_Parameters.mat'])
number_of_scans = list{1,3}; %#ok<USENS>
lower_limit_mz_value = list{1,8};
upper_limit_mz_value = list{1,9};
across_val = list{1,40};
down_val = list{1,41};
apply_manipulations_to_all = list{1,42};
set(handles.start_with_line_number_editbox,'string',num2str(list{1,20}));
handles.pathname = list{1,21};
set(handles.apply_manipulations_to_all_images, 'Value',apply_manipulations_to_all);
limit_mz_value_box(num2str(lower_limit_mz_value),num2str(upper_limit_mz_value), handles)
sum_of_intensities = NaN([list{1,4},list{1,5}]);
set(handles.text_for_number_of_scans, 'string',num2str(number_of_scans));
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
guidata(hObject,handles);

function proven_Callback(hObject,~,~)
handles = guidata(hObject);
[handles.prov_filename, handles.prov_pathname] = ...
    uigetfile({'messages.txt'},'Select Proven Settings File to use - message.txt');
api = provenance_information;
api.seeProvenDebugInfo(handles);
guidata(hObject,handles);

function start_workflow_Callback(hObject,~,~)
handles = guidata(hObject);
handles = start_workflow(hObject, handles, false);
guidata(hObject,handles);

function test_workflow_Callback(hObject,~,~)
handles = guidata(hObject);
api = config_file;
check_python_version();
api2 = elasticModule;
api2.addpath(pwd);
handles = api.load_config_file_info(api, handles);
handles = test_provenance_workflow(hObject, handles, true);
handles = start_workflow(hObject, handles, true);
guidata(hObject,handles);
       
function handles = start_workflow(hObject, handles, ~)
handles.autoflow = 1;
handles.round_no = 1;
handles.axis_save = 0;
addpath(genpath(pwd))
for i=1:numel(handles.datasets_list)
    if isfield(handles, 'myobj')
        clear handles.myobj handles.execs
    end
    set(handles.software_free, 'BackgroundColor', 'red');
    [~, handles] = setProvenDummyValues(handles, i);
    set(handles.inform_user,'String',['Dataset ' num2str(i) ' of ' num2str(numel(handles.datasets_list))])
    try
        handles.pathname = [handles.datasets_list{i} filesep];
        handles.filename = handles.filenames_list{i};
        start_logging(handles);
        disp(handles.datasets_list(i))
        %% read the messages.txt file into MATLAB as a single string
        data = load_messages_txt_file(handles);
        workflow_functions = data.hasProvenance.uniqueID;
        handles.number_of_scans = str2num(handles.num_lines_list{i});
        A = dir([handles.pathname '*.RAW']);
        [~,idx] = sort([A.datenum]);
        handles.ll = {A(idx).name};
        if (~isdeployed)
            addpath(handles.pathname);
        end
        [~, ~, ext] = fileparts(handles.filename);
        if strcmp(ext,'.raw') || strcmp(ext,'.RAW')
            create_folder(handles.pathname, 'saveHDFFiles')
            create_folder(handles.pathname, 'saveCDFFiles')
        end
        api = config_file;
        keys = api.read_config_keys('Folder');
        for folderNo = 1:numel(keys); create_folder(handles.pathname, keys{folderNo,1}); end
        set(handles.textbox_for_browsed_image,'string',handles.filename);
        % Convert Xcalibur RAW file to CDF file
        RAW_filename = strcat(handles.pathname,handles.filename);
        aspect_ratio = strsplit(data.hasProvenance.aspectRatio, ', ');
        mzRange = strsplit(data.hasProvenance.mzRange, ', ');
        normalizeData = strsplit(data.hasProvenance.normalizeData, ', ');
        if isempty(str2double(normalizeData{1}))
            normalizeData{1} = 0;
        end        
        handles.RedoFileName = data.hasProvenance.redoImageExcelfileName;
        handles.RedoPathName = data.hasProvenance.redoImage;
        handles.redo_s = str2double(data.hasProvenance.redoImageExcelSheetName);
        redoanswer2_b = data.hasProvenance.redoImageExcelmzRows;
        handles.redoanswer2 = strsplit(redoanswer2_b, ', ');
        handles.redoanswer2 = handles.redoanswer2';
        handles.redoanswer = data.hasProvenance.redoImagePDFno;
        handles.redoanswer = strsplit(handles.redoanswer, ', ');
        handles.redoanswer = handles.redoanswer';        
        colormap3d_value = data.hasProvenance.colorMap;
        colormap3d_value = str2num(colormap3d_value); %#ok<*ST2NM>
        handles.contents = data.hasProvenance.imageListToSave;
        handles.contents = str2num(handles.contents);
        handles.axis_save = data.hasProvenance.includeAxisImageSave;
        handles.axis_save = str2num(handles.axis_save);   
        dpi_val = data.hasProvenance.dpiVal;
        set(handles.aspect_ratio_down_edit, 'string',aspect_ratio{1});
        set(handles.aspect_ratio_across_edit, 'string',aspect_ratio{2});
        limit_mz_value_box(mzRange{1},mzRange{2}, handles);
        set(handles.normalize_data_checkbox, 'Value',str2double(normalizeData{1}));
        if numel(normalizeData)>2
            set(handles.normalize_data_higher_limit, 'string',num2str(normalizeData{3}));
            set(handles.normalize_data_lower_limit, 'string',num2str(normalizeData{2}));
        end
        set(handles.textbox_for_browsed_image,'string',handles.filename);
        set(handles.text_for_number_of_scans, 'string',handles.number_of_scans);
        set(handles.start_with_line_number_editbox,'string',handles.start_list(i));            
        set(handles.save_axis, 'Value',handles.axis_save);
        set(handles.dpi_value,'string',dpi_val);             
        [colormap3d_value, handles] = get_colormap_3d(handles);
        set_colormap_3d(colormap3d_value, handles);
        re_execute_fcns = strsplit(workflow_functions, ', ');
        for i2 = 1:numel(re_execute_fcns); fprintf('re-doing step %s \n', re_execute_fcns{1,i2}); end;
        disp('removed globals');
        guidata(hObject,handles);
        for i2 = 1:numel(re_execute_fcns)
            fprintf('re-doing step %s \n', re_execute_fcns{1,i2});
            try
                start_logging(handles);
                eval(re_execute_fcns{1,i2});
                stop_logging();
            catch MExc
                show_error(MExc);
                break
            end
            fprintf('functions executed is %s for dataset %s\n', re_execute_fcns{1,i2}, handles.datasets_list{i,1});
        end
        handles = guidata(hObject);
        handles.plot_val = 1;
        stop_logging();
    catch MExc
        show_error(MExc);
        break
    end
    handles = reset_scale_button_Callback([], [], handles);
    clear_images(handles);
    set(hObject,'Value',1);
    set(handles.software_free, 'BackgroundColor', 'green');
end
handles.autoflow = 0;
guidata(hObject,handles);

function datasets_Callback(hObject,~,~)
handles = guidata(hObject);
handles = select_multiple_datasets([], handles, false);
set(handles.software_free, 'BackgroundColor', 'green');
guidata(hObject,handles);

function submit_prov_Callback(hObject,~,~)
handles = guidata(hObject);
api = provenance_information;
api.msiquickview_prov_save_button_clicked(handles, handles.execs, handles.myobj, handles.startMsg, handles.pathname);


function load_excel_Callback(hObject,~,~)
handles = guidata(hObject);
set(handles.software_free, 'BackgroundColor', 'red');
handles = load_excel_file_containing_dataset_list(0, handles);
set(handles.software_free, 'BackgroundColor', 'green');
guidata(hObject,handles);


function handles = delete_timeplot_UnL_lines(handles)
delete(handles.h_lower);
delete(handles.h_upper);

function handles = delete_timeplot_line(handles)
delete(handles.h_t);


function Plots_radiobutton_Callback(hObject,~,~)
button_group_display_toggle(hObject)


function Toolbar_radiobutton_Callback(hObject,~,~)
button_group_display_toggle(hObject)

function Provenance_radiobutton_Callback(hObject,~,~)
button_group_display_toggle(hObject)

function ImageProcessing_radiobutton_Callback(hObject,~,~)
button_group_display_toggle(hObject)

function button_group_display_toggle(hObject)
handles = guidata(hObject);
name = [get(get(handles.uibuttongroup1,'SelectedObject'), 'String'), 'Panel'];
children = get(handles.uibuttongroup1,'Children');
for i = 1:numel(children)
    if ~strcmp(name,[children(i).('String'),'Panel'])
        set(handles.([children(i).('String'),'Panel']),'Visible','off')
    end
end
set(handles.(name),'Visible','on')

function [across_val, down_val] = check_aspect_ratio_values(across_val, down_val)
if isnan(across_val) || isnan(down_val)
    across_val = 1;
    down_val = 1;
end

function zoom_on_off_Callback(hObject,~,~)
button_state = get(hObject,'Value');
handles = guidata(hObject);
handles.execs{numel(handles.execs)+1} = ['set(handles.zoom_on_off_Callback,''','Value''',',' num2str(button_state) ')'];
if button_state == get(hObject,'Max')
    zoom
    set(handles.zoom_on_off,'string','Zoom Off');
elseif button_state == get(hObject,'Min')
    zoom
    set(handles.zoom_on_off,'string','Zoom On');
end
guidata(hObject,handles);

    
function handles = get_lower_and_upper_grayscale_color(handles)
    handles.lower_limit_for_grayscale_color = get(handles.new_lowest_gray_value,'string');   %lower limit bar for Int-Time spect
    handles.higher_limit_for_grayscale_color = get(handles.new_highest_gray_value,'string');   %lower limit bar for Int-Time spect
    handles.lower_limit_for_grayscale_color = str2double(handles.lower_limit_for_grayscale_color);
    handles.higher_limit_for_grayscale_color = str2double(handles.higher_limit_for_grayscale_color);

function handles = get_normalize_data_limit(handles)
    handles.normalize_data_lower_lim = get(handles.normalize_data_lower_limit,'string');
    handles.normalize_data_lower_lim = single(str2double(handles.normalize_data_lower_lim));
    handles.normalize_data_higher_lim = get(handles.normalize_data_higher_limit,'string');
    handles.normalize_data_higher_lim = single(str2double(handles.normalize_data_higher_lim));
    handles.normalize_data_checkbox = get(handles.normalize_data_checkbox, 'Value');
    
function handles = set_get_val_across_interpolated_data(handles)
    handles.val_across_interpolated_data = get(handles.editbox_across_interpolated_data, 'string');
    handles.val_across_interpolated_data = str2double(handles.val_across_interpolated_data);
    handles.val_down_interpolated_data = get(handles.editbox_down_interpolated_data, 'string');
    handles.val_down_interpolated_data = str2double(handles.val_down_interpolated_data);

function start_logging(handles)
    diary([handles.saveMSIQuickViewLogs 'logs.txt'])


function stop_logging()
    diary off

function delete_logs(handles)
    if exist([handles.saveMSIQuickViewLogs 'logs.txt'],'file')
        delete([handles.saveMSIQuickViewLogs 'logs.txt'])   
    end
    if ~exist(handles.saveMSIQuickViewLogs,'dir')
        mkdir(handles.saveMSIQuickViewLogs)   
    end    
    
    
function buttonSelectMain_Callback(~, ~, handles)
tabMan = handles.tabManager;
tabMan.Handles.TabA.SelectedTab = tabMan.Handles.TabA01Main;


function buttonSelectMain2_Callback(~, ~, handles)
tabMan = handles.tabManager;
tabMan.Handles.TabA.SelectedTab = tabMan.Handles.TabA02Main;

function limit_mz_value_box(lower, upper, handles)
if ~isnan(upper);set(handles.upper_limit_mz_value_box, 'string',upper);end
if ~isnan(lower);set(handles.lower_limit_mz_value_box, 'string',lower);end

function handles = aspect_ratio(handles)
handles.across_val = get(handles.aspect_ratio_across_edit,'string');
handles.down_val = get(handles.aspect_ratio_down_edit,'string');

function [colormap3d_value, handles] = get_colormap_3d(handles)
Format = get(handles.popupmenu_for_colormap3d, 'String');
colormap3d_value = get(handles.popupmenu_for_colormap3d, 'Value');
if isempty(colormap3d_value)
    handles.colormap_3d = 'hot';
else
    handles.colormap_3d = Format(colormap3d_value);
    handles.colormap_3d = char(handles.colormap_3d(1,1));
end

function set_colormap_3d(value, handles)
set(handles.popupmenu_for_colormap3d, 'Value', value); 

function handles = remove_lines_edit_box(handles)
handles.lines_to_remove_from_image = get(handles.remove_lines_edit_box, 'string');
handles.lines_to_remove_from_image = str2num(lines_to_remove_from_image);

function [dpi, mag] = get_dpi_and_mag(handles)
dpi = get(handles.dpi_value,'string');
dpi = single(str2double(dpi));
mag = dpi / get(0, 'ScreenPixelsPerInch');

function handle_display_image_window(handles, cla)
if handles.image_window_to_display_value == 1
    if cla; cla(handles.zone_specified_plot); end
    axes(handles.zone_specified_plot);
else
    if cla; cla(handles.zone_specified_plot2); end
    axes(handles.zone_specified_plot2);
end