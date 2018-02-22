function varargout = MSI_QuickView_Scrolling_GUI(varargin)
% MSI_QUICKVIEW_SCROLLING_GUI MATLAB code for MSI_QuickView_Scrolling_GUI.fig
%      MSI_QUICKVIEW_SCROLLING_GUI, by itself, creates a new MSI_QUICKVIEW_SCROLLING_GUI or raises the existing
%      singleton*.
%
%      H = MSI_QUICKVIEW_SCROLLING_GUI returns the handle to a new MSI_QUICKVIEW_SCROLLING_GUI or the handle to
%      the existing singleton*.
%
%      MSI_QUICKVIEW_SCROLLING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSI_QUICKVIEW_SCROLLING_GUI.M with the given input arguments.
%
%      MSI_QUICKVIEW_SCROLLING_GUI('Property','Value',...) creates a new MSI_QUICKVIEW_SCROLLING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MSI_QuickView_Scrolling_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MSI_QuickView_Scrolling_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MSI_QuickView_Scrolling_GUI

% Last Modified by GUIDE v2.5 21-Jun-2016 10:19:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MSI_QuickView_Scrolling_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MSI_QuickView_Scrolling_GUI_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before MSI_QuickView_Scrolling_GUI is made visible.
function MSI_QuickView_Scrolling_GUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MSI_QuickView_Scrolling_GUI (see VARARGIN)
% global pathname
% Choose default command line output for MSI_QuickView_Scrolling_GUI
global mat_file_name
handles.output = hObject;
% Update handles structure
addpath(pwd);
set(handles.output,'Name',['Scrolling_GUI']);%['MSI QuickView Scrolling GUI  v' '0.001']);
guidata(hObject, handles);
if ~isempty(mat_file_name)
   select_matrix_or_mat_file_Callback(hObject, [], handles) 
end
% if ~isempty(pathname)
%     select_matrix_or_mat_file_Callback(hObject, eventdata, handles) 
%     listbox1_Callback(hObject, eventdata, handles)
% else
%     select_matrix_or_mat_file_Callback(hObject, eventdata, handles)
% end
% UIWAIT makes MSI_QuickView_Scrolling_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MSI_QuickView_Scrolling_GUI_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
maxfig(gcf,1)

% --- Executes on button press in select_matrix_or_mat_file.
function select_matrix_or_mat_file_Callback(hObject, eventdata, handles)
% hObject    handle to select_matrix_or_mat_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_dir r2 C filename pathname colormap_3d matr reduce_matrix_size pathname2 mat_file_name
global count_2 number_of_scans O_was_present lower_limit_mz_value upper_limit_mz_value normalize_data_lower_limit normalize_data_higher_limit single_range_value double_range_value check_point_count image_window_to_display_value next_sum_folder size_count_limits upper_limits_count lower_limits_count normalize_data_mode apply_manipulations_to_all val1_lower_lim sum_of_intensities org_sum_of_int1 org_sum_of_int2
try
current_dir = pwd;
if isempty(pathname2)
[filename, pathname, filterindex] = uigetfile( ...
{  '*.txt;*.mat';'*.*'}, ...
   'Pick a file');
goUpDirectory = findstr(pathname, filesep);
pathname = pathname(1:goUpDirectory(end-1));
else
%    filename = 'myBigData2.mat';
%    pathname(end+1) = filesep;
if isempty(mat_file_name)
[filename, pathname, filterindex] = uigetfile( ...
{  '*.txt;*.mat';'*.*'}, ...
   'Pick a file',...
   pathname2);
