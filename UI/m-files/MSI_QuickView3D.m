function varargout = MSI_QuickView3D(varargin)
% MSI_QUICKVIEW3D MATLAB code for MSI_QuickView3D.fig
%      MSI_QUICKVIEW3D, by itself, creates a new MSI_QUICKVIEW3D or raises the existing
%      singleton*.
%
%      H = MSI_QUICKVIEW3D returns the handle to a new MSI_QUICKVIEW3D or the handle to
%      the existing singleton*.
%
%      MSI_QUICKVIEW3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSI_QUICKVIEW3D.M with the given input arguments.
%
%      MSI_QUICKVIEW3D('Property','Value',...) creates a new MSI_QUICKVIEW3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MSI_QuickView3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MSI_QuickView3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MSI_QuickView3D

% Last Modified by GUIDE v2.5 24-Apr-2013 10:29:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MSI_QuickView3D_OpeningFcn, ...
                   'gui_OutputFcn',  @MSI_QuickView3D_OutputFcn, ...
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


% --- Executes just before MSI_QuickView3D is made visible.
function MSI_QuickView3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MSI_QuickView3D (see VARARGIN)

% Choose default command line output for MSI_QuickView3D
handles.output = hObject;
set(handles.output,'Name',['MSI QuickView 3D Visualization GUI']);%['MSI QuickView 3D Visualization GUI  v' '0.001']);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MSI_QuickView3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MSI_QuickView3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
maxfig(gcf,1)

% --- Executes on button press in load_optical_image_and_register.
function load_optical_image_and_register_Callback(hObject, eventdata, handles)
% hObject    handle to load_optical_image_and_register (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% addpath('C:\vis_xcalibur_raw_files')
load_optical_image_and_transform_to_3d_slices


% --- Executes on button press in load_mat_file.
function load_mat_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_mat_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cdata J2 x4
if isempty(J2)
[FileName2,PathName2] = uigetfile('*.mat','Select transformed optical image for dataset');
x4 = load([PathName2 FileName2]);
%x4 = flipud(rgb2gray(x5));    
x4 = x4.J2;
J2 = x4;
end
%load optical image
% [FileName2,PathName2] = uigetfile('*.tif','Select optical image for dataset');
% x5 = imread([PathName2 FileName2]);
% x4 = flipud(rgb2gray(x5));
optical_img_width = size(x4,2);
optical_img_height = size(x4,1);
%
if isempty(cdata)
[FileName,PathName] = uigetfile('*.mat','Select the MAT file for specific m/z');
cdata = load([PathName FileName]);
cdata = cdata.sum_of_intensities;
end
%
%imresize(x4, [size(cdata,1),size(cdata,2)]);


% --- Executes on button press in crop_slices.
function crop_slices_Callback(hObject, eventdata, handles)
% hObject    handle to crop_slices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global J2
threed_manual_registration(J2)

% --- Executes on button press in register_slices.
function register_slices_Callback(hObject, eventdata, handles)
% hObject    handle to register_slices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
threed_manual_rotation


% --- Executes on button press in crop_and_register_auto.
function crop_and_register_auto_Callback(hObject, eventdata, handles)
% hObject    handle to crop_and_register_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cdata
%% AUTOMATIC MODE
%% Call Cropping Tool
threed_manual_registration_auto(cdata)
%% Rotate Image
threed_manual_rotation_auto


% --- Executes on button press in generate_3d_matrix_from_2d_slices.
function generate_3d_matrix_from_2d_slices_Callback(hObject, eventdata, handles)
% hObject    handle to generate_3d_matrix_from_2d_slices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sd3
sd3 = generate_3d_matrix_from_2d_slices;


% --- Executes on button press in clear_all.
function clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_dir = pwd;
closeGUI = handles.figure1; %handles.figure1 is the GUI figure

guiName = get(handles.figure1,'Name'); %get the name of the GUI
close(closeGUI); %close the old GUI
guiName = 'MSI_QuickView3D';
eval(guiName) %call the GUI again
maxfig(gcf,1)
% h = waitbar(0.25,'Loading Fiji/ImageJ Settings...'); 
% if ~isdeployed
% addpath(genpath(current_dir));
% Miji(false)
% else
% Miji(false)   
% end
% close(h)
clear all; 
clc;
evalin('base','clear all');
if ~exist('C:\threed_trial_images','dir')
   mkdir('C:\threed_trial_images') 
end


% --- Executes on button press in create_rect.
function create_rect_Callback(hObject, eventdata, handles)
% hObject    handle to create_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h2 position2 J2
figure(1);imagesc(J2); %colormap(strcat('hot','(32)'));
h2 = imrect;
position2 = wait(h2);
choice = questdlg('Save Rectangle Coordinates?', ...
	'User Input', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
%     uu = uigetdir;
    save(['C:\threed_trial_images\POSITION.mat'],'position2')
    case 'No'
    return;
end


% --- Executes on button press in enter_scaling_limits.
function enter_scaling_limits_Callback(hObject, eventdata, handles)
% hObject    handle to enter_scaling_limits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global clims1 clims2
prompt = {'Lower Limit to scale image:', 'Upper Limit to scale image:'};
dlg_title = 'Input';
num_lines = 1;
def = {'1','100'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
clims1 = str2num(answer{1,1});
clims2 = str2num(answer{2,1});
