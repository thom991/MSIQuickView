function [ion_image] = generate_ion_image_from_hdf(low_mz, high_mz, arrayOfHdfFileNames)
%% Description
%This function will generate a single ion image from a list of HDF files, given the lower and upper limits for m/z values.
%% Required Inputs:
% (1) arrayOfHdfFileNames: pass a list of hdf files with full path, for e.g.,
%['C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic01.cdf','C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic02.cdf','C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic03.cdf','C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic04.cdf']
% (2) low_mz: user selected lower limit mz value, for e.g., 430.7897
% (3) high_mz: user selected higher limit mz value, for e.g., 870.54

%% Output:
% ion_image: An mXn image

%% Example Call:
% CDF Example:
% [ion_image] = generate_ion_image_from_hdf(400.2445, 800.6578, ['C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic01.cdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic02.cdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic03.cdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic04.cdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic05.cdf']);
% HDF Example:
% [ion_image] = generate_ion_image_from_hdf(400.2445, 800.6578, ['C:\Users\thom991\Desktop\MSI_testData\testset1\HDF_Files\d_nic01.hdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\HDF_Files\d_nic02.hdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\HDF_Files\d_nic03.hdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\HDF_Files\d_nic04.hdf'; 'C:\Users\thom991\Desktop\MSI_testData\testset1\HDF_Files\d_nic05.hdf']);
% [ion_image] = generate_ion_image_from_hdf(1375.505273142227, 1500.4311600220506, ['C:\Users\thom991\Desktop\theo\HDF_Files\d_nic01.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic02.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic03.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic04.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic05.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic06.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic07.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic08.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic09.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic10.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic11.hdf';'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic12.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic13.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic14.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic15.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic16.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic17.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic18.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic19.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic20.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic21.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic22.hdf';'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic23.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic24.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic25.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic26.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic27.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic28.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic29.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic30.hdf';]);
%% Code:
try
    start_logging();
