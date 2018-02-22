function [TFORM, transformedImage, transformedImageDetails, opticalImage,  ImgPathname, ImgFilename] = register_OpticalImage_with_IonImage(useDefault, useDefaultPts, opticalImage, ionImage)
%% Author : Mathew Thomas
% Date : March 28, 2016
% function to register an image (e.g., optical image) with another image (e.g., ion image))
% Save all intermediarry step results

% Usage:
% [TFORM, transformedImage, transformedImageDetails, opticalImage,  ImgPathname, ImgFilename] = register_OpticalImage_with_IonImage(true, use_default_ginput, '', '');
    if useDefault;
        [opticalImage, ImgPathname, ImgFilename] = load_imageFile(true, 'User Input - Please Select the Optical Image / Image you would draw ROI on.\n', [pwd filesep 'registrationExample' filesep], 'Animal1_lung1_slide6 after imaging-cropped.tif');
        [ionImage, ~, ~] = load_imageFile(true, 'User Input - Please Select the Ion Image (the optical image will be warped to the ion image size).\n', [pwd filesep 'registrationExample' filesep], 'mz221.1116_221.1116_Cropped.png');
    end
    if ~useDefaultPts;
        figure;
        subplot(2,1,1); imagesc(opticalImage);
        subplot(2,1,2); imagesc(ionImage);    
        [x,y] = ginput;
    else
        load([pwd filesep 'registrationExample' filesep 'transformedImageDetails.mat'])
        x = transformedImageDetails.x;
        y = transformedImageDetails.y;
    end
    x_org = x(1:2:end);
    x_mod = x(2:2:end);
    y_org = y(1:2:end);
    y_mod = y(2:2:end);
    org_pts = [x_org,y_org];
    mod_pts = [x_mod,y_mod];
    TFORM = fitgeotrans(org_pts, mod_pts,'affine');
    transformedImage = imwarp(opticalImage,TFORM,'OutputView',imref2d(size(ionImage)));
    fusedImage = imfuse(ionImage,transformedImage, 'falsecolor','Scaling','independent');
    figure;   
    subplot(2,3,1); imshow(ionImage); text(x_mod,y_mod,'+', ...
                'HorizontalAlignment','center', ...
                'Color', [1 0 0], ...
                'FontSize',14); 
    subplot(2,3,2); imshow(opticalImage); text(x_org,y_org,'+', ...
                'HorizontalAlignment','center', ...
                'Color', [1 0 0], ...
                'FontSize',14); 
    subplot(2,3,3); imshow(transformedImage);    
    subplot(2,3,4); imshow(fusedImage,'InitialMagnification','fit');
    subplot(2,3,5); imshowpair(ionImage,transformedImage,'montage');
    subplot(2,3,6); imshowpair(ionImage,transformedImage,'blend');
    export_fig([pwd filesep 'registrationExample' filesep 'registrationDetails.png']);
    transformedImageDetails.x = x;
    transformedImageDetails.y = y;
    transformedImageDetails.transformedImage = transformedImage;
    save([pwd filesep 'registrationExample' filesep 'transformedImageDetails.mat'], 'transformedImageDetails');
    imwrite(transformedImage, [pwd filesep 'registrationExample' filesep 'RegisteredImage.png']);
end