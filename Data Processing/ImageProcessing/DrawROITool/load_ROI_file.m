function [roiList, val] = load_ROI_file(useDefault, cdata, check)
%% Author : Mathew Thomas
% Date : March 28, 2016
% function to load existing file containing all pre-saved roi values. The
% file is saved with the name roiList.mat. It contains a struct file with
% a field for each user defined ROI, for e.g.,
% ROI1 : image (400X301)
% ROI2 : image (400X301)
% ROI3 : image (400X301)

% User also has the option to check if the sizes of the ROI list and input
% images match. If match fails, the program will stop and exit with a
% warning.

% User can also chose to use default file containing ROI struct, loaded by
% default
    if ~useDefault
        [filename_ROI, pathname_ROI] = ...
            uigetfile({'*.mat'},'Select mat-file with roi List, filename ends with roiList.mat..');
    else
       filename_ROI = 'roiList.mat';
       pathname_ROI = [pwd filesep 'Test Data' filesep];
    end
    load([pathname_ROI filename_ROI])
    userRoiNames = fieldnames(roiList);
    if check; val = check_size(roiList, userRoiNames, cdata); else val=false; end
    
    function [val] = check_size(roiList, userRoiNames, cdata)
        mRoi = size(roiList.(userRoiNames{1,1}),1);
        nRoi = size(roiList.(userRoiNames{1,1}),2);
        mImage = size(cdata,1);
        nImage = size(cdata,2);
        if (mRoi == mImage) && (nRoi == nImage)
            fprintf('Sizes of loaded roiList and Selected image match, so moving on.\n')
            val = false;
        else
            val = true;
            fprintf('Sizes of loaded image and previous ROI List do not match, please try again.\n')
            warndlg('Sizes of loaded image and previous ROI List do not match, please try again','!! Error !!')
        end        
    end
end