%     fprintf('Please Wait !!!')
    num = [low_mz, high_mz];
    %normalize
    normalize_data_lower_lim = [];
    normalize_data_higher_lim = [];
    normalize_data_mode = [];
    single_range_value = [];
    lines_to_remove_from_image = [];
    apply_manipulations_to_all = 0; 
    avg_image_pixels = []; 
    for i = 1:size(arrayOfHdfFileNames,1)
        filename = arrayOfHdfFileNames(i,:);
        if strcmp(filename(end-2:end), 'cdf')
            RAW_filename_new2 = filename;
            intensity_values = ncread(RAW_filename_new2,'intensity_values');
            mass_values = ncread(RAW_filename_new2,'mass_values');
            scan_acquisition_time = ncread(RAW_filename_new2,'scan_acquisition_time');
            scan_acquisition_time = scan_acquisition_time/60;
            point_count = ncread(RAW_filename_new2,'point_count');
            total_intensity = ncread(RAW_filename_new2,'total_intensity');
        elseif strcmp(filename(end-2:end), 'hdf')
            RAW_filename_new2 = filename;
            intensity_values = hdf5read(RAW_filename_new2,'intensity_values');
            mass_values = hdf5read(RAW_filename_new2,'mass_values');
            scan_acquisition_time = hdf5read(RAW_filename_new2,'scan_acquisition_time');
            scan_acquisition_time = scan_acquisition_time/60;
            point_count = hdf5read(RAW_filename_new2,'point_count');
            total_intensity = hdf5read(RAW_filename_new2,'total_intensity');
        end
        min_time_final = min(scan_acquisition_time(:));
        max_time_final = max(scan_acquisition_time(:));
        min_time = min(scan_acquisition_time(:)); max_time = max(scan_acquisition_time(:));
        min_time_final = max([min_time_final min_time]); max_time_final = min([max_time_final max_time]);
        number_time_vals = size(scan_acquisition_time,1);
        lower_limits_count = num(:,1);
        lower_limits_count = lower_limits_count';
        upper_limits_count = num(:,2);
        upper_limits_count = upper_limits_count';
        size_count_limits = size(lower_limits_count,2);
        for i55 = 1: size(lower_limits_count,2)
            list{i55} = [num2str(lower_limits_count(i55)) '-' num2str(upper_limits_count(i55))];
        end
        for oo = 1: size(lower_limits_count,2)
            sum_of_intensities_temp3 = [];
            sum_of_intensities_normalize = [];
            lower_limit_mz_value = lower_limits_count(oo);
            upper_limit_mz_value = upper_limits_count(oo);
            low_bar = single(lower_limit_mz_value);
            high_bar = single(upper_limit_mz_value);
            for scan_numb = 1:numel(point_count)
                number_time_vals_final = size(scan_acquisition_time,1);
                int_val = intensity_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
                mass_val = mass_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
                if isempty(single_range_value)
                    single_number_forward = (find(mass_val >= low_bar,1,'first'));
                    single_number_backward = (find(mass_val < low_bar,1,'last'));
                    diff_forward = abs(low_bar - mass_val(single_number_forward(1)));
                    if ~isempty(single_number_backward)
                        diff_backward = abs(low_bar - mass_val(single_number_backward(end)));
                    else
                        diff_backward = 0;
                    end
                    if diff_forward < diff_backward
                        lower_number = single_number_forward(1);
                    else
                        if ~isempty(single_number_backward)
                            lower_number = single_number_backward(end);
                        else
                            lower_number = single_number_forward(1);
                        end;
                    end
                    high_single_number_forward = (find(mass_val >= high_bar,1,'first'));
                    high_single_number_backward = (find(mass_val < high_bar,1,'last'));
                    high_diff_forward = abs(high_bar - mass_val(high_single_number_forward(1)));
                    if ~isempty(high_single_number_backward)
                        high_diff_backward = abs(high_bar - mass_val(high_single_number_backward(end)));
                    else
                        high_diff_backward = 0;
                    end
                    if high_diff_forward < high_diff_backward
                        higher_number = high_single_number_forward(1);
                    else
                        if ~isempty(high_single_number_backward)
                            higher_number = high_single_number_backward(end);
                        else
                            higher_number = high_single_number_forward(1);
                        end
                    end
                    lower_number_new = lower_number;
                    higher_number_new = higher_number;
                elseif isempty(double_range_value)
                    if isempty(single_limit_mz_value)
                        uiwait
                    end
                    low_bar = single(single_limit_mz_value);
                    single_number_forward = (find(mass_val >= low_bar,1,'first'));% & sure1_check(:,n_num) < low_bar+1));
                    single_number_backward = (find(mass_val > low_bar,1,'last'));% & sure1_check(:,n_num) < low_bar));
                    diff_forward = abs(low_bar - mass_val(single_number_forward(1)));
                    if ~isempty(single_number_backward)
                        diff_backward = abs(low_bar - mass_val(single_number_backward(end)));
                    else
                        diff_backward = 0;
                    end
                    if diff_forward < diff_backward
                        single_number = single_number_forward(1);
                    else
                        if ~isempty(single_number_backward)
                            single_number = single_number_backward(end);
                        else
                            single_number = single_number_forward(1);
                        end
                    end
                    single_number_new = single_number;%(1);
                end
                sum_of_intensities_temp3(1,scan_numb) = sum(int_val(lower_number_new:higher_number_new));%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));
                if ~isempty(normalize_data_lower_lim)
                    single_number_forward_normalize = (find(mass_val >= normalize_data_lower_lim,1,'first'));
                    single_number_backward_normalize = (find(mass_val < normalize_data_lower_lim,1,'last'));
                    diff_forward_normalize = abs(normalize_data_lower_lim - mass_val(single_number_forward_normalize(1)));
                    if ~isempty(single_number_backward_normalize)
                        diff_backward_normalize = abs(normalize_data_lower_lim - mass_val(single_number_backward_normalize(end)));
                    else
                        diff_backward_normalize = 0;
                    end
                    if diff_forward_normalize < diff_backward_normalize
                        lower_number_normalize = single_number_forward_normalize(1);
                    else
                        if ~isempty(single_number_backward_normalize)
                            lower_number_normalize = single_number_backward_normalize(end);
                        else
                            lower_number_normalize = single_number_forward_normalize(1);
                        end;
                    end
                    
                    high_single_number_forward_normalize = (find(mass_val >= normalize_data_higher_lim,1,'first'));
                    high_single_number_backward_normalize = (find(mass_val < normalize_data_higher_lim,1,'last'));
                    high_diff_forward_normalize = abs(normalize_data_higher_lim - mass_val(high_single_number_forward_normalize(1)));
                    if ~isempty(high_single_number_backward_normalize)
                        high_diff_backward_normalize = abs(normalize_data_higher_lim - mass_val(high_single_number_backward_normalize(end)));
                    else
                        high_diff_backward_normalize = 0;
                    end
                    if high_diff_forward_normalize < high_diff_backward_normalize
                        higher_number_normalize = high_single_number_forward_normalize(1);
                    else
                        if ~isempty(high_single_number_backward_normalize)
                            higher_number_normalize = high_single_number_backward_normalize(end);
                        else
                            higher_number_normalize = high_single_number_forward_normalize(1);
                        end
                    end
                    lower_number_new_normalize = lower_number_normalize;
                    higher_number_new_normalize = higher_number_normalize;
                    sum_of_intensities_normalize(1,scan_numb) = sum(int_val(lower_number_new_normalize:higher_number_new_normalize));%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));
                end
            end
            if isempty(normalize_data_mode)
                normalize_data_mode = 0;
            end
            if normalize_data_mode == 1 && isempty(normalize_data_lower_lim)
                sum_of_intensities_temp3 = sum_of_intensities_temp3./total_intensity';
            elseif normalize_data_mode == 1 && ~isempty(normalize_data_lower_lim)
                sum_of_intensities_temp3 = sum_of_intensities_temp3./sum_of_intensities_normalize;
                sum_of_intensities_temp3(isinf(sum_of_intensities_temp3)) = 0;
            end
            current_dir = pwd;
            if i == 1
                sum_of_intensities_temp2{i} = sum_of_intensities_temp3;
                row_num = 1;
            else
                sum_of_intensities_temp2{i} = sum_of_intensities_temp3;
            end
            cd(current_dir)
        end
        row_num = row_num + 1;
    end
    current_dir = pwd;
    org_sum_of_int1 = numel(sum_of_intensities_temp2);
    [org_sum_of_int2, max_index] = max(cellfun('size', sum_of_intensities_temp2, 2));
    
    for i = 1:size(lower_limits_count,2)
        sum_of_intensities2 = NaN([org_sum_of_int1,org_sum_of_int2]);
        for j = 1:size(sum_of_intensities2,1)
            sum_of_intensities2(j,1:numel(sum_of_intensities_temp2{1,j})) = sum_of_intensities_temp2{1,j};
        end
    end
    x5 = sum_of_intensities2;
    if apply_manipulations_to_all == 1;
        %% Avergae Image Pixels
        if avg_image_pixels == 1
            x5 = scale_image_to_fixed_limits(0, 100, x5);
            for i = 1:size(x5,1)
                for j = 2:size(x5,2)-1
                    current_val = x5(i,j);
                    left_val = x5(i,j-1);
                    right_val = x5(i,j+1);
                    average_left_right = (left_val+right_val)/2;
                    if current_val > average_left_right + lim_val
                        new_current_val = average_left_right;
                        x5(i,j) = new_current_val;
                    end
                end
            end
        end
        
        %% Align Image
        filename2 = filename;
        number_of_scans = size(arrayOfHdfFileNames,1);
        x5 = interpolation_code_web(x5, number_of_scans, filename2, arrayOfHdfFileNames);
        %% Remove unwanted lines
        if ~isempty(lines_to_remove_from_image)
            original_number_of_lines = 1:size(x5,1);
            unique_elements_after_removing_lines = setdiff(original_number_of_lines, lines_to_remove_from_image);
            for i = 1:size(unique_elements_after_removing_lines,2)
                x5(i,:) = x5(unique_elements_after_removing_lines(i),:);
                
            end
            x5(size(unique_elements_after_removing_lines,2)+1:end,:) = [];
        end
        %% Show Interpolated Values
        val_across_interpolated_data = [];
        val_down_interpolated_data = [];
        if ~isempty(val_across_interpolated_data)
            x5 = imresize(x5(:,:),[size(x5,1)*val_down_interpolated_data,size(x5,2)*val_across_interpolated_data],'bilinear');
        end
    end
    ion_image = x5;
% disp('Done !!!')
stop_logging();
catch MExc
    disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
end

function start_logging()
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])


function stop_logging()
    diary off

function delete_logs()
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    if exist([saveMSIQuickViewLogs 'logs.txt'],'file')
        delete([saveMSIQuickViewLogs 'logs.txt'])   
    end
