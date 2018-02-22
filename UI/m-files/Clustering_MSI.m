function varargout = Clustering_MSI(varargin)
% CLUSTERING_MSI MATLAB code for Clustering_MSI.fig
%      CLUSTERING_MSI, by itself, creates a new CLUSTERING_MSI or raises the existing
%      singleton*.
%
%      H = CLUSTERING_MSI returns the handle to a new CLUSTERING_MSI or the handle to
%      the existing singleton*.
%
%      CLUSTERING_MSI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLUSTERING_MSI.M with the given input arguments.
%
%      CLUSTERING_MSI('Property','Value',...) creates a new CLUSTERING_MSI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Clustering_MSI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Clustering_MSI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Clustering_MSI

% Last Modified by GUIDE v2.5 20-Jan-2013 09:58:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Clustering_MSI_OpeningFcn, ...
                   'gui_OutputFcn',  @Clustering_MSI_OutputFcn, ...
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


% --- Executes just before Clustering_MSI is made visible.
function Clustering_MSI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Clustering_MSI (see VARARGIN)

% Choose default command line output for Clustering_MSI
handles.output = hObject;
set(handles.output,'Name',['Clustering_GUI']);%['MSI QuickView Clustering GUI  v' '0.001']);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Clustering_MSI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Clustering_MSI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
maxfig(gcf,1)

% --- Executes on button press in browse_raw_files.
function browse_raw_files_Callback(~, ~, handles)
global filename pathname filterindex cdf_filename instrument_bruker list_point_count
global filename2 pathname2 filterindex2 cdf_filename2 list_point_count2 number_of_matrixes_to_open
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
[filename, pathname, filterindex] = uigetfile( ...
{  '*.yep;*.baf;*.RAW';'*.*'}, ...
   'Pick the RAW file');
if (~isdeployed)
addpath(pathname);
end
number_of_matrixes_to_open = get(handles.number_of_matrixes,'String');
number_of_matrixes_to_open = str2num(number_of_matrixes_to_open);
% addpath('C:\vis_xcalibur_raw_files\sc');
set(handles.editbox_raw_files,'string',pathname(1:end-1));
% Convert Xcalibur RAW file to CDF file
RAW_filename = strcat(pathname,filename);
add_cdf_folder = find(RAW_filename == filesep);
if strcmp(RAW_filename(end-2:end),'RAW')||strcmp(RAW_filename(end-2:end),'raw')
cdf_filename = [RAW_filename(1:add_cdf_folder(end)) 'CDF_Files' filesep RAW_filename(add_cdf_folder(end)+1:end-4) '.cdf' ];
else
cdf_filename = [RAW_filename(1:add_cdf_folder(end)) 'CDF_Files' filesep RAW_filename(add_cdf_folder(end)+1:end-4) '.cdf' ];
instrument_bruker = 1;    
end
if (~isdeployed)
addpath('C:\vis_xcalibur_raw_files');
end
if ~exist([pathname,'CDF_Files'],'dir')
    mkdir([pathname, 'CDF_Files'])
    mkdir([pathname, 'HDF_Files'])   
    mkdir([pathname, 'Images'])    
end
if exist([pathname,'points_count_list.mat'],'file')
    button = questdlg('File already exists !!! Use same file ??',...
    'Warning',...
    'Yes','No','Yes');
switch button
    case 'Yes'
        
    case 'No'
list_point_count = convert_raw_files_for_clustering(pathname(1:end-1));    
end
else
    list_point_count = convert_raw_files_for_clustering(pathname(1:end-1));
end
% list_point_count1 = list_point_count;
if number_of_matrixes_to_open > 1
[filename2, pathname2, filterindex2] = uigetfile( ...
{  '*.yep;*.baf;*.RAW';'*.*'}, ...
   'Pick the RAW file');
if (~isdeployed)
addpath(pathname2);
end
% number_of_matrixes_to_open = get(handles.number_of_matrixes,'Value');
% addpath('C:\vis_xcalibur_raw_files\sc');
% set(handles.editbox_raw_files,'string',pathname(1:end-1));
% Convert Xcalibur RAW file to CDF file
RAW_filename2 = strcat(pathname2,filename2);
if strcmp(RAW_filename2(end-2:end),'RAW')||strcmp(RAW_filename2(end-2:end),'raw')
cdf_filename2 = [RAW_filename2(1:end-4) '.cdf' ];
else
cdf_filename2 = [RAW_filename2(1:end-4) '.cdf' ];    
instrument_bruker = 1;    
end
% if (~isdeployed)
% addpath('C:\vis_xcalibur_raw_files');
% end
if exist([pathname2,'points_count_list.mat'],'file')
    button = questdlg('File already exists !!! Use same file ??',...
    'Warning',...
    'Yes','No','Yes');
switch button
    case 'Yes'
        
    case 'No'
list_point_count2 = convert_raw_files_for_clustering2(pathname2(1:end-1));    
end
else
    list_point_count2 = convert_raw_files_for_clustering2(pathname2(1:end-1));
end
% list_point_count2 = list_point_count;
end
% list_point_count = list_point_count1;
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end

function editbox_raw_files_Callback(hObject, eventdata, handles)
% hObject    handle to editbox_raw_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbox_raw_files as text
%        str2double(get(hObject,'String')) returns contents of editbox_raw_files as a double


% --- Executes during object creation, after setting all properties.
function editbox_raw_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbox_raw_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_matrix_file.
function browse_matrix_file_Callback(hObject, eventdata, handles)
global filename5 pathname5 filterindex5 list_point_count pathname number_of_matrixes_to_open filename6 pathname6 filterindex6 pathname2 list_point_count2
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');    
    diary([saveMSIQuickViewLogs 'logs.txt'])
[filename5, pathname5, filterindex5] = uigetfile( ...
{  '*.txt;';'*.*'}, ...
   'Pick the matrix file');
if (~isdeployed)
addpath(pathname5);
end
% addpath('C:\vis_xcalibur_raw_files\sc');
set(handles.editbox_matrix,'string',filename5);
if isempty(list_point_count)
    load([pathname,'points_count_list.mat']);
    load([pathname,'total_intensity.mat']);    
end
if number_of_matrixes_to_open > 1
    [filename6, pathname6, filterindex6] = uigetfile( ...
    {  '*.txt;';'*.*'}, ...
   'Pick the matrix file');
if isempty(list_point_count2)
    load([pathname2,'points_count_list.mat']);
end
end
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end



function editbox_matrix_Callback(hObject, eventdata, handles)
% hObject    handle to editbox_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbox_matrix as text
%        str2double(get(hObject,'String')) returns contents of editbox_matrix as a double


% --- Executes during object creation, after setting all properties.
function editbox_matrix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbox_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in linkage_clustering.
function linkage_clustering_Callback(hObject, eventdata, handles)
global filename5 pathname5 method_linkage pdist_option linkage_option cluster_option filename6 pathname6 number_of_matrixes_to_open pathname align_images_val colormap_3d
global D Z L c I min_no_of_pixels list_point_count class_list_final2 list_point_count2 total_intensity_final
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
%Read in Josh's Matrix
api = config_file;
saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
saveImagesToFolder = api.read_config_values('Folder', 'saveImagesToFolder');
disp('Please Wait !!!')
d = str2num(get(handles.pdf_file_no,'string'));
count100 = 1;
file_no = d;
if exist(strcat(pathname5,saveImagesToFolder,filesep,'pdf_list',num2str(file_no),'.pdf'),'file')
    button = questdlg('PDF already exists..Replace ???',...
    'Warning',...
    'OK','Cancel','OK');