else
filename = 'myBigData2.mat';    
pathname = pathname2;
pathname(end+1) = filesep;
end
end
delete_log();
start_logging();
if exist([pathname 'Saved_Parameters.mat'],'file')
load([pathname 'Saved_Parameters' '.mat'])
filename = list{1,1};
count_2 = list{1,2};
number_of_scans = list{1,3};
colormap_3d = list{1,6};
O_was_present = list{1,7};
lower_limit_mz_value = list{1,8};
upper_limit_mz_value = list{1,9};
single_range_value = list{1,10};
double_range_value = list{1,11};
check_point_count = list{1,12};
image_window_to_display_value = list{1,13};
next_sum_folder = list{1,14};
size_count_limits = list{1,15};
upper_limits_count = list{1,16};
lower_limits_count = list{1,17};
normalize_data_mode = list{1,18};
normalize_data_lower_limit = list{1,46};
normalize_data_higher_limit = list{1,47};
across_val = list{1,40};
down_val = list{1,41};
apply_manipulations_to_all = list{1,42};
user_input_for_mode_manual = list{1,43};
user_input_for_mode_auto = list{1,44};
val1_lower_lim = list{1,22};
val1_upper_lim = list{1,23};
val2_lower_lim = list{1,24};
val2_upper_lim = list{1,25};
val3_lower_lim = list{1,26};
val3_upper_lim = list{1,27};
val4_lower_lim = list{1,28};
val4_upper_lim = list{1,29};
val5_lower_lim = list{1,30};
val5_upper_lim = list{1,31};
val6_lower_lim = list{1,32};
val6_upper_lim = list{1,33};
val7_lower_lim = list{1,34};
val7_upper_lim = list{1,35};
val8_lower_lim = list{1,36};
val8_upper_lim = list{1,37};
n19 = list{1,19};      
pathname = list{1,21};
sum_of_intensities = NaN([list{1,4},list{1,5}]);
org_sum_of_int1 = list{1,53};
org_sum_of_int2 = list{1,54};
set(handles.aspect_ratio_across_edit, 'string',num2str(across_val));
set(handles.aspect_ratio_down_edit, 'string',num2str(down_val));
set(handles.normalize_data_checkbox, 'Value',list{1,45});
set(handles.normalize_data_lower_limit, 'string',num2str(list{1,46}));
set(handles.normalize_data_higher_limit, 'string',num2str(list{1,47}));
set(handles.apply_manipulations_to_all_images, 'Value',apply_manipulations_to_all);
set(handles.editbox_across_interpolated_data, 'string',num2str(list{1,49}));
set(handles.editbox_down_interpolated_data, 'string',num2str(list{1,50}));
set(handles.new_lowest_gray_value, 'string',num2str(list{1,52}));
set(handles.new_highest_gray_value, 'string',num2str(list{1,51}));
set(handles.remove_lines_edit_box, 'string',num2str(list{1,48}));
end
% cd(pathname)
if (~isdeployed)
addpath('C:\vis_xcalibur_raw_files');
end
if isempty(colormap_3d)
   colormap_3d = 'hot'; 
end
yy = find(pathname == filesep);
% pathname(yy(end-1):(end-1));
% disp(yy)
% disp(pathname)
% disp('5')
set(handles.directory_name,'String',pathname((yy(end-1)+1):(end-1)))
[pathstr, name, ext] = fileparts(filename);
if strcmp(ext,'.txt') || strcmp(ext,'.TXT')
    h = waitbar(0.25,'Please wait...');
    fid = fopen([pathname filename],'rt');
    C = textscan(fid,'%f%*[^\n]','Delimiter','\t');%,'bufsize',500000);
    C = C{1,1};
    C(1) = [];
%     disp(size(C))
    if exist([pathname,'myBigData2.mat'],'file')
        delete([pathname,'myBigData2.mat'])
        delete([pathname,'mz_vals.mat'])
        delete([pathname,'temp3.mat'])
    end
    save([pathname 'mz_vals.mat'],'C')
    if exist([pathname,'CDF_Files'],'dir')
    r2 = compare_point_count_for_all_lines_in_dataset([pathname,'CDF_Files']);
    else
    mkdir([pathname,'CDF_Files'])    
    convert_raw_files(pathname,[pathname,'CDF_Files'])  
    r2 = compare_point_count_for_all_lines_in_dataset([pathname,'CDF_Files']);
    end
