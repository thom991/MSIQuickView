function ROI_Pipeline_Test(use_default_ginput)
%% Author : Mathew Thomas
% Date : March 28, 2016
% This is a function to test the ROI pipeline which comprises of the
% following steps:
% #) Register optical image to the size of the ion image
% #) Draw ROIs on registered image
% #) Do necessary analysis on ROIs
% #) Save all intermediarry data

% Usage:
% ROI_Pipeline_Test(true)
% ROI_Pipeline_Test(false)
% true or false here meains to or not to use pre-saved ginput user click x
% and y values

%%
%% #) Register optical image to the size of the ion image
    [TFORM, transformedImage, transformedImageDetails, opticalImage,  ImgPathname, ImgFilename] = register_OpticalImage_with_IonImage(true, use_default_ginput, '', '');
%% #) Draw ROIs on registered image
    [flag] = drawROIs(false, 'msg', ImgPathname, ImgFilename, transformedImage, false, use_default_ginput);
%% #) Do necessary analysis on ROIs    
    if ~flag || use_default_ginput || ~use_default_ginput; ROI_points_to_Ion_Images(false, false, transformedImage); end    
end