switch button
    case 'OK'
%         break;
delete(strcat(pathname5,saveImagesToFolder,filesep,'pdf_list',num2str(file_no),'.pdf'))
    case 'Cancel'
        return;
% cd('C:\vis_xcalibur_raw_files');
end        
end
if exist(strcat(pathname5,saveTempFilesToFolder,filesep,'Cluster_Temp1'),'file')
   rmdir(strcat(pathname5,saveTempFilesToFolder,filesep,'Cluster_Temp1'),'s')
end
set(handles.uipanel2,'visible','off')
    set(handles.clear_all,'visible','off')
    set(handles.browse_raw_files,'visible','off')
    set(handles.editbox_raw_files,'visible','off')
    set(handles.browse_matrix_file,'visible','off')
    set(handles.editbox_matrix,'visible','off')
    set(handles.linkage_clustering,'visible','off')
    set(handles.text1,'visible','off')
    set(handles.pdf_file_no,'visible','off')
    set(handles.text2,'visible','off')
    set(handles.min_pixel_no,'visible','off')
    set(handles.text3,'visible','off')
    set(handles.static1,'visible','off')
    set(handles.cutoff_value,'visible','off')
    set(handles.cut_off_method,'visible','off')
    set(handles.text49,'visible','off')
    set(handles.pdist_options,'visible','off')
    set(handles.popupmenu_for_colormap3d,'visible','off')
    set(handles.text50,'visible','off')
    set(handles.linkage_options,'visible','off')
    set(handles.text51,'visible','off')
    set(handles.cluster_options,'visible','off')
    set(handles.max_no_clusters,'visible','off')
    set(handles.max_no_clusters_linkage,'visible','off')
    set(handles.clusters_linkage_method,'visible','off')
    set(handles.uipanel4,'visible','off')
    set(handles.across_aspect_ratio_static,'visible','off')
    set(handles.aspect_ratio_across_edit,'visible','off')
    set(handles.down_aspect_ratio_static,'visible','off')
    set(handles.aspect_ratio_down_edit,'visible','off')
    set(handles.enter_scaling_values,'visible','off')
    set(handles.crop_pdf,'visible','off')
    set(handles.reset_scale_button,'visible','off')    
    set(handles.axes1,'visible','off')
    set(handles.axes2,'visible','off')
    set(handles.axes3,'visible','off')
    set(handles.axes4,'visible','off')
    set(handles.axes5,'visible','off')
    set(handles.axes6,'visible','off')
    set(handles.axes7,'visible','off')
    set(handles.axes8,'visible','off')
    set(handles.axes9,'visible','off')
    set(handles.axes10,'visible','off')
    set(handles.axes11,'visible','off')
    set(handles.axes12,'visible','off')
    set(handles.axes13,'visible','off')
    set(handles.axes14,'visible','off')
    set(handles.axes15,'visible','off')
    set(handles.axes16,'visible','off')
    set(handles.axes17,'visible','off')
    set(handles.axes18,'visible','off')
    set(handles.axes19,'visible','off')
    set(handles.axes20,'visible','off')
    set(handles.axes21,'visible','off')
    set(handles.axes22,'visible','off')
    set(handles.axes23,'visible','off')
    set(handles.axes24,'visible','off')
    set(handles.axes25,'visible','off')
    set(handles.axes26,'visible','off')
    set(handles.axes27,'visible','off')
    set(handles.axes28,'visible','off')
    set(handles.axes29,'visible','off')
    set(handles.axes30,'visible','off')
    set(handles.axes31,'visible','off')
    set(handles.axes32,'visible','off')
    set(handles.axes33,'visible','off')
    set(handles.axes34,'visible','off')
    set(handles.axes35,'visible','off')
    set(handles.axes36,'visible','off') 
    set(handles.axes37,'visible','off')
    set(handles.axes38,'visible','off')
    set(handles.axes39,'visible','off')
    set(handles.axes40,'visible','off')
    set(handles.axes41,'visible','off')
    set(handles.axes42,'visible','off')
    set(handles.axes43,'visible','off')
    set(handles.axes44,'visible','off')
    set(handles.axes45,'visible','off')
    set(handles.axes46,'visible','off')
    set(handles.axes47,'visible','off')
    set(handles.axes48,'visible','off')
    set(handles.axes49,'visible','off')
    set(handles.axes50,'visible','off')
    set(handles.axes51,'visible','off')
    set(handles.axes52,'visible','off')
    set(handles.axes53,'visible','off')
    set(handles.axes54,'visible','off')
    set(handles.axes55,'visible','off')
    set(handles.axes56,'visible','off')
    set(handles.axes57,'visible','off')
    set(handles.axes58,'visible','off')
    set(handles.axes59,'visible','off')
    set(handles.axes60,'visible','off')
    set(handles.axes61,'visible','off')
    set(handles.axes62,'visible','off')
    set(handles.axes63,'visible','off')
    set(handles.axes64,'visible','off')
    set(handles.axes65,'visible','off')
    set(handles.axes66,'visible','off')
    set(handles.axes67,'visible','off')
    set(handles.axes68,'visible','off')
    set(handles.axes69,'visible','off')
    set(handles.axes70,'visible','off')
    set(handles.axes71,'visible','off')
    set(handles.axes72,'visible','off')
    set(handles.axes73,'visible','off')
    set(handles.axes74,'visible','off')
    set(handles.axes75,'visible','off')
    set(handles.axes76,'visible','off')
    set(handles.axes77,'visible','off')
    set(handles.axes78,'visible','off')    
set(handles.uipanel3,'visible','on')

%     set(handles.axes2_plot_images,'visible','on')    
% axes(handles.axes2_plot_images)
% set(gca, 'NextPlot', 'add')
% set(gca, 'visible', 'off')
for kk = 0.1%:0.2:1.1
% M = dlmread(strcat(pathname5,filename5));%('aligned_2D8R4T1_sn3_2.5e3.txt');
% mz = M(:,1);
% m = M(:,2:end);
% for i = 1:5177
%     num2 = m(m(i,:)>0);
%     num(i) = size(num2,2);
% end
min_no_of_pixels = str2num(get(handles.min_pixel_no,'string'));
% disp(min_no_of_pixels)
% if isempty(min_no_of_pixels)
%     min_no_of_pixels = 1;
% end
% for i = 1:5177
%    if num(i) < min_no_of_pixels
%       m(i,:) = 0; 
%    end
% end
% mz(all(m==0,2),:)=[];
% m(all(m==0,2),:)=[];
% clear M
% disp('stage 1')
% disp(size(m))
% % m=mat2gray(m)*(1-realmin) + realmin;
% 
% %Linkage Analysis
% uz4 = mz;
% D = pdist(m,'correlation');
% disp('stage 5')
% Z = squareform(D);
% disp('stage 6')
% L = linkage(Z,'average','correlation');
% c = cophenet(L,D);
% I = inconsistent(L);

[m, uz4, L, I, mz, compare_matr] = linkage_analysis(pathname5,filename5,min_no_of_pixels, pdist_option, linkage_option,pathname6,filename6,number_of_matrixes_to_open);
m = bsxfun(@rdivide, m,total_intensity_final);
cut_off_val = str2num(get(handles.cutoff_value,'string'));%1.15;%max(I(:,4))-0.0001;%kk;
if isempty(cut_off_val)
    cut_off_val = 1.1;%max(I(:,4)-0.001);
end
disp('stage 2')
disp(kk)
if isempty(cluster_option)
cluster_option = 'distance';
end
if isempty(method_linkage)
   method_linkage = 1; 