%     cd(pathname)
    save([pathname 'point_count.mat'],'r2')
    % addpath('C:\vis_xcalibur_raw_files')
    pdf_count = 1;
    start_val(1) = 1;
    % for i = 1:92
    %     mkdir(['C:\Users\thom991\Desktop\MSMS92\Images\' 'Set' num2str(i)])
    close(h)
    reduce_matrix_size = get(handles.reduce_matrix_size,'string');
    reduce_matrix_size = single(str2double(reduce_matrix_size));    
    for overnight_run = 1:5000:size(C,1)
    fprintf('Run no is %d of %d \n',overnight_run, size(C,1)) 
    clear A A2 count fnout j loops myData range1 range2 s s1 sec sector1 set_size subplot_count sum_of_intensities x    
    range1 = overnight_run;
    range2 = overnight_run+5000-1;
    [A2] = txt2mat([pathname filename], 'NumHeaderLines', 1, 'NumColumns', (sum(r2(:))+1), 'RowRange',[range1,range2]);
    A2(:,1) = [];
    matObj = matfile([pathname 'myBigData2.mat'],'Writable',true);
    matObj.X(range1:(range1+size(A2,1)-1),1:size(A2,2)) = A2; 
    if ~isempty(reduce_matrix_size)
    temp2 = (sum(A2~=0,2) > reduce_matrix_size);    
    matObj = matfile([pathname 'temp3.mat'],'Writable',true);
    matObj.temp2(range1:(range1+size(A2,1)-1),1) = temp2;
    end
    end
    reduce_matrix_size = get(handles.reduce_matrix_size,'string');
    reduce_matrix_size = single(str2double(reduce_matrix_size));
    if ~isnan(reduce_matrix_size)
    load([pathname 'temp3.mat'])
    matObj = matfile([pathname 'myBigData2.mat']);
    [nrows, ncols] = size(matObj, 'X');
    matr = matObj.X(1:nrows, 1:ncols);  
    load([pathname 'mz_vals.mat'])
    delete([pathname,'mz_vals.mat'])
    count = 1;
%     disp('Reached')
    temp5 = temp2;
%     disp(temp5(1:10))
    for overnight_run = 1:size(C,1)
%         disp(temp5(1:10))
        if temp5(overnight_run) == 1
%             disp(overnight_run)
        loadedData = matr(overnight_run,:);  
        mz = C(overnight_run);
        matObj2 = matfile([pathname 'myBigData2_reduced.mat'],'Writable',true);
        matObj2.X(count,1:ncols) = loadedData;
        matObj3 = matfile([pathname 'mz_vals.mat'],'Writable',true);
        matObj3.C(count,1) = mz;           
        count = count + 1;
        end
    end
    load([pathname 'mz_vals.mat'])
    delete([pathname,'myBigData2.mat'])
    movefile([pathname 'myBigData2_reduced.mat'], [pathname 'myBigData2.mat']);
    end
else
    h = waitbar(0.25,'Please wait...');
    %load([pathname 'mz_list' filesep 'mz_vals_p1.mat'])
    load([pathname 'start_end_mz_list.mat'])
    load([pathname 'point_count.mat'])
    C = load_scrolling_UI(handles, 1, pathname);
    close(h)
end
% x = num2str(C);
% for i = 1:size(x,1)
%     C2{i,1} = x(i,1:end);
% end
% set(handles.listbox1,'string',C2);
set(handles.mz_ranges_list,'string',start_end_mz_list);
if normalize_data_mode == 1
normalize_data_checkbox_Callback(hObject, eventdata, handles)    
end
cd(current_dir)
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end


% --- Executes on button press in clear_all.
function clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop_logging();
current_dir = pwd;
closeGUI = handles.figure1; %handles.figure1 is the GUI figure

guiName = get(handles.figure1,'Name'); %get the name of the GUI
close(closeGUI); %close the old GUI
guiName = 'MSI_QuickView_Scrolling_GUI';
eval(guiName) %call the GUI again
maxfig(gcf,1)
clear all; 
clc;
evalin('base','clear all');


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global pathname C do_not_save_memory matr r2 colormap_3d normalize_data_mode contents4 sum_of_intensities apply_manipulations_to_all contents2 sum_of_intensities_normalize total_intensity normalize_data_lower_lim
try
    start_logging();
%     disp('success')
%contents = cellstr(get(hObject,'String'));
contents4 = (get(hObject,'Value'));
%contents2 = contents{get(hObject,'Value')};
contents2 = C(contents4);
% contents3 = str2num(contents2);
% content3 = find(C == contents2);
user_specified_row = contents4;
if do_not_save_memory == 1
    if isempty(matr)
        h = waitbar(0.25,'Please wait...');
matObj = matfile([pathname 'myBigData2' filesep 'myBigData2_p' num2str(get(handles.mz_ranges_list, 'value')) '.mat']);
[nrows, ncols] = size(matObj, 'X');
matr = matObj.X(1:nrows, 1:ncols);   
loadedData = matr(user_specified_row,:);    
close(h)
    else
% h = waitbar(0.25,'Please wait...');
loadedData = matr(user_specified_row,:);
% close(h)
    end
else
matObj = matfile([pathname 'myBigData2' filesep 'myBigData2_p' num2str(get(handles.mz_ranges_list, 'value')) '.mat']);
[nrows, ncols] = size(matObj, 'X');
loadedData = matObj.X(user_specified_row, 1:ncols);
end
if apply_manipulations_to_all == 1
    if normalize_data_mode == 1
    if isempty(normalize_data_lower_lim)
    sum_of_intensities_temp3 = loadedData./total_intensity;%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));    
    elseif ~isempty(normalize_data_lower_lim)
%     disp(size(sum_of_intensities_temp3));disp(size(sum_of_intensities_normalize));
    sum_of_intensities_temp3 = loadedData./sum_of_intensities_normalize;    
%     sum_of_intensities_temp3(isnan(sum_of_intensities_temp3)) = 0;
    sum_of_intensities_temp3(isinf(sum_of_intensities_temp3)) = 0;
    end 
    loadedData = sum_of_intensities_temp3;
    end
