function ROI_points_to_Ion_Images(load_image, save_to_single_file, cdata)
%% Author : Mathew Thomas
% Date : March 28, 2016
% function to execute analysis on a list of images (all mat files) within a
% dataset folder. User can chose an excel file containing a list of
% datasets to use for repeating the pipeline.
    global datasets_list
    load_image = true;
    useDefault = true;
    return_err = false;
    if load_image; cdata = load_image_file(useDefault); end
    
%%    
    % Construct a questdlg with three options
    % #) Open an existing excel sheet containing datasets to use
    % #) Create a new list of datasets file
    if ~useDefault
        choice = questdlg('Select existing list / Create new list', ...
            'Please Select', ...
            'Select existing file','Pick new datasets','Cancel','Cancel');
    else
        choice = 'Select existing file';
    end
        % Handle response
        switch choice
            case 'Select existing file'
                fprintf('Selecting an existing file with Dataset list\n');
                load_excel_file_containing_dataset_list(useDefault);
            case 'Pick new datasets'
                fprintf('Select all datasets you wish to include in the pipeline\n') 
                handles = select_multiple_datasets(pathname, handles, false);
                fprintf('Done saving list of datasets\n');
            case 'Cancel'
                fprintf('No selections made')
        end   
%%    
    % Construct a questdlg with three options
    % #) Open an existing mat file containing ROIs generated
    % #) Create new ROIs
    if~useDefault
        choice2 = questdlg('Select existing ROI list / Create new ROI list', ...
            'Please Select', ...
            'Select existing ROI mat file','Draw ROI(s)','Cancel','Cancel');
    else
        choice2 = 'Select existing ROI mat file'; 
    end
    % Handle response
    switch choice2
        case 'Select existing ROI mat file'
            fprintf('Selecting an existing file with ROI List\n');
            [roiList, val] = load_ROI_file(useDefault, cdata, false); 
        case 'Draw ROI(s)'
            fprintf('Drawing new ROI(s)\n');
            drawROIs()
        case 'Cancel'
            fprintf('No selections made')
    end    
%%
    % Checking before hand if size of all datasets match with the selected
    % ROIs, and if it does not match, generate a list of all the datasets
    % that fail
    sizeUnmatchList = {};
    return_err_final = false;
    for i = 1:numel(datasets_list)
        cur_dataset = datasets_list{i,1};
        mat_list = dir([cur_dataset filesep 'Images' filesep '*.mat']);
        fprintf('Currently working on dataset %s of %s - Dataset Name : %s. \n', num2str(i), num2str(numel(datasets_list)), cur_dataset);
        for j = 1:numel(mat_list)
            tempName = load([cur_dataset filesep 'Images' filesep mat_list(1).name]);
            auto_match = true;
            userRoiNames = fieldnames(roiList);
            if auto_match; tempName.sum_of_intensities = rand(size(roiList.(userRoiNames{1}))); end
            return_err = check_ROI_size_with_image(tempName.sum_of_intensities, roiList, 1);
            if return_err; 
                return_err_final = true;
                sizeUnmatchList{numel(sizeUnmatchList)+1} = cur_dataset;
                break;
            else
                fprintf('Size match for dataset %s of %s - Dataset Name : %s. \n', num2str(i), num2str(numel(datasets_list)), cur_dataset);
%                 roiMarkedImages = continue_processing(auto_match, userRoiNames);
            end
        end
%         if return_err; break; end;
    end
    if return_err;
        msgbox(['Sizes of ROI and Image did not match for ' num2str(numel(sizeUnmatchList)) ' dataset(s).'], 'Error','error'); 
        fprintf('Sizes did not match for following dataset(s):\n');
        disp(sizeUnmatchList);
        api = config_file;
        saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
        save([cur_dataset filesep saveTempFilesToFolder filesep 'ROI_Unmatch_List.mat'],'sizeUnmatchList')
    end
%%    
    if ~return_err_final;
        % Size match, so now proceeding with the processing for each
        % dataset and image...
        roiMarkedImages = struct;
        for i = 1:numel(datasets_list)
            cur_dataset = datasets_list{i,1};
            mat_list = dir([cur_dataset filesep 'Images' filesep '*.mat']);
            fprintf('Currently working on dataset %s of %s - Dataset Name : %s. \n', num2str(i), num2str(numel(datasets_list)), cur_dataset);
            for j = 1:numel(mat_list)
                tempName = load([cur_dataset filesep 'Images' filesep mat_list(j).name]);
                userRoiNames = fieldnames(roiList);
                roiMarkedImages = continue_processing(auto_match, userRoiNames, roiMarkedImages, j);
                if ~save_to_single_file
                    if ~exist([cur_dataset filesep 'ROI_Images'],'dir'); mkdir([cur_dataset filesep 'ROI_Images']);end
                    save([cur_dataset filesep 'ROI_Images' filesep mat_list(j).name],'roiMarkedImages'); 
                    clearvars roiMarkedImages; 
                    roiMarkedImages = struct;
                end
            end
        end
        if save_to_single_file
            save([cur_dataset filesep 'roiMarkedImages.mat'],'roiMarkedImages'); 
        end
        
    end
%%    
    % All checks passed, now starting the processing for each dataset and
    % image
    function roiMarkedImages = continue_processing(auto_match, userRoiNames, roiMarkedImages, j)
        fprintf('The size checks for all datasets passed, so proceeding with actual processing for all the datasets.\n');   
        if auto_match; tempName2.sum_of_intensities = rand(size(roiList.(userRoiNames{1}))); end
        new_imageName = getImageName(mat_list(j).name);
        roiMarkedImages = applyAlgOnImage(userRoiNames, roiList, tempName2.sum_of_intensities, new_imageName, roiMarkedImages);
        fprintf('Done saving ROI(s) for Dataset(s).\n');
    end

    function new_imageName = getImageName(imageName)
        new_imageName = strrep(imageName, ' ', '_');
        new_imageName = strrep(new_imageName, '.', 'd');
        new_imageName = new_imageName(1:30);        
    end

    function roiMarkedImages = applyAlgOnImage(userRoiNames, roiList, sum_of_intensities, imageName, roiMarkedImages)  
        for eachRoi = 1:length(fieldnames(roiList))
            roiMarkedImages.(imageName).(userRoiNames{eachRoi}) = (roiList.(userRoiNames{eachRoi})).*sum_of_intensities;
        end
    end
    
%%    
    function cdata = load_image_file(useDefault)
        fprintf('Loading image file to use for ROI selection\n')
        cdata = load_imageFile(useDefault, 'User Input - Please Select the Single Image file to draw ROIs on.\n', [pwd filesep 'Images' filesep], 'sameSizeImage.png');
    end

end