end
if method_linkage == 1
T2 = cluster(L,'cutoff',cut_off_val,'criterion', cluster_option);%,'depth',2);
elseif method_linkage == 2
T2 = cluster(L,'maxclust',100);%'cutoff',cut_off_val,'maxclust',100);    
end
disp('stage 3')
class_list_final = zeros(max(T2(:)),100,'single');
class_list_final(class_list_final==0) = NaN;
% class_list_final2 = zeros(max(T2(:)),100,'single');
class_list_final2 = class_list_final;
for class_list = 1:max(T2(:))
   current_class = find(T2 == class_list);
    for i_current_class = 1:size(current_class,1)
        if current_class(i_current_class) <= size(uz4,1)
            new_current_list(i_current_class) = uz4(current_class(i_current_class));
            new_mz_loc_list(i_current_class) = current_class(i_current_class);
        else
            new_current_list(i_current_class) = strcat(current_class,'*');
            new_mz_loc_list(i_current_class) = strcat(current_class,'*');
        end
    end   
Cluster_fn.(sprintf('Class%d', class_list)) = new_current_list;
class_list_final(class_list,1:size(new_current_list,2)) = new_current_list;
class_list_final2(class_list,1:size(new_current_list,2)) = new_mz_loc_list;
new_current_list = [];
new_mz_loc_list = [];
end
s1 = list_point_count;%[143,140,144,144,142,144, 143, 144, 145, 144,144, 144, 142,144, 142,143,143,...
%     144,143,145,146,146,144,145,148,148]; 
j2 = 1;
% figure(1);
for i = 1:size(class_list_final2,1)
%     uu = class_list_final2(~isnan(class_list_final2(i,:)));
    [m2,n2] = find(~isnan(class_list_final2(i,:)));
    for i3 = 1:size(n2,2)
    uu(i3) = class_list_final2(i,n2(i3));
    end
    uu(uu==0)=[];
    if i == 1
    i55 = i;
    end
    if size(uu,2) > 0 %&& size(uu,2) <= 10 
        for j = 1:size(uu,2)
            if number_of_matrixes_to_open > 1
                if uu(j) > compare_matr
                    s1 = list_point_count2;
                else
                    s1 = list_point_count;
                end
            end
%             if(uu(j) > 0)
            img = zeros(size(list_point_count,2),max(list_point_count(:)),'single');
            % row_no = 30;
            count = 1;
            for i2 = 1:size(s1,2)%15
               img(i2,1:s1(i2)) = m(uu(j),count:count+s1(i2)-1); 
               count = count + s1(i2);
            end
%             if number_of_matrixes_to_open > 1
%                 xnorm = zeros(size(img,1),size(img,2),'single');
%                 if uu(j) > compare_matr
%                     new_min = 101;    %min of 0 to 255
%                     new_max = 200;  %max of 0 to 255
%                     old_min = min(img(:));
%                     old_max = max(img(:));
%                     for i5 = 1:size(img,1)
%                         for j5 = 1:size(img,2)
%                         value = img(i5, j5);
%                         xnorm(i5,j5) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
%                         end
%                     end
%                     img = xnorm;                 
%                 else
%                     new_min = 0;    %min of 0 to 255
%                     new_max = 100;  %max of 0 to 255
%                     old_min = min(img(:));
%                     old_max = max(img(:));
%                     for i5 = 1:size(img,1)
%                         for j5 = 1:size(img,2)
%                         value = img(i5, j5);
%                         xnorm(i5,j5) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
%                         end
%                     end
%                     img = xnorm;
%                 end
% %                 cmap = [hot;jet];
% %                 colormap(cmap)
%             end            
%%
align_images_val = 0;
if align_images_val == 1
filename2 = strcat(pathname,'HDF_Files');
sum_of_intensities2 = interpolation_code_clustering(img, filename2);
% if image_window_to_display_value == 1
% cla(handles.zone_specified_plot);
% axes(handles.zone_specified_plot);
% else    
% cla(handles.zone_specified_plot2);
% axes(handles.zone_specified_plot2);
% end
new_min = 0;    %min of 0 to 255
new_max = 100;  %max of 0 to 255
old_min = min(min(sum_of_intensities2(:)));
old_max = max(max(sum_of_intensities2(:)));    
% count_3 = 1;
for count_3 = 1:size(sum_of_intensities2,1)
for j22 = 1:size(sum_of_intensities2,2)
    value = sum_of_intensities2(count_3, j22);
    sum_of_intensities2(count_3, j22) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
end
end
img = sum_of_intensities2;
end
%%            
            

if j2 == 1
   set(handles.axes1,'visible','on')
   axes(handles.axes1) 
elseif j2 == 2
   set(handles.axes2,'visible','on') 
   axes(handles.axes2) 
elseif j2 == 3
   set(handles.axes3,'visible','on') 
   axes(handles.axes3)    
elseif j2 == 4
   set(handles.axes4,'visible','on') 
   axes(handles.axes4) 
elseif j2 == 5
   set(handles.axes5,'visible','on') 
   axes(handles.axes5)      
elseif j2 == 6
   set(handles.axes6,'visible','on') 
   axes(handles.axes6) 
elseif j2 == 7
   set(handles.axes7,'visible','on') 
   axes(handles.axes7)    
elseif j2 == 8
   set(handles.axes8,'visible','on') 
   axes(handles.axes8) 
elseif j2 == 9
   set(handles.axes9,'visible','on') 
   axes(handles.axes9)
elseif j2 == 10
   set(handles.axes10,'visible','on') 
   axes(handles.axes10) 
elseif j2 == 11
   set(handles.axes11,'visible','on') 
   axes(handles.axes11)    
elseif j2 == 12
   set(handles.axes12,'visible','on') 
   axes(handles.axes12) 
elseif j2 == 13
   set(handles.axes13,'visible','on') 
   axes(handles.axes13)
elseif j2 == 14
   set(handles.axes14,'visible','on') 
   axes(handles.axes14) 
elseif j2 == 15
   set(handles.axes15,'visible','on') 
   axes(handles.axes15)    
elseif j2 == 16
   set(handles.axes16,'visible','on') 
   axes(handles.axes16) 
elseif j2 == 17
   set(handles.axes17,'visible','on') 
   axes(handles.axes17)   
elseif j2 == 18
   set(handles.axes18,'visible','on') 
   axes(handles.axes18)      
elseif j2 == 19
   set(handles.axes19,'visible','on') 
   axes(handles.axes19) 
elseif j2 == 20
   set(handles.axes20,'visible','on') 
   axes(handles.axes20)    
elseif j2 == 21
   set(handles.axes21,'visible','on') 
   axes(handles.axes21) 
elseif j2 == 22
   set(handles.axes22,'visible','on') 
   axes(handles.axes22)      
elseif j2 == 23
   set(handles.axes23,'visible','on') 
   axes(handles.axes23) 
elseif j2 == 24
   set(handles.axes24,'visible','on') 
   axes(handles.axes24)    
elseif j2 == 25
   set(handles.axes25,'visible','on') 
   axes(handles.axes25) 
elseif j2 == 26
   set(handles.axes26,'visible','on') 
   axes(handles.axes26)
elseif j2 == 27
   set(handles.axes27,'visible','on') 
   axes(handles.axes27) 
elseif j2 == 28
   set(handles.axes28,'visible','on') 
   axes(handles.axes28)    
elseif j2 == 29
   set(handles.axes29,'visible','on') 
   axes(handles.axes29) 
elseif j2 == 30
   set(handles.axes30,'visible','on') 
   axes(handles.axes30)
elseif j2 == 31
   set(handles.axes31,'visible','on') 
   axes(handles.axes31) 
elseif j2 == 32
   set(handles.axes32,'visible','on') 
   axes(handles.axes32) 
elseif j2 == 33
   set(handles.axes33,'visible','on') 
   axes(handles.axes33)    
elseif j2 == 34
   set(handles.axes34,'visible','on') 
   axes(handles.axes34)    
elseif j2 == 35
   set(handles.axes35,'visible','on') 
   axes(handles.axes35) 
elseif j2 == 36
   set(handles.axes36,'visible','on') 
   axes(handles.axes36)   
elseif j2 == 37
   set(handles.axes37,'visible','on')
   axes(handles.axes37) 
elseif j2 == 38
   set(handles.axes38,'visible','on') 
   axes(handles.axes38) 
elseif j2 == 39
   set(handles.axes39,'visible','on') 
   axes(handles.axes39)    
elseif j2 == 40
   set(handles.axes40,'visible','on') 
   axes(handles.axes40) 
elseif j2 == 41
   set(handles.axes41,'visible','on') 
   axes(handles.axes41)      
elseif j2 == 42
   set(handles.axes42,'visible','on') 
   axes(handles.axes42) 
elseif j2 == 43
   set(handles.axes43,'visible','on') 
   axes(handles.axes43)    
elseif j2 == 44
   set(handles.axes44,'visible','on') 
   axes(handles.axes44) 
elseif j2 == 45
   set(handles.axes45,'visible','on') 
   axes(handles.axes45)
elseif j2 == 46
   set(handles.axes46,'visible','on') 
   axes(handles.axes46) 
elseif j2 == 47
   set(handles.axes47,'visible','on') 
   axes(handles.axes47)    
elseif j2 == 48
   set(handles.axes48,'visible','on') 
   axes(handles.axes48) 
elseif j2 == 49
   set(handles.axes49,'visible','on') 
   axes(handles.axes49)
elseif j2 == 50
   set(handles.axes50,'visible','on') 
   axes(handles.axes50) 
elseif j2 == 51
   set(handles.axes51,'visible','on') 
   axes(handles.axes51)    
elseif j2 == 52
   set(handles.axes52,'visible','on') 
   axes(handles.axes52) 
elseif j2 == 53
   set(handles.axes53,'visible','on') 
   axes(handles.axes53)   
elseif j2 == 54
   set(handles.axes54,'visible','on') 
   axes(handles.axes54)      
elseif j2 == 55
   set(handles.axes55,'visible','on') 
   axes(handles.axes55) 
elseif j2 == 56
   set(handles.axes56,'visible','on') 
   axes(handles.axes56)    
elseif j2 == 57
   set(handles.axes57,'visible','on') 
   axes(handles.axes57) 
elseif j2 == 58
   set(handles.axes58,'visible','on') 
   axes(handles.axes58)      
elseif j2 == 59
   set(handles.axes59,'visible','on') 
   axes(handles.axes59) 
elseif j2 == 60
   set(handles.axes60,'visible','on') 
   axes(handles.axes60)    
elseif j2 == 61
   set(handles.axes61,'visible','on') 
   axes(handles.axes61) 
elseif j2 == 62
   set(handles.axes62,'visible','on') 
   axes(handles.axes62)
elseif j2 == 63
   set(handles.axes63,'visible','on') 
   axes(handles.axes63) 
elseif j2 == 64
   set(handles.axes64,'visible','on') 
   axes(handles.axes64)    
elseif j2 == 65
   set(handles.axes65,'visible','on') 
   axes(handles.axes65) 
elseif j2 == 66
   set(handles.axes66,'visible','on') 
   axes(handles.axes66)
elseif j2 == 67
   set(handles.axes67,'visible','on') 
   axes(handles.axes67) 
elseif j2 == 68
   set(handles.axes68,'visible','on') 
   axes(handles.axes68) 
elseif j2 == 69
   set(handles.axes69,'visible','on') 
   axes(handles.axes69)    
elseif j2 == 70
   set(handles.axes70,'visible','on') 
   axes(handles.axes70)    
elseif j2 == 71
   set(handles.axes71,'visible','on') 
   axes(handles.axes71) 
elseif j2 == 72
   set(handles.axes72,'visible','on') 
   axes(handles.axes72)   
elseif j2 == 73
   set(handles.axes73,'visible','on') 
   axes(handles.axes73)
elseif j2 == 74
   set(handles.axes74,'visible','on') 
   axes(handles.axes74) 
elseif j2 == 75
   set(handles.axes75,'visible','on') 
   axes(handles.axes75) 
elseif j2 == 76
   set(handles.axes76,'visible','on') 
   axes(handles.axes76)    
elseif j2 == 77
   set(handles.axes77,'visible','on') 
   axes(handles.axes77)    
elseif j2 == 78
   set(handles.axes78,'visible','on') 
   axes(handles.axes78)   
end
%             h5 = subplot(6,3,j2); 
if uu(j) > compare_matr
                text_color = [1,0,0];
%                 colormap(cmap)
else
    text_color = [0,0,0];
end

            imagesc(img); title(strcat('Class',num2str(i),' {\it mz } ', num2str(mz(uu(j)))),'FontSize',3.5,'Color',text_color); colormap(strcat(colormap_3d,'(32)'));%pause(.5); 
            axis off 
            if j == size(uu,2)
                if j2 <=13
                    j2 = 14;
                    set(handles.uipanel369,'visible','on')
                    set(handles.text11,'visible','on')
                elseif j2 <=26
                    j2 = 27;
                    set(handles.uipanel370,'visible','on')
                    set(handles.text12,'visible','on')
                elseif j2 <=39
                    set(handles.uipanel371,'visible','on')
                    set(handles.text13,'visible','on')
                    j2 = 40;
                elseif j2 <=52
                    set(handles.uipanel372,'visible','on')
                    set(handles.text14,'visible','on')
                    j2 = 53;
                elseif j2 <=65
                    set(handles.uipanel373,'visible','on')
                    set(handles.text15,'visible','on')
                    j2 = 66;
                elseif j2 <=78
                    set(handles.uipanel374,'visible','on')
                    set(handles.text16,'visible','on')
                    j2 = 79;                    
                end
            else
                j2 = j2+1;
            end
%             j2 = j2+1;
%             i55 = i;
            if j2 > 78%10
                   if i == 1
                   mkdir([pathname5, saveTempFilesToFolder, filesep, 'Cluster_Temp',num2str(count100)])
%                    set(handles.uipanel3,'Title','Correlation')
                   end        
                   fnout = [pathname5, saveTempFilesToFolder, filesep, 'Cluster_Temp',num2str(count100),filesep,'images',num2str(i55*10^-4), '.pdf'];
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperSize', [6.25 7.5]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [.25 .25 6.15 7.35]);
% set(gcf, 'renderer', 'painters');
% h=gcf;
% set(gcf, 'PaperSize', [8.5 11]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [.25 .25 5.15 8.15]);
% set(h,'PaperOrientation','landscape');
% set(gcf, 'PaperSize', [7.5 6.25]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [.25 .25 7.45 6.15]);
% set(h,'PaperPosition', [1 1 28 19]);
                   print('-dpdf','-r300',fnout);
                   i55 = i55 + 1;
                   j2 = 1;