end
for i = 1:size(r2,2)
   if i == 1
      sum_of_intensities = zeros(size(r2,2),max(r2(:))); 
      sum_of_intensities(i,1:r2(i)) = loadedData(1,1:sum(r2(1:i))); 
   else
      sum_of_intensities(i,1:r2(i)) = loadedData(1,(sum(r2(1:i-1))+1):sum(r2(1:i))); 
   end
end
if apply_manipulations_to_all == 1
try
   align_sum_of_intensities_Callback(hObject, eventdata, handles)
catch 
%    disp('Not Aligned') 
end    
try
   remove_lines_from_grayscale_image_Callback(hObject, eventdata, handles)
catch 
%    disp('No lines removed') 
end 
try
   show_interpolated_sum_of_intensities_Callback(hObject, eventdata, handles)
catch 
%    disp('Smoothing Values not set') 
end 
try
   display_grayscale_image_with_new_limits_Callback(hObject, eventdata, handles)
catch 
%    disp('Scaling limits not set') 
end 
else
    LESA = 1;
if LESA
    set(handles.software_free, 'BackgroundColor', 'red')
    reset_scale_button_Callback(hObject, eventdata, handles)
    sum_of_intensities = interp_LESA_images( sum_of_intensities, nrows, ncols, handles );
    set(handles.software_free, 'BackgroundColor', 'green')
else
    axes(handles.axes1)
    imagesc(sum_of_intensities); %pause(0.005);
    colormap(colormap_3d)
end
end
set(handles.text1,'String',contents2)
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aspect_ratio_across_edit_Callback(hObject, eventdata, handles)
% hObject    handle to aspect_ratio_across_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aspect_ratio_across_edit as text
%        str2double(get(hObject,'String')) returns contents of aspect_ratio_across_edit as a double


% --- Executes during object creation, after setting all properties.
function aspect_ratio_across_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aspect_ratio_across_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aspect_ratio_down_edit_Callback(hObject, eventdata, handles)
% hObject    handle to aspect_ratio_down_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aspect_ratio_down_edit as text
%        str2double(get(hObject,'String')) returns contents of aspect_ratio_down_edit as a double


% --- Executes during object creation, after setting all properties.
function aspect_ratio_down_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aspect_ratio_down_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enter_scaling_values.
function enter_scaling_values_Callback(hObject, eventdata, handles)
% hObject    handle to enter_scaling_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname sum_of_intensities temp1 across_val down_val width temp2 changed_aspect_ratio temp5 plot_val colormap_3d
try
    start_logging();
if ~isempty(temp2)
    reset_scale_button_Callback(hObject, eventdata, handles)
end
plot_val = 1;
cla(handles.axes1);
axes(handles.axes1);
colormap(colormap_3d);
% axis square
across_val = get(handles.aspect_ratio_across_edit,'string');
down_val = get(handles.aspect_ratio_down_edit,'string');
temp1 = get(gca,'Position');
temp2 = temp1;
if isempty(temp5)
    temp5 = temp1;
end
down_val = str2num(down_val);
across_val = str2num(across_val);
if down_val > across_val
width = (temp2(3)*(across_val/down_val));%((temp1(3)/down_val)*across_val);
set(gca,'Position',[temp1(1) temp1(2) width temp1(4)]) % change axis position
else
height = (temp2(4)*(down_val/across_val));%((temp1(3)/down_val)*across_val);
set(gca,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
end
% if width > temp1(4)
%     temp1(3) = temp1(3)/2;
%     width = ((temp1(3)/down_val)*across_val);
% end
imagesc(sum_of_intensities); colormap(colormap_3d);%h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
changed_aspect_ratio = 1;
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end

% --- Executes on button press in reset_scale_button.
function reset_scale_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_scale_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname temp5 plot_val changed_aspect_ratio
try
    start_logging();
if plot_val == 1
axes(handles.axes1);
set(gca,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)]) % change axis position
end
changed_aspect_ratio = 0;
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end

% --- Executes on button press in normalize_data_checkbox.
function normalize_data_checkbox_Callback(hObject, eventdata, handles)
global normalize_data_mode contents2 C w pathname sum_of_intensities_normalize total_intensity normalize_data_lower_lim %mean_row
try
    start_logging();
