function varargout = MSI_QuickView(varargin)
%% Author: Mathew Thomas
% This is the landing page for MSI QuickView. The UI shows all of the
% available capabilities within the software.

%%

% MSI_QUICKVIEW MATLAB code for MSI_QuickView.fig
%      MSI_QUICKVIEW, by itself, creates a new MSI_QUICKVIEW or raises the existing
%      singleton*.
%
%      H = MSI_QUICKVIEW returns the handle to a new MSI_QUICKVIEW or the handle to
%      the existing singleton*.
%
%      MSI_QUICKVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSI_QUICKVIEW.M with the given input arguments.
%
%      MSI_QUICKVIEW('Property','Value',...) creates a new MSI_QUICKVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MSI_QuickView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MSI_QuickView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MSI_QuickView

% Last Modified by GUIDE v2.5 01-Jul-2016 12:07:57

% Begin initialization code - DO NOT EDIT
%Add all folders/sub-folders within MSIQuickView to the path
if ispc
    if ~isdeployed
        addpath(genpath('pwd'))
        javaaddpath(genpath('pwd'))
    end
end
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MSI_QuickView_OpeningFcn, ...
                   'gui_OutputFcn',  @MSI_QuickView_OutputFcn, ...
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


% --- Executes just before MSI_QuickView is made visible.
function MSI_QuickView_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MSI_QuickView (see VARARGIN)
global pathname2 bee mat_file_name 
% Checking License
expiryDate = '2020-12-31';

if now > datenum(expiryDate)
    h = errordlg('License has expired.','Error');
    uiwait(h)
    error('Licence needs to be updated.')
end
% Choose default command line output for MSI_QuickView
if 1==1
    disp('GUIstarted'); %tells the Splash screen that everything is ok and it may close.
else
    disp ('GUIerror'); %tells the Splash screen that something went wrong and it should close.
end
handles.output = hObject;
% Update handles structure
axes(handles.axes1)
x1 = imread(['Images' filesep 'Capture100.png']);
image(x1); axis off
if isdeployed
    if ~isempty(varargin)
    [~,nameOfFile,fileExt] = fileparts(varargin{1});
    nameOfExe=[nameOfFile,fileExt];
    dosCmd = ['taskkill /f /im "' nameOfExe '"'];
    dos(dosCmd); 
    end
 
end
% addpath([pwd filesep 'colormaps']);
set(handles.output,'Name','MSI QuickView_GUI');%['MSI QuickView v' '0.001' '   '  'Chemical Imaging Initiative, PNNL']);
guidata(hObject, handles);
ee = varargin;
% save('C:\Anum_Thesis\ee2.mat','ee');
if (size(ee,2) >= 2) && ~isempty(ee{1,2})
%     command_line_name = varargin(1);
%     pathname2 = command_line_name{1,1};
%     set(handles.text2,'string',pathname2);
bee = varargin;
%%
ee = varargin;
t = strread(ee{2},'%s'); %#ok<DSTRRD>
if strcmp(t{1,1},'-p') 
    pathname2 = t{2,1};    
elseif strcmp(t{1,1},'-c')
    mat_file_name = t{2,1};
end
if size(t,1) > 2
if strcmp(t{3,1},'-c') 
    mat_file_name = t{4,1};
elseif strcmp(t{3,1},'-p') 
    pathname2 = t{4,1};    
end
end
%%
% C = bee;
% IndexC = strfind(C, '-c');
% Index = find(not(cellfun('isempty', IndexC)));    
% if ~isempty(Index)
% mat_file_name = bee{1,Index+1};
% end
% IndexC = strfind(C, '-p');
% Index = find(not(cellfun('isempty', IndexC)));    
% if ~isempty(Index)
% pathname2 = bee{1,Index+1};
set(handles.text2,'string',pathname2);
% end
end

% UIWAIT makes MSI_QuickView wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MSI_QuickView_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in real_time_gui.
function real_time_gui_Callback(~, ~, ~)
% hObject    handle to real_time_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% gui_for_brain_raw_files
global applicationName
MSI_QuickView_Real_Time_Visualization_GUI
applicationName = 'Real-Time Visualization Tool';

% --- Executes on button press in scrolling_gui.
function scrolling_gui_Callback(~, ~, ~)
% hObject    handle to scrolling_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% MSI_QuickView_LoadMatrix
MSI_QuickView_Scrolling_GUI

% --- Executes on button press in clustering_gui.
function clustering_gui_Callback(~, ~, ~)
% hObject    handle to clustering_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Clustering_MSI
% MSI_QuickView_Clustering_GUI

% --- Executes on button press in threed_gui.
function threed_gui_Callback(~, ~, ~)
% hObject    handle to threed_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MSI_QuickView3D


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, ~, ~)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1
axes(hObject)
x1 = imread('capture100.png');
image(x1); axis off

% --- Executes on button press in drawROI.
function drawROI_Callback(~, ~, ~) %#ok<*DEFNU>
fprintf('Opening Tool to draw ROIs on actual ion images / optical images')
%Descriptions are here: C:\MSIQuickView_code_GIT\Tool
%Descriptions\RoiTool.docx
drawROIs()