cla(handles.axes1)
title(handles.axes1,' ')
cla(handles.axes2)
title(handles.axes2,' ')
cla(handles.axes3)
title(handles.axes3,' ')
cla(handles.axes4)
title(handles.axes4,' ')
cla(handles.axes5)
title(handles.axes5,' ')
cla(handles.axes6)
title(handles.axes6,' ')
cla(handles.axes7)
title(handles.axes7,' ')
cla(handles.axes8)
title(handles.axes8,' ')
cla(handles.axes9)
title(handles.axes9,' ')
cla(handles.axes10)
title(handles.axes10,' ')
cla(handles.axes11)
title(handles.axes11,' ')
cla(handles.axes12)
title(handles.axes12,' ')
cla(handles.axes13)
title(handles.axes13,' ')
cla(handles.axes14)
title(handles.axes14,' ')
cla(handles.axes15)
title(handles.axes15,' ')
cla(handles.axes16)
title(handles.axes16,' ')
cla(handles.axes17)
title(handles.axes17,' ')
cla(handles.axes18)
title(handles.axes18,' ')
cla(handles.axes19)
title(handles.axes19,' ')
cla(handles.axes20)
title(handles.axes20,' ')
cla(handles.axes21)
title(handles.axes21,' ')
cla(handles.axes22)
title(handles.axes22,' ')
cla(handles.axes23)
title(handles.axes23,' ')
cla(handles.axes24)
title(handles.axes24,' ')
cla(handles.axes25)
title(handles.axes25,' ')
cla(handles.axes26)
title(handles.axes26,' ')
cla(handles.axes27)
title(handles.axes27,' ')
cla(handles.axes28)
title(handles.axes28,' ')
cla(handles.axes29)
title(handles.axes29,' ')
cla(handles.axes30)
title(handles.axes30,' ')
cla(handles.axes31)
title(handles.axes31,' ')
cla(handles.axes32)
title(handles.axes32,' ')
cla(handles.axes33)
title(handles.axes33,' ')
cla(handles.axes34)
title(handles.axes34,' ')
cla(handles.axes35)
title(handles.axes35,' ')
cla(handles.axes36)
title(handles.axes36,' ')
cla(handles.axes37)
title(handles.axes37,' ')
cla(handles.axes38)
title(handles.axes38,' ')
cla(handles.axes39)
title(handles.axes39,' ')
cla(handles.axes40)
title(handles.axes40,' ')
cla(handles.axes41)
title(handles.axes41,' ')
cla(handles.axes42)
title(handles.axes42,' ')
cla(handles.axes43)
title(handles.axes43,' ')
cla(handles.axes44)
title(handles.axes44,' ')
cla(handles.axes45)
title(handles.axes45,' ')
cla(handles.axes46)
title(handles.axes46,' ')
cla(handles.axes47)
title(handles.axes47,' ')
cla(handles.axes48)
title(handles.axes48,' ')
cla(handles.axes49)
title(handles.axes49,' ')
cla(handles.axes50)
title(handles.axes50,' ')
cla(handles.axes51)
title(handles.axes51,' ')
cla(handles.axes52)
title(handles.axes52,' ')
cla(handles.axes53)
title(handles.axes53,' ')
cla(handles.axes54)
title(handles.axes54,' ')
cla(handles.axes55)
title(handles.axes55,' ')
cla(handles.axes56)
title(handles.axes56,' ')
cla(handles.axes57)
title(handles.axes57,' ')
cla(handles.axes58)
title(handles.axes58,' ')
cla(handles.axes59)
title(handles.axes59,' ')
cla(handles.axes60)
title(handles.axes60,' ')
cla(handles.axes61)
title(handles.axes61,' ')
cla(handles.axes62)
title(handles.axes62,' ')
cla(handles.axes63)
title(handles.axes63,' ')
cla(handles.axes64)
title(handles.axes64,' ')
cla(handles.axes65)
title(handles.axes65,' ')
cla(handles.axes66)
title(handles.axes66,' ')
cla(handles.axes67)
title(handles.axes67,' ')
cla(handles.axes68)
title(handles.axes68,' ')
cla(handles.axes69)
title(handles.axes69,' ')
cla(handles.axes70)
title(handles.axes70,' ')
cla(handles.axes71)
title(handles.axes71,' ')
cla(handles.axes72)
title(handles.axes72,' ')
cla(handles.axes73)
title(handles.axes73,' ')
cla(handles.axes74)
title(handles.axes74,' ')
cla(handles.axes75)
title(handles.axes75,' ')
cla(handles.axes76)
title(handles.axes76,' ')
cla(handles.axes77)
title(handles.axes77,' ')
cla(handles.axes78)
title(handles.axes78,' ')
set(handles.text11,'visible','off')
set(handles.text12,'visible','off')
set(handles.text13,'visible','off')
set(handles.text14,'visible','off')
set(handles.text15,'visible','off')
set(handles.text16,'visible','off')
set(handles.uipanel369,'visible','off')
set(handles.uipanel370,'visible','off')
set(handles.uipanel371,'visible','off')
set(handles.uipanel372,'visible','off')
set(handles.uipanel373,'visible','off')
set(handles.uipanel374,'visible','off')
%     set(handles.axes1,'visible','off')
%     set(handles.axes2,'visible','off')
%     set(handles.axes3,'visible','off')
%     set(handles.axes7,'visible','off')
%     set(handles.axes8,'visible','off')
%     set(handles.axes9,'visible','off')
%     set(handles.axes13,'visible','off')
%     set(handles.axes14,'visible','off')
%     set(handles.axes15,'visible','off')
%     set(handles.axes19,'visible','off')
%     set(handles.axes20,'visible','off')
%     set(handles.axes21,'visible','off')
%     set(handles.axes25,'visible','off')
%     set(handles.axes26,'visible','off')
%     set(handles.axes27,'visible','off')
%     set(handles.axes31,'visible','off')
%     set(handles.axes32,'visible','off')
%     set(handles.axes33,'visible','off')
%                    clf(figure(1)) %THIS                       
            end
%             end
        end
           if i == 1
           mkdir([pathname5, saveTempFilesToFolder, filesep, 'Cluster_Temp',num2str(count100)])
%            set(handles.uipanel3,'Title','Correlation') 
           end        
        if j2 == 80%11
           fnout = [pathname5, saveTempFilesToFolder, filesep, 'Cluster_Temp',num2str(count100), filesep, 'images',num2str(i55*10^-4), '.pdf'];
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperSize', [6.25 7.5]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 0.25 6.15 7.35]);
% set(gcf, 'renderer', 'painters');
% h=gcf;
% set(gcf, 'PaperSize', [8.5 11]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [.25 .25 5.15 8.15]);
% set(h,'PaperOrientation','landscape');
% set(h,'PaperPosition', [1 1 28 19]);
           print('-dpdf','-r300',fnout);
           i55 = i55+1;
           j2 = 0;