normalize_data_mode = (get(hObject, 'Value'));
normalize_data_lower_lim = get(handles.normalize_data_lower_limit,'string');
normalize_data_lower_lim = single(str2num(normalize_data_lower_lim));
normalize_data_higher_lim = get(handles.normalize_data_higher_limit,'string');
normalize_data_higher_lim = single(str2num(normalize_data_higher_lim));
if normalize_data_mode == 1
if ~isempty(normalize_data_lower_lim) && ~isempty(normalize_data_higher_lim)
w = find(C >= normalize_data_lower_lim & C <= normalize_data_higher_lim);
w_first = w(1);
w_last = w(end);
matObj = matfile([pathname 'myBigData2.mat']);
[nrows, ncols] = size(matObj, 'X');
% mean_row = [];
% for i = w_first:w_last
loadedData = matObj.X(w_first:w_last, 1:ncols);   
% if i == w_first
% mean_row = loadedData;
% else
% mean_row2 = [loadedData;mean_row];
% mean_row = mean(mean_row2,1);
% end
% end
% % sum_of_intensities_normalize = mean_row;
sum_of_intensities_normalize = mean(loadedData,1);
else
    if ~exist([pathname 'total_intensity.mat'],'file')
    count = 1;
    for i = 1:500:size(C,1)
        matObj = matfile([pathname 'myBigData2.mat']);
        [nrows, ncols] = size(matObj, 'X');
        if (i+500-1) < size(C,1)
        loadedData = matObj.X(i:(i+500-1), 1:ncols); 
        else
        loadedData = matObj.X(i:(i+(size(C,1)-i)), 1:ncols);     
        end
        sum_of_intensities_temp(count,:) = mean(loadedData,1);
        count = count + 1;
    end
    total_intensity = mean(sum_of_intensities_temp,1);
    save([pathname 'total_intensity.mat'],'total_intensity');
    elseif exist([pathname 'total_intensity.mat'],'file') && isempty(total_intensity)
        load([pathname 'total_intensity.mat'])
    end
end
end
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end

function normalize_data_lower_limit_Callback(hObject, eventdata, handles)
% hObject    handle to normalize_data_lower_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of normalize_data_lower_limit as text
%        str2double(get(hObject,'String')) returns contents of normalize_data_lower_limit as a double


% --- Executes during object creation, after setting all properties.
function normalize_data_lower_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalize_data_lower_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function normalize_data_higher_limit_Callback(hObject, eventdata, handles)
% hObject    handle to normalize_data_higher_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of normalize_data_higher_limit as text
%        str2double(get(hObject,'String')) returns contents of normalize_data_higher_limit as a double


% --- Executes during object creation, after setting all properties.
function normalize_data_higher_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalize_data_higher_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply_manipulations_to_all_images.
function apply_manipulations_to_all_images_Callback(hObject, eventdata, handles)
global apply_manipulations_to_all
apply_manipulations_to_all = (get(hObject, 'Value'));


% --- Executes on button press in align_sum_of_intensities.
function align_sum_of_intensities_Callback(hObject, eventdata, handles)
global sum_of_intensities pathname sum_of_intensities2 info raw_filename colormap_3d
try
    start_logging();
current_dir = pwd;
if ~isempty(raw_filename)
    filename2 = raw_filename;
elseif exist([pathname 'file_info.mat'],'file')
    load([pathname 'file_info.mat'])
else
    [filename2, pathname2, filterindex2] = uigetfile( ...
    {  '*.raw;*.RAW';'*.*'}, ...
       'Pick first RAW file');
    prompt = {'Please Enter Number of RAW files'};
    dlg_title = 'Required Inputs';
    num_lines = 1;
    zip_name = inputdlg(prompt,dlg_title,num_lines);
    zip_name = zip_name{1,1};
    number_of_scans = str2num(zip_name);
    raw_filename = filename2;
    info.raw_filename = raw_filename;
    info.number_of_scans = number_of_scans;
    info.pathname = pathname2;
    save([pathname 'file_info.mat'], 'info')
