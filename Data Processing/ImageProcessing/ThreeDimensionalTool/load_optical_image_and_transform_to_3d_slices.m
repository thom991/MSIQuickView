function load_optical_image_and_transform_to_3d_slices
global J2 x4 cdata clims1 clims2
if exist('C:\threed_trial_images\optical_image_registered.mat','file')
choice2 = questdlg('File already exists, do you want to proceed?', ...
	'User Input', ...
	'Yes','No','Yes');
% Handle response
switch choice2
    case 'Yes'
if isempty(clims1)
    clims1 = 1;
    clims2 = 100;
    clims = [clims1 clims2];
else
    clims = [clims1 clims2];
end
%% load optical image
[FileName2,PathName2] = uigetfile('*.tif','Select optical image for dataset');
x5 = imread([PathName2 FileName2]);
x4 = flipud(rgb2gray(x5));
optical_img_width = size(x4,2);
optical_img_height = size(x4,1);

[FileName,PathName] = uigetfile('*.mat','Select the MAT file for specific m/z');
cdata = load([PathName FileName]);
cdata = cdata.sum_of_intensities;
ion_img_width = size(cdata,2);
ion_img_height = size(cdata,1);

x6 = imresize(x4, [size(cdata,1),size(cdata,2)]);
    figure(1);
    subplot(2,1,1); imagesc(cdata, clims); %colormap(hot)
    subplot(2,1,2); imagesc(x6); %colormap(strcat('hot','(32)'));    
    [x,y] = ginput;
    x_org = x(1:2:end);
    x_mod = x(2:2:end);
    y_org = y(1:2:end);
    y_mod = y(2:2:end);
    org_pts = [x_org,y_org];
    mod_pts = [x_mod,y_mod];
%     original_pts.(['val' num2str(1)]) = org_pts;
%     modified_pts.(['val' num2str(1)]) = mod_pts;
TFORM = cp2tform(mod_pts, org_pts, 'similarity');
[rows cols]=size(cdata);
% Define the location of the image in the output space
xd = [1 cols];
yd = [1 rows];
% xys = [1 1];
J2 = imtransform(x6,TFORM, 'Xdata', xd, 'Ydata', yd);%, 'XYScale', xys);
J2(J2 == 0) = 254;
figure(2);imagesc(J2);%colormap(strcat('hot','(32)'));
sum_of_intensities = double(J2);%+(x6*8);
figure(3);
subplot(2,1,1); imagesc(double(J2)+(cdata*8));%colormap('hot');%strcat('hot','(32)'));
subplot(2,1,2); imagesc(double(J2));%colormap('hot');%strcat('hot','(32)'));
choice = questdlg('Save Transformed Optical Image as MAT file ?', ...
	'User Input', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
save('C:\threed_trial_images\optical_image_registered.mat','J2')
saveastiff(single(J2), ['C:\Users\thom991\Desktop\TiffTrial\Optical_Image_Registered.tif'])
    case 'No'
    return;
end
    case 'No'
    return;
end
else
if isempty(clims1)
    clims1 = 1;
    clims2 = 100;
    clims = [clims1 clims2];
else
    clims = [clims1 clims2];
end
%% load optical image
[FileName2,PathName2] = uigetfile('*.tif','Select optical image for dataset');
x5 = imread([PathName2 FileName2]);
x4 = flipud(rgb2gray(x5));
optical_img_width = size(x4,2);
optical_img_height = size(x4,1);

[FileName,PathName] = uigetfile('*.mat','Select the MAT file for specific m/z');
cdata = load([PathName FileName]);
cdata = cdata.sum_of_intensities;
ion_img_width = size(cdata,2);
ion_img_height = size(cdata,1);

x6 = imresize(x4, [size(cdata,1),size(cdata,2)]);
    figure(1);
    subplot(2,1,1); imagesc(cdata, clims); %colormap(hot)
    subplot(2,1,2); imagesc(x6); %colormap(strcat('hot','(32)'));    
    [x,y] = ginput;
    x_org = x(1:2:end);
    x_mod = x(2:2:end);
    y_org = y(1:2:end);
    y_mod = y(2:2:end);
    org_pts = [x_org,y_org];
    mod_pts = [x_mod,y_mod];
%     original_pts.(['val' num2str(1)]) = org_pts;
%     modified_pts.(['val' num2str(1)]) = mod_pts;
TFORM = cp2tform(mod_pts, org_pts, 'similarity');
[rows cols]=size(cdata);
% Define the location of the image in the output space
xd = [1 cols];
yd = [1 rows];
% xys = [1 1];
J2 = imtransform(x6,TFORM, 'Xdata', xd, 'Ydata', yd);%, 'XYScale', xys);
J2(J2 == 0) = 254;
figure(2);imagesc(J2);%colormap(strcat('hot','(32)'));
sum_of_intensities = double(J2);%+(x6*8);
figure(3);
subplot(2,1,1); imagesc(double(J2)+(cdata*8));%colormap('hot');%strcat('hot','(32)'));
subplot(2,1,2); imagesc(double(J2));%colormap('hot');%strcat('hot','(32)'));
choice = questdlg('Save Transformed Optical Image as MAT file ?', ...
	'User Input', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
save('C:\threed_trial_images\optical_image_registered.mat','J2')
saveastiff(single(J2), ['C:\Users\thom991\Desktop\TiffTrial\Optical_Image_Registered.tif'])
    case 'No'
    return;
end    
end