%            clf(figure(1))   %THIS    
% cla(handles.axes1)
% cla(handles.axes2)
% cla(handles.axes3)
% cla(handles.axes7)
% cla(handles.axes8)
% cla(handles.axes9)
% cla(handles.axes13)
% cla(handles.axes14)
% cla(handles.axes15)
% cla(handles.axes19)
% cla(handles.axes20)
% cla(handles.axes21)
% cla(handles.axes25)
% cla(handles.axes26)
% cla(handles.axes27)
% cla(handles.axes31)
% cla(handles.axes32)
% cla(handles.axes33)
cla(handles.axes1)
title(handles.axes1,' ')
cla(handles.axes2)
title(handles.axes2,' ')
cla(handles.axes3)
title(handles.axes3,' ')
cla(handles.axes4)
title(handles.axes4,' ')
cla(handles.axes5)
title(handles.axes5,' ')
cla(handles.axes6)
title(handles.axes6,' ')
cla(handles.axes7)
title(handles.axes7,' ')
cla(handles.axes8)
title(handles.axes8,' ')
cla(handles.axes9)
title(handles.axes9,' ')
cla(handles.axes10)
title(handles.axes10,' ')
cla(handles.axes11)
title(handles.axes11,' ')
cla(handles.axes12)
title(handles.axes12,' ')
cla(handles.axes13)
title(handles.axes13,' ')
cla(handles.axes14)
title(handles.axes14,' ')
cla(handles.axes15)
title(handles.axes15,' ')
cla(handles.axes16)
title(handles.axes16,' ')
cla(handles.axes17)
title(handles.axes17,' ')
cla(handles.axes18)
title(handles.axes18,' ')
cla(handles.axes19)
title(handles.axes19,' ')
cla(handles.axes20)
title(handles.axes20,' ')
cla(handles.axes21)
title(handles.axes21,' ')
cla(handles.axes22)
title(handles.axes22,' ')
cla(handles.axes23)
title(handles.axes23,' ')
cla(handles.axes24)
title(handles.axes24,' ')
cla(handles.axes25)
title(handles.axes25,' ')
cla(handles.axes26)
title(handles.axes26,' ')
cla(handles.axes27)
title(handles.axes27,' ')
cla(handles.axes28)
title(handles.axes28,' ')
cla(handles.axes29)
title(handles.axes29,' ')
cla(handles.axes30)
title(handles.axes30,' ')
cla(handles.axes31)
title(handles.axes31,' ')
cla(handles.axes32)
title(handles.axes32,' ')
cla(handles.axes33)
title(handles.axes33,' ')
cla(handles.axes34)
title(handles.axes34,' ')
cla(handles.axes35)
title(handles.axes35,' ')
cla(handles.axes36)
title(handles.axes36,' ')
cla(handles.axes37)
title(handles.axes37,' ')
cla(handles.axes38)
title(handles.axes38,' ')
cla(handles.axes39)
title(handles.axes39,' ')
cla(handles.axes40)
title(handles.axes40,' ')
cla(handles.axes41)
title(handles.axes41,' ')
cla(handles.axes42)
title(handles.axes42,' ')
cla(handles.axes43)
title(handles.axes43,' ')
cla(handles.axes44)
title(handles.axes44,' ')
cla(handles.axes45)
title(handles.axes45,' ')
cla(handles.axes46)
title(handles.axes46,' ')
cla(handles.axes47)
title(handles.axes47,' ')
cla(handles.axes48)
title(handles.axes48,' ')
cla(handles.axes49)
title(handles.axes49,' ')
cla(handles.axes50)
title(handles.axes50,' ')
cla(handles.axes51)
title(handles.axes51,' ')
cla(handles.axes52)
title(handles.axes52,' ')
cla(handles.axes53)
title(handles.axes53,' ')
cla(handles.axes54)
title(handles.axes54,' ')
cla(handles.axes55)
title(handles.axes55,' ')
cla(handles.axes56)
title(handles.axes56,' ')
cla(handles.axes57)
title(handles.axes57,' ')
cla(handles.axes58)
title(handles.axes58,' ')
cla(handles.axes59)
title(handles.axes59,' ')
cla(handles.axes60)
title(handles.axes60,' ')
cla(handles.axes61)
title(handles.axes61,' ')
cla(handles.axes62)
title(handles.axes62,' ')
cla(handles.axes63)
title(handles.axes63,' ')
cla(handles.axes64)
title(handles.axes64,' ')
cla(handles.axes65)
title(handles.axes65,' ')
cla(handles.axes66)
title(handles.axes66,' ')
cla(handles.axes67)
title(handles.axes67,' ')
cla(handles.axes68)
title(handles.axes68,' ')
cla(handles.axes69)
title(handles.axes69,' ')
cla(handles.axes70)
title(handles.axes70,' ')
cla(handles.axes71)
title(handles.axes71,' ')
cla(handles.axes72)
title(handles.axes72,' ')
cla(handles.axes73)
title(handles.axes73,' ')
cla(handles.axes74)
title(handles.axes74,' ')
cla(handles.axes75)
title(handles.axes75,' ')
cla(handles.axes76)
title(handles.axes76,' ')
cla(handles.axes77)
title(handles.axes77,' ')
cla(handles.axes78)
title(handles.axes78,' ')
set(handles.text11,'visible','off')
set(handles.text12,'visible','off')
set(handles.text13,'visible','off')
set(handles.text14,'visible','off')
set(handles.text15,'visible','off')
set(handles.text16,'visible','off')
set(handles.uipanel369,'visible','off')
set(handles.uipanel370,'visible','off')
set(handles.uipanel371,'visible','off')
set(handles.uipanel372,'visible','off')
set(handles.uipanel373,'visible','off')
set(handles.uipanel374,'visible','off')
%     set(handles.axes1,'visible','off')
%     set(handles.axes2,'visible','off')
%     set(handles.axes3,'visible','off')
%     set(handles.axes7,'visible','off')
%     set(handles.axes8,'visible','off')
%     set(handles.axes9,'visible','off')
%     set(handles.axes13,'visible','off')
%     set(handles.axes14,'visible','off')
%     set(handles.axes15,'visible','off')
%     set(handles.axes19,'visible','off')
%     set(handles.axes20,'visible','off')
%     set(handles.axes21,'visible','off')
%     set(handles.axes25,'visible','off')
%     set(handles.axes26,'visible','off')
%     set(handles.axes27,'visible','off')
%     set(handles.axes31,'visible','off')
%     set(handles.axes32,'visible','off')
%     set(handles.axes33,'visible','off')
        end
%         j2 = j2+1;
    end
%     set(handles.axes1,'visible','off')
%     set(handles.axes2,'visible','off')
%     set(handles.axes3,'visible','off')
%     set(handles.axes7,'visible','off')
%     set(handles.axes8,'visible','off')
%     set(handles.axes9,'visible','off')
%     set(handles.axes13,'visible','off')
%     set(handles.axes14,'visible','off')
%     set(handles.axes15,'visible','off')
%     set(handles.axes19,'visible','off')
%     set(handles.axes20,'visible','off')
%     set(handles.axes21,'visible','off')
%     set(handles.axes25,'visible','off')
%     set(handles.axes26,'visible','off')
%     set(handles.axes27,'visible','off')
%     set(handles.axes31,'visible','off')
%     set(handles.axes32,'visible','off')
%     set(handles.axes33,'visible','off')
%     h1 = [];
% cla(handles.axes2_plot_images)
% delete(get(handles.axes2_plot_images,'Children'))

