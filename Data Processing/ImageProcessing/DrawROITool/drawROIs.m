function [break_val] = drawROIs(useDefault, msg, ImgPathname, ImgFilename, cdata, break_val, use_default_ginput)
%% Author : Mathew Thomas
% Date : March 17, 2016
% Description: This function is for the LungMAP project to address the following issues:
% (#) Load an ion image (optical) and draw ROIs, similar to an ATLAS.
% (#) Be able to see and save the marked images and ROI points. 
% (#) Overwrite previously marked ROIs.
% (#) Register the optical image with actual ion images generated from MSI
%     QuickView.
%% Clearing memory
% clear all
% clc
addpath(genpath(pwd))
%% 
% (#) Load the optical/ion image on which to draw the ROIs.
% (#) Ask user if they want to continue from where they left off and
%     continue marking ROIs on same image
% (#) UnitTest: make sure the sizes of the optical images and
%     previously save roiList matches.

% IMPORTANT: ROI names cannot start with numbers or contain spaces
if isempty(cdata)
    [cdata, ~, ~]  = load_imageFile(useDefault, msg, ImgPathname, ImgFilename);
end
choice = menu('Upload existing ROI masks?','Yes','No');
while(1)
    if choice==1
        [roiList, break_val] = load_ROI_file(useDefault, cdata, true);
        if break_val || use_default_ginput || ~use_default_ginput; break_val = true; break; end
    elseif choice ==2 || choice ==0
        break;
    end
end
if ~break_val 
fprintf('Displaying user selected image.\n')
figure; imshow(cdata);
%% 
% (#) Capture user input for ROI name, numbering is by default (fixed)
%     incrementally.
% (#) If the same ROI name is used, previously saved ROI is overwritten.
% (#) User has to double click after drawing on the ROI image to save the ROI.
% (#) Ask user if they want to save another ROI, save data and exit if user
%     says no.
fprintf('User Input - Give the ROI a name, it is given a default value')
answer = userInput('Enter',num2str(1));
totMask = false( [size(cdata,1), size(cdata,2)] ); % accumulate all single object masks to this one
h = imfreehand( gca ); setColor(h,'red');
position = wait( h );
BW = createMask( h );
count = 2;
while(1)
    totMask = totMask | BW; % add mask to global mask
    delete( h ); % try the effect of this line if it helps you or not.
    totMask2 = double(BW);
    totMask2(totMask2==1) = count*10;
    roiList.(answer{1,1}) = totMask2;
    choice = menu('Select another ROI?','Yes','No');
    if choice==2 || choice==0
        break;
    end
    answer = userInput('Enter',num2str(count));
    % ask user for another mask
    h = imfreehand( gca ); setColor(h,'red');
    position = wait( h );
    BW = createMask( h );
    count = count + 1;
    
end
% show the resulting mask
figure; imshow( totMask ); title('multi-object mask');
roiImage = zeros(size(cdata,1), size(cdata,2), 'single');
userRoiNames = fieldnames(roiList);
for i = 1:length(fieldnames(roiList))
    roiImage = roiImage + roiList.(userRoiNames{i});
end
%%
% (#) User is done drawing ROIs.
% (#) Ask user to pick folder to save files.
% (#) Save roiList struct file containing the roi values, where struct
%     names are the roi names inputted by the user.
% (#) Save 2 images with all marked ROIs, (1) Not annotated (rois.png), (2) Annotated (roisLabelled.png) 
fprintf('Asking user to select location to save files. \n')
folder_name = uigetdir(pwd, 'Select Directory to Save Data');
fprintf('Files will be saved to %s \n', folder_name);
fprintf('Saving struct with roi values...\n');
save([folder_name filesep 'roiList.mat'], 'roiList')
h3= figure;imoverlay(cdata,roiImage, [], [], 'jet', 0.6, gca);%imagesc(roiImage);
%tim = getframe(h3);
fprintf('Saving roi image...\n')
export_fig([folder_name filesep 'rois.png'], '-native');
%imwrite(tim.cdata,[folder_name filesep 'rois.png'])
hold on
for i = 1:length(fieldnames(roiList))
    [m,n] = find(roiList.(userRoiNames{i}) > 0);
    m1 = m(round(numel(m)/2));
    n1_avg = round((min(n(:))+max(n(:)))/2);
    m1_avg = round((min(m(:))+max(m(:)))/2);
    n1 = n(round(numel(n)/2));
    text('units','data','position',[n1_avg m1_avg],'fontsize',6,'HorizontalAlignment', 'center', 'string',userRoiNames{i})
end
hold off
%tim = getframe(gca);
fprintf('Saving annotated roi image...\n');
export_fig([folder_name filesep 'roisLabelled.png'], '-native');
%imwrite(tim.cdata,[folder_name filesep 'roisLabelled.png'])
end