end
number_of_scans = info.number_of_scans;
filename2 = info.raw_filename;
sum_of_intensities2 = interpolation_code(sum_of_intensities, number_of_scans, filename2, handles);
% cla(handles.axes1);
axes(handles.axes1);
new_min = 0;    %min of 0 to 255
new_max = 100;  %max of 0 to 255
old_min = min(min(sum_of_intensities2(:)));
old_max = max(max(sum_of_intensities2(:)));    
% count_3 = 1;
for count_3 = 1:size(sum_of_intensities2,1)
for j2 = 1:size(sum_of_intensities2,2)
    value = sum_of_intensities2(count_3, j2);
    sum_of_intensities2(count_3, j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
end
end
imagesc(sum_of_intensities2);
colormap(colormap_3d);
sum_of_intensities = sum_of_intensities2;
h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
cd(current_dir)
stop_logging();
catch
%     disp(MExc)
% disp(getReport(MExc, 'extended'))
    %msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end



function new_lowest_gray_value_Callback(hObject, eventdata, handles)
% hObject    handle to new_lowest_gray_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of new_lowest_gray_value as text
%        str2double(get(hObject,'String')) returns contents of new_lowest_gray_value as a double


% --- Executes during object creation, after setting all properties.
function new_lowest_gray_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to new_lowest_gray_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function new_highest_gray_value_Callback(hObject, eventdata, handles)
% hObject    handle to new_highest_gray_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of new_highest_gray_value as text
%        str2double(get(hObject,'String')) returns contents of new_highest_gray_value as a double


% --- Executes during object creation, after setting all properties.
function new_highest_gray_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to new_highest_gray_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in display_grayscale_image_with_new_limits.
function display_grayscale_image_with_new_limits_Callback(hObject, eventdata, handles)
global pathname sum_of_intensities colormap_3d lower_limit_for_grayscale_color higher_limit_for_grayscale_color sum_of_intensities2
try
    start_logging();
lower_limit_for_grayscale_color = get(handles.new_lowest_gray_value,'string');   %lower limit bar for Int-Time spect
higher_limit_for_grayscale_color = get(handles.new_highest_gray_value,'string');   %lower limit bar for Int-Time spect
lower_limit_for_grayscale_color = str2num(lower_limit_for_grayscale_color);
higher_limit_for_grayscale_color = str2num(higher_limit_for_grayscale_color);
                    new_min = 0;    %min of 0 to 255
                    new_max = 100;  %max of 0 to 255
                    old_min = min(sum_of_intensities(:));
                    old_max = max(sum_of_intensities(:));
                    for i = 1:size(sum_of_intensities,1)
                        for j2 = 1:size(sum_of_intensities,2)
                        value = sum_of_intensities(i, j2);
                        xnorm(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
                        end
                    end
xnorm(xnorm < lower_limit_for_grayscale_color) = lower_limit_for_grayscale_color;% - 5;
xnorm(xnorm > higher_limit_for_grayscale_color) = higher_limit_for_grayscale_color;% + 5;
cla(handles.axes1);
axes(handles.axes1);
imagesc(xnorm);
xlabel('Scan'); ylabel('Line');
colormap(colormap_3d); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
sum_of_intensities = xnorm;
sum_of_intensities2 = sum_of_intensities;
stop_logging();
catch %MExc
%     disp(MExc)
% disp(getReport(MExc, 'extended'))
%     msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end


% --- Executes on button press in remove_lines_from_grayscale_image.
function remove_lines_from_grayscale_image_Callback(hObject, eventdata, handles)
global pathname sum_of_intensities6 colormap_3d sum_of_intensities
try
    start_logging();
% global lines_to_remove_from_image original_number_of_lines unique_elements_after_removing_lines
lines_to_remove_from_image = get(handles.remove_lines_edit_box, 'string');
lines_to_remove_from_image = str2num(lines_to_remove_from_image);
sum_of_intensities6 = sum_of_intensities;
current_folder = pwd;
if isempty(colormap_3d)
   colormap_3d = 'hot'; 
end
if ~exist(saveTempFilesToFolder,'dir')
   mkdir(saveTempFilesToFolder)
end
cd(saveTempFilesToFolder)
save('org_sum_of_intensities','sum_of_intensities');
cd(current_folder);
original_number_of_lines = 1:size(sum_of_intensities,1);
unique_elements_after_removing_lines = setdiff(original_number_of_lines, lines_to_remove_from_image);
                    new_min = 0;    %min of 0 to 255
                    new_max = 100;  %max of 0 to 255
                    for i = 1:size(unique_elements_after_removing_lines,2)
                        sum_of_intensities(i,:) = sum_of_intensities(unique_elements_after_removing_lines(i),:);
                    
                    end                    
                    old_min = min(sum_of_intensities(:));
                    old_max = max(sum_of_intensities(:));
                    for i = 1:size(sum_of_intensities,1)
                        for j2 = 1:size(sum_of_intensities,2)
                        value = sum_of_intensities(i, j2);
                        sum_of_intensities(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
                        end
                    end
                    sum_of_intensities(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
cla(handles.axes1);
axes(handles.axes1);
imagesc(sum_of_intensities);%(sum_of_intensities);
xlabel('Scan'); ylabel('Line');
colormap(colormap_3d); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end


function remove_lines_edit_box_Callback(hObject, eventdata, handles)
% hObject    handle to remove_lines_edit_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of remove_lines_edit_box as text
%        str2double(get(hObject,'String')) returns contents of remove_lines_edit_box as a double


% --- Executes during object creation, after setting all properties.
function remove_lines_edit_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_lines_edit_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editbox_across_interpolated_data_Callback(hObject, eventdata, handles)
% hObject    handle to editbox_across_interpolated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbox_across_interpolated_data as text
%        str2double(get(hObject,'String')) returns contents of editbox_across_interpolated_data as a double


% --- Executes during object creation, after setting all properties.
function editbox_across_interpolated_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbox_across_interpolated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editbox_down_interpolated_data_Callback(hObject, eventdata, handles)
% hObject    handle to editbox_down_interpolated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbox_down_interpolated_data as text
%        str2double(get(hObject,'String')) returns contents of editbox_down_interpolated_data as a double


% --- Executes during object creation, after setting all properties.
function editbox_down_interpolated_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbox_down_interpolated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_interpolated_sum_of_intensities.
function show_interpolated_sum_of_intensities_Callback(hObject, eventdata, handles)
global pathname sum_of_intensities colormap_3d apply_manipulations_to_all val_across_interpolated_data val_down_interpolated_data lower_limit_for_grayscale_color higher_limit_for_grayscale_color
try
    start_logging();
if apply_manipulations_to_all == 1
val_across_interpolated_data = get(handles.editbox_across_interpolated_data, 'string');
val_across_interpolated_data = str2num(val_across_interpolated_data);
val_down_interpolated_data = get(handles.editbox_down_interpolated_data, 'string');
val_down_interpolated_data = str2num(val_down_interpolated_data);
% sum_of_intensities_original2 = sum_of_intensities;
sum_of_intensities = imresize(sum_of_intensities(:,:),[size(sum_of_intensities,1)*val_down_interpolated_data,size(sum_of_intensities,2)*val_across_interpolated_data],'bilinear');
cla(handles.axes1);
axes(handles.axes1);
                        new_min = 0;    %min of 0 to 255
                    new_max = 100;  %max of 0 to 255
                    old_min = min(sum_of_intensities(:));
                    old_max = max(sum_of_intensities(:));
                    for i = 1:size(sum_of_intensities,1)
                        for j2 = 1:size(sum_of_intensities,2)
                        value = sum_of_intensities(i, j2);
                        sum_of_intensities(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
                        end
                    end
if ~isempty(lower_limit_for_grayscale_color)
imagesc(sum_of_intensities,[lower_limit_for_grayscale_color, higher_limit_for_grayscale_color]); %[lower_limit_for_grayscale_color-5, higher_limit_for_grayscale_color+5]);
else
imagesc(sum_of_intensities);
end
xlabel('Scan'); ylabel('Line');
colormap(colormap_3d); 
h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
else
button = questdlg('Proceed ??',...
    'Warning',...
    'OK','Cancel','OK');
switch button
    case 'OK'
val_across_interpolated_data = get(handles.editbox_across_interpolated_data, 'string');
val_across_interpolated_data = str2num(val_across_interpolated_data);
val_down_interpolated_data = get(handles.editbox_down_interpolated_data, 'string');
val_down_interpolated_data = str2num(val_down_interpolated_data);
% sum_of_intensities_original2 = sum_of_intensities;
sum_of_intensities = imresize(sum_of_intensities(:,:),[size(sum_of_intensities,1)*val_down_interpolated_data,size(sum_of_intensities,2)*val_across_interpolated_data],'bilinear');
cla(handles.axes1);
axes(handles.axes1);
                        new_min = 0;    %min of 0 to 255
                    new_max = 100;  %max of 0 to 255
                    old_min = min(sum_of_intensities(:));
                    old_max = max(sum_of_intensities(:));
                    for i = 1:size(sum_of_intensities,1)
                        for j2 = 1:size(sum_of_intensities,2)
                        value = sum_of_intensities(i, j2);
                        sum_of_intensities(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
                        end
                    end
if ~isempty(lower_limit_for_grayscale_color)
imagesc(sum_of_intensities,[lower_limit_for_grayscale_color, higher_limit_for_grayscale_color]); %[lower_limit_for_grayscale_color-5, higher_limit_for_grayscale_color+5]);
else
imagesc(sum_of_intensities);
end
xlabel('Scan'); ylabel('Line');
colormap(colormap_3d); 
h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
    case 'Cancel'
end    
end
stop_logging();
catch MExc
%     disp(MExc)
    disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in do_not_save_memory.
function do_not_save_memory_Callback(hObject, eventdata, handles)
% hObject    handle to do_not_save_memory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_not_save_memory
global pathname do_not_save_memory
try
    start_logging();
do_not_save_memory = (get(hObject, 'Value'));
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end

% --- Executes on selection change in popupmenu_for_colormap3d.
function popupmenu_for_colormap3d_Callback(hObject, eventdata, handles)
global pathname colormap_3d 
try
    start_logging();
Format = get(hObject, 'String');
colormap3d_value = get(hObject, 'Value');
colormap_3d = Format(colormap3d_value);
colormap_3d = char(colormap_3d(1,1));
axes(handles.axes1);
colormap(colormap_3d);
stop_logging();
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end


% --- Executes during object creation, after setting all properties.
function popupmenu_for_colormap3d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_for_colormap3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function reduce_matrix_size_Callback(hObject, eventdata, handles)
% hObject    handle to reduce_matrix_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reduce_matrix_size as text
%        str2double(get(hObject,'String')) returns contents of reduce_matrix_size as a double


% --- Executes during object creation, after setting all properties.
function reduce_matrix_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reduce_matrix_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_grayscale_image_as_tiff.
function save_grayscale_image_as_tiff_Callback(hObject, eventdata, handles)
global name colormap_3d contents2 pathname 
global across_val down_val sum_of_intensities radius_val temp6 axis_save 
try
set(handles.software_free, 'BackgroundColor', 'red')
    start_logging();
name = ['mz_' num2str(contents2) '.tif'];
if ~isempty(temp6)
    reset_scale_button_Callback(hObject, eventdata, handles)
end
axes(handles.axes1);
% if changed_aspect_ratio == 1 
across_val = get(handles.aspect_ratio_across_edit,'string');
down_val = get(handles.aspect_ratio_down_edit,'string');
temp3 = get(gca,'Position');
temp4 = temp3;
if isempty(temp6)
    temp6 = temp3;
end
down_val = str2num(down_val);
across_val = str2num(across_val);
if down_val > across_val
width = (temp4(3)*(across_val/down_val));%((temp1(3)/down_val)*across_val);
set(gca,'Position',[temp3(1) temp3(2) width temp3(4)]) % change axis position
elseif across_val > down_val  
height = (temp4(4)*(down_val/across_val));%((temp1(3)/down_val)*across_val);
set(gca,'Position',[temp3(1) temp3(2) temp3(3) height]) % change axis position
end
if isempty(radius_val)
    radius_val = 0.1;
end
if radius_val == 0
    radius_val = 0.1;
end
h2 = figure(55);
imagesc(sum_of_intensities);colormap(colormap_3d) %(imfilter(sum_of_intensities(1:size(sum_of_intensities,1), 1:size(sum_of_intensities,2)), PSF,'replicate'));%, 'corr', 'symmetric'));
colormap(colormap_3d);
h2.Position = [100 100 across_val*100 down_val*100];
if axis_save == 1    
    xlabel('Scan'); ylabel('Line'); colormap(colormap_3d); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
else
    axis off
    colorbar('off')
end
dpi = get(handles.dpi_value,'string');
dpi = single(str2num(dpi)); 
mag = dpi / get(0, 'ScreenPixelsPerInch');
if ~exist([pathname 'Images'],'dir')
   mkdir([pathname 'Images']) 
end
export_fig([pathname 'Images' filesep name], gcf,sprintf('-m%g', mag));
close(h2)
stop_logging();
set(handles.software_free, 'BackgroundColor', 'green')
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end


% --- Executes on button press in save_axis.
function save_axis_Callback(hObject, eventdata, handles)
global axis_save
axis_save = (get(hObject, 'Value'));



function dpi_value_Callback(hObject, eventdata, handles)
% hObject    handle to dpi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dpi_value as text
%        str2double(get(hObject,'String')) returns contents of dpi_value as a double


% --- Executes during object creation, after setting all properties.
function dpi_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpi_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mz_ranges_list.
function mz_ranges_list_Callback(hObject, eventdata, handles)
% hObject    handle to mz_ranges_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname
set(handles.software_free, 'BackgroundColor', 'red')
pause(.01);
contents4 = (get(hObject,'Value'));
fprintf('Selected file myBigData2_p%s \n', num2str(contents4));
C = load_scrolling_UI(handles, contents4, pathname);
set(handles.software_free, 'BackgroundColor', 'green')



% --- Executes during object creation, after setting all properties.
function mz_ranges_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mz_ranges_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_x_y_spacing.
function set_x_y_spacing_Callback(hObject, eventdata, handles)
global XSpacing YSpacing
if isempty(XSpacing) || isempty(YSpacing)
    XSpacing = '3000';
    YSpacing = '3000';
else
    XSpacing = num2str(XSpacing);
    YSpacing = num2str(YSpacing);
end
prompt = {'X-Spacing: microm','Y-Spacing: microm'};
dlg_title = 'Required Input';
num_lines = 1;
defaultans = {XSpacing,YSpacing};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
XSpacing = str2num(answer{1,1});
YSpacing = str2num(answer{2,1});


function start_logging()
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])


function stop_logging()
    diary off

function delete_logs()
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    if exist([saveMSIQuickViewLogs 'logs.txt'],'file')
        delete([saveMSIQuickViewLogs 'logs.txt'])   
    end