%     clf(figure(1))
uu = [];
% delete(h1);
end
% system(['C:\vis_xcalibur_raw_files\pdftk' ' ' strcat('C:\Users\thom991\Desktop\for_ingela',num2str(count100),'\*.pdf') ' ' 'output' ' ' strcat('C:\Users\thom991\Desktop\for_ingela',num2str(count100),'\combined.pdf')]);
system(['C:\vis_xcalibur_raw_files\pdftk' ' ' strcat('"',pathname5, saveTempFilesToFolder, filesep, 'Cluster_Temp',num2str(count100),filesep,'*.pdf','"') ' ' 'output' ' ' strcat('"',pathname5,'Images',filesep,'pdf_list',num2str(file_no),'.pdf','"')]);
% system(['"','C:\Program Files (x86)\PlotSoft\PDFill', '"', ' ', 'CROP', ' ', '"',pathname5,'delete_mat_files',filesep,'pdf_list',num2str(file_no),'.pdf', '"', ' ', '"',pathname5,'Images',filesep,'pdf_list',num2str(file_no),'.pdf','"' ' '  '0' ' ' '2.5' ' ' '0' ' ' '2.5'])
% system('"C:\vis_xcalibur_raw_files\pdfscissors-offline.jnlp"')
count100 = count100 + 1;
file_no = file_no + 1;
end
set(handles.uipanel3,'visible','off')
    set(handles.axes1,'visible','off')
    set(handles.axes2,'visible','off')
    set(handles.axes3,'visible','off')
    set(handles.axes4,'visible','off')
    set(handles.axes5,'visible','off')
    set(handles.axes6,'visible','off')
    set(handles.axes7,'visible','off')
    set(handles.axes8,'visible','off')
    set(handles.axes9,'visible','off')
    set(handles.axes10,'visible','off')
    set(handles.axes11,'visible','off')
    set(handles.axes12,'visible','off')
    set(handles.axes13,'visible','off')
    set(handles.axes14,'visible','off')
    set(handles.axes15,'visible','off')
    set(handles.axes16,'visible','off')
    set(handles.axes17,'visible','off')
    set(handles.axes18,'visible','off')
    set(handles.axes19,'visible','off')
    set(handles.axes20,'visible','off')
    set(handles.axes21,'visible','off')
    set(handles.axes22,'visible','off')
    set(handles.axes23,'visible','off')
    set(handles.axes24,'visible','off')
    set(handles.axes25,'visible','off')
    set(handles.axes26,'visible','off')
    set(handles.axes27,'visible','off')
    set(handles.axes28,'visible','off')
    set(handles.axes29,'visible','off')
    set(handles.axes30,'visible','off')
    set(handles.axes31,'visible','off')
    set(handles.axes32,'visible','off')
    set(handles.axes33,'visible','off')
    set(handles.axes34,'visible','off')
    set(handles.axes35,'visible','off')
    set(handles.axes36,'visible','off') 
    set(handles.axes37,'visible','off')
    set(handles.axes38,'visible','off')
    set(handles.axes39,'visible','off')
    set(handles.axes40,'visible','off')
    set(handles.axes41,'visible','off')
    set(handles.axes42,'visible','off')
    set(handles.axes43,'visible','off')
    set(handles.axes44,'visible','off')
    set(handles.axes45,'visible','off')
    set(handles.axes46,'visible','off')
    set(handles.axes47,'visible','off')
    set(handles.axes48,'visible','off')
    set(handles.axes49,'visible','off')
    set(handles.axes50,'visible','off')
    set(handles.axes51,'visible','off')
    set(handles.axes52,'visible','off')
    set(handles.axes53,'visible','off')
    set(handles.axes54,'visible','off')
    set(handles.axes55,'visible','off')
    set(handles.axes56,'visible','off')
    set(handles.axes57,'visible','off')
    set(handles.axes58,'visible','off')
    set(handles.axes59,'visible','off')
    set(handles.axes60,'visible','off')
    set(handles.axes61,'visible','off')
    set(handles.axes62,'visible','off')
    set(handles.axes63,'visible','off')
    set(handles.axes64,'visible','off')
    set(handles.axes65,'visible','off')
    set(handles.axes66,'visible','off')
    set(handles.axes67,'visible','off')
    set(handles.axes68,'visible','off')
    set(handles.axes69,'visible','off')
    set(handles.axes70,'visible','off')
    set(handles.axes71,'visible','off')
    set(handles.axes72,'visible','off')
    set(handles.axes73,'visible','off')
    set(handles.axes74,'visible','off')
    set(handles.axes75,'visible','off')
    set(handles.axes76,'visible','off')
    set(handles.axes77,'visible','off')
    set(handles.axes78,'visible','off')
    set(handles.text11,'visible','off')
    set(handles.text12,'visible','off')
    set(handles.text13,'visible','off')
    set(handles.text14,'visible','off')
    set(handles.text15,'visible','off')
    set(handles.text16,'visible','off')
    set(handles.uipanel369,'visible','off')
    set(handles.uipanel370,'visible','off')
    set(handles.uipanel371,'visible','off')
    set(handles.uipanel372,'visible','off')
    set(handles.uipanel373,'visible','off')
    set(handles.uipanel374,'visible','off')
%     set(handles.axes79,'visible','off')        
%     set(handles.axes2_plot_images,'visible','off') 
set(handles.uipanel2,'visible','on')
    set(handles.clear_all,'visible','on')
    set(handles.browse_raw_files,'visible','on')
    set(handles.editbox_raw_files,'visible','on')
    set(handles.browse_matrix_file,'visible','on')
    set(handles.editbox_matrix,'visible','on')
    set(handles.linkage_clustering,'visible','on')
    set(handles.text1,'visible','on')
    set(handles.pdf_file_no,'visible','on')
    set(handles.text2,'visible','on')
    set(handles.min_pixel_no,'visible','on')
    set(handles.text3,'visible','on')
    set(handles.static1,'visible','on')
    set(handles.cutoff_value,'visible','on')
    set(handles.text49,'visible','on')
    set(handles.pdist_options,'visible','on')
    set(handles.popupmenu_for_colormap3d,'visible','on')
    set(handles.text50,'visible','on')
    set(handles.linkage_options,'visible','on')
    set(handles.text51,'visible','on')
    set(handles.cluster_options,'visible','on')
    set(handles.cut_off_method,'visible','on')
    set(handles.max_no_clusters,'visible','on')
    set(handles.max_no_clusters_linkage,'visible','on')
    set(handles.clusters_linkage_method,'visible','on')    
    set(handles.uipanel4,'visible','on')
    set(handles.across_aspect_ratio_static,'visible','on')
    set(handles.aspect_ratio_across_edit,'visible','on')
    set(handles.down_aspect_ratio_static,'visible','on')
    set(handles.aspect_ratio_down_edit,'visible','on')
    set(handles.enter_scaling_values,'visible','on')
    set(handles.crop_pdf,'visible','on')
    set(handles.reset_scale_button,'visible','on')    
disp('Done !!!')
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end

function pdf_file_no_Callback(hObject, eventdata, handles)
% hObject    handle to pdf_file_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pdf_file_no as text
%        str2double(get(hObject,'String')) returns contents of pdf_file_no as a double


% --- Executes during object creation, after setting all properties.
function pdf_file_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdf_file_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_pixel_no_Callback(hObject, eventdata, handles)
% hObject    handle to min_pixel_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_pixel_no as text
%        str2double(get(hObject,'String')) returns contents of min_pixel_no as a double


% --- Executes during object creation, after setting all properties.
function min_pixel_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_pixel_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cutoff_value_Callback(hObject, eventdata, handles)
% hObject    handle to cutoff_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cutoff_value as text
%        str2double(get(hObject,'String')) returns contents of cutoff_value as a double


% --- Executes during object creation, after setting all properties.
function cutoff_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cutoff_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cut_off_method.
function cut_off_method_Callback(hObject, eventdata, handles)
% hObject    handle to cut_off_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cut_off_method



function max_no_clusters_linkage_Callback(hObject, eventdata, handles)
global method_linkage pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
g = get(handles.cut_off_method, 'Value');
if g == 1
method_linkage = 1;
end
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end

% --- Executes during object creation, after setting all properties.
function max_no_clusters_linkage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_no_clusters_linkage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clusters_linkage_method.
function clusters_linkage_method_Callback(hObject, eventdata, handles)
global method_linkage pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
g = get(handles.clusters_linkage_method, 'Value');
if g == 1
method_linkage = 2;
end
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end

% --- Executes on button press in clear_all.
function clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
diary off
closeGUI = handles.figure1; %handles.figure1 is the GUI figure

guiName = get(handles.figure1,'Name'); %get the name of the GUI
close(closeGUI); %close the old GUI
guiName = 'Clustering_MSI';
eval(guiName) %call the GUI again
maxfig(gcf,1)
clear all; 
clc;
evalin('base','clear all');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in reset_scale_button.
function reset_scale_button_Callback(hObject, eventdata, handles)
global temp5 pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
set(handles.axes1,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)]) % change axis position
set(handles.axes2,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes3,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes4,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes5,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes6,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes7,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes8,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes9,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes10,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes11,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes12,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes13,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes14,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes15,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes16,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes17,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes18,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes19,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)]) % change axis position
set(handles.axes20,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes21,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes22,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes23,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes24,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes25,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes26,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes27,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes28,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes29,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes30,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes31,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes32,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes33,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes34,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes35,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes36,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes37,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)]) % change axis position
set(handles.axes38,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes39,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes40,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes41,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes42,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes43,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes44,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes45,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes46,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes47,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes48,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes49,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes50,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes51,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes52,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes53,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes54,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes55,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)]) % change axis position
set(handles.axes56,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes57,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes58,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes59,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes60,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes61,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes62,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes63,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes64,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes65,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes66,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes67,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes68,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes69,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes70,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes71,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes72,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes73,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes74,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes75,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes76,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes77,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
set(handles.axes78,'Position',[temp5(1) temp5(2) temp5(3) temp5(4)])
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end


% --- Executes on button press in enter_scaling_values.
function enter_scaling_values_Callback(hObject, eventdata, handles)
global sum_of_intensities temp1 across_val down_val width temp2 changed_aspect_ratio temp5 plot_val image_window_to_display_value pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
% set(handles.intensity_vs_frequency_spectrum_panel, 'visible', 'off');
% set(handles.intensity_vs_time_spectrum_panel, 'visible', 'off');
% set(handles.uipanel11, 'visible', 'off');
% set(handles.panel_enlarged_grayscale_plot, 'visible', 'off');
% set(handles.uipanel110, 'visible', 'off');
% % set(handles.uipanel3, 'visible', 'on');
% % set(handles.uipanel101, 'visible', 'on');
% % set(handles.uipanel102, 'visible', 'on');
% % set(handles.uipanel105, 'visible', 'on');
% set(handles.uipanel109, 'visible', 'on');

if ~isempty(temp2)
    reset_scale_button_Callback(hObject, eventdata, handles)
end
% plot_val = 1;
% if isempty(image_window_to_display_value) 
%     image_window_to_display_value = 1;
% end
%     image_window_to_display_value = 2;
% end
% if image_window_to_display_value == 1
%     cla(handles.zone_specified_plot);
% axes(handles.zone_specified_plot);
% else
%     cla(handles.zone_specified_plot2);
% axes(handles.zone_specified_plot2);
% end
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
set(handles.axes1,'Position',[temp1(1) temp1(2) width temp1(4)]) % change axis position
set(handles.axes2,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes3,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes4,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes5,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes6,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes7,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes8,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes9,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes10,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes11,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes12,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes13,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes14,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes15,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes16,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes17,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes18,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes19,'Position',[temp1(1) temp1(2) width temp1(4)]) % change axis position
set(handles.axes20,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes21,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes22,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes23,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes24,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes25,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes26,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes27,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes28,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes29,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes30,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes31,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes32,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes33,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes34,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes35,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes36,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes37,'Position',[temp1(1) temp1(2) width temp1(4)]) % change axis position
set(handles.axes38,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes39,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes40,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes41,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes42,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes43,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes44,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes45,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes46,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes47,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes48,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes49,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes50,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes51,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes52,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes53,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes54,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes55,'Position',[temp1(1) temp1(2) width temp1(4)]) % change axis position
set(handles.axes56,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes57,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes58,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes59,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes60,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes61,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes62,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes63,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes64,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes65,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes66,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes67,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes68,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes69,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes70,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes71,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes72,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes73,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes74,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes75,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes76,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes77,'Position',[temp1(1) temp1(2) width temp1(4)])
set(handles.axes78,'Position',[temp1(1) temp1(2) width temp1(4)])
else
height = (temp2(4)*(down_val/across_val));%((temp1(3)/down_val)*across_val);
set(handles.axes1,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes2,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes3,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes4,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes5,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes6,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes7,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes8,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes9,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes10,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes11,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes12,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes13,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes14,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes15,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes16,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes17,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes18,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes19,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes20,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes21,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes22,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes23,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes24,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes25,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes26,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes27,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes28,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes29,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes30,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes31,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes32,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes33,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes34,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes35,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes36,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes37,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes38,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes39,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes40,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes41,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes42,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes43,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes44,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes45,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes46,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes47,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes48,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes49,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes50,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes51,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes52,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes53,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes54,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes55,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes56,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes57,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes58,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes59,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes60,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes61,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes62,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes63,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes64,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes65,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes66,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes67,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes68,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes69,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes70,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes71,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes72,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes73,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes74,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes75,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes76,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes77,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
set(handles.axes78,'Position',[temp1(1) temp1(2) temp1(3) height]) % change axis position
end
% if width > temp1(4)
%     temp1(3) = temp1(3)/2;
%     width = ((temp1(3)/down_val)*across_val);
% end
% imagesc(sum_of_intensities); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
changed_aspect_ratio = 1;
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
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


% --- Executes on button press in crop_pdf.
function crop_pdf_Callback(hObject, eventdata, handles)
% hObject    handle to crop_pdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
system('"C:\vis_xcalibur_raw_files\pdfscissors-offline.jnlp"')


% --- Executes on selection change in pdist_options.
function pdist_options_Callback(hObject, eventdata, handles)
% hObject    handle to pdist_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pdist_option pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
contents = cellstr(get(hObject,'String'));
pdist_option = contents{get(hObject,'Value')};
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end
% Hints: contents = cellstr(get(hObject,'String')) returns pdist_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pdist_options


% --- Executes during object creation, after setting all properties.
function pdist_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdist_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in linkage_options.
function linkage_options_Callback(hObject, eventdata, handles)
% hObject    handle to linkage_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global linkage_option pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
contents = cellstr(get(hObject,'String'));
linkage_option = contents{get(hObject,'Value')};
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end

% --- Executes during object creation, after setting all properties.
function linkage_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linkage_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cluster_options.
function cluster_options_Callback(hObject, eventdata, handles)
% hObject    handle to cluster_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cluster_option pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
contents = cellstr(get(hObject,'String'));
cluster_option = contents{get(hObject,'Value')};
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end

% --- Executes during object creation, after setting all properties.
function cluster_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cluster_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_for_colormap3d.
function popupmenu_for_colormap3d_Callback(hObject, eventdata, handles)
global colormap_3d number_of_matrixes_to_open pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
Format = get(hObject, 'String');
colormap3d_value = get(hObject, 'Value');
colormap_3d = Format(colormap3d_value);
colormap_3d = char(colormap_3d(1,1));
% if number_of_matrixes_to_open > 1
%                 cmap = [hot;jet];
%                 colormap(cmap)
% end
colormap(flipud(colormap_3d));
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
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



function number_of_matrixes_Callback(hObject, eventdata, handles)
% hObject    handle to number_of_matrixes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number_of_matrixes as text
%        str2double(get(hObject,'String')) returns contents of number_of_matrixes as a double


% --- Executes during object creation, after setting all properties.
function number_of_matrixes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number_of_matrixes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in align_images.
function align_images_Callback(hObject, eventdata, handles)
global align_images_val pathname
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
align_images_val = get(hObject,'Value');
diary off
catch MExc
%     disp(MExc)
disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end