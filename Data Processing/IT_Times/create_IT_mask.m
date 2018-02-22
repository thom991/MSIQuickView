function [IT_mask_image, IT_mask_binary_image] = create_IT_mask(IT_times, pathname, ll, no_of_lines)
%% function to create a mask of IT time points to display in MSI QuickView
% It is basically an image of 0s and 1s, where 1s represent bad IT times.
% Function has 2 parts: (1) to get the max number of scans from all lines
% (2) to create an IT mask image
% Inputs are :::
% 1) pathname: directory of the raw files
% 2) IT_times: max IT_time, e.g., 500
% 3) ll: list of raw filenames {cell}
% 4) no_of_lines: number of lines of the dataset currently loaded
% Outputs are:
% 1) IT_mask_image: the IT_mask image of actual IT values
% 2) IT_mask_binary_image: the IT_mask image of 0s and 1s (logical)

%% Architecture
% 1) get the max number of scans from all lines in the dataset
% 2) create an empty mask and append for each IT header file (for each
% line)

%% Get max number of scans from all lines
for i = 1:no_of_lines
    fake_name2 = ll{1,i};
    fake_name2(end-3:end) = '.xls';
    disp(fake_name2)
    ii = dlmread([pathname 'Header_Files' filesep fake_name2],'\t',1, 1);
    vals = ii(:,1)';
    count_list(i) = numel(vals);
end
count_list_max = max(count_list(:));

%% Create the IT mask image
IT_mask_image = zeros(no_of_lines, count_list_max);
for i = 1:no_of_lines
    fake_name2 = ll{1,i};
    fake_name2(end-3:end) = '.xls';
    disp(fake_name2)
    ii = dlmread([pathname 'Header_Files' filesep fake_name2],'\t',1, 1);
    IT_mask_image(i,1:numel(ii(:,1))) = ii(:,1)';
end
IT_mask_binary_image = IT_mask_image;
IT_mask_binary_image([IT_mask_binary_image<IT_times]) = 1;
IT_mask_binary_image([IT_mask_binary_image==IT_times]) = 0;
IT_mask_binary_image = logical(IT_mask_binary_image);
