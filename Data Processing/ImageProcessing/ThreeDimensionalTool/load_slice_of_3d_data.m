function load_slice_of_3d_data
%% Selecting mz mat file
global cdata J2 x4

%load optical image
[FileName2,PathName2] = uigetfile('*.tif','Select optical image for dataset');
x5 = imread([PathName2 FileName2]);
x4 = flipud(rgb2gray(x5));
optical_img_width = size(x4,2);
optical_img_height = size(x4,1);
%
[FileName,PathName] = uigetfile('*.mat','Select the MAT file for specific m/z');
cdata = load([PathName FileName]);
cd = cdata.sum_of_intensities;
%
cdata = imresize(cd, [size(x4,1),size(x4,2)]);
%
auto_mode = 2;
%%
if auto_mode == 1
%% MANUAL MODE
%% Call Cropping Tool
threed_manual_registration(cdata)
%% Rotate Image
threed_manual_rotation
elseif auto_mode == 2
%% AUTOMATIC MODE
%% Call Cropping Tool
threed_manual_registration_auto(cdata)
%% Rotate Image
threed_manual_rotation_auto
end

%% Load the slices and generate 3d object
%sd3 = generate_3d_matrix_from_2d_slices(maxi,max_x,max_y,max_z)
sd3 = generate_3d_matrix_from_2d_slices;



