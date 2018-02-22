function save_ion_image_for_all_ranges_in_spreadsheet(application_name, dataset_modality, dataset_pathname, array_list_of_mz_values, list_of_hdf_or_cdf_files_with_path, upper_limit, dataset_name, handles)
%% This function will take an array of m/z ranges and produce an image for each, saving it into the dataset directory under the images folder.
% Inputs: Dataset_pathname (where to save?)- ..../thom991/nic
% Array_list_of_mz_values: [321.456, 322.245; 500.12234, 560.7897;
% 800.67856, 810.68785];
% list_of_hdf_or_cdf_files_with_path:
% ['C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic01.cdf','C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic02.cdf','C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic03.cdf','C:\Users\thom991\Desktop\MSI_testData\testset1\CDF_Files\d_nic04.cdf'];
% upper_limit: upper limit values after which to downsample/resize the
% image, eg., 1000
% Example call:
% save_ion_image_for_all_ranges_in_spreadsheet('MSI_QuickView_Desktop_App', 'nanodesi', 'C:\Users\thom991\Desktop\MSI_testData\Images\',[321.456, 322.245; 500.12234, 560.7897; 800.67856, 810.68785], ['C:\Users\thom991\Desktop\theo\HDF_Files\d_nic01.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic02.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic03.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic04.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic05.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic06.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic07.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic08.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic09.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic10.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic11.hdf';'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic12.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic13.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic14.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic15.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic16.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic17.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic18.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic19.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic20.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic21.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic22.hdf';'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic23.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic24.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic25.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic26.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic27.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic28.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic29.hdf'; 'C:\Users\thom991\Desktop\theo\HDF_Files\d_nic30.hdf';], 1000, 'nic1');
fprintf('Please Wait !!!\n')
for i = 1:size(array_list_of_mz_values,1)
    t1 = tic;
    low_mz = array_list_of_mz_values(i,1);
    high_mz = array_list_of_mz_values(i,2);
    [ion_image] = generate_ion_image_from_hdf(low_mz, high_mz, list_of_hdf_or_cdf_files_with_path);
    ion_image = scale_image_to_fixed_limits(0, 100, ion_image);
    newmap2 = hot(64);
    if size(ion_image, 2) > upper_limit
       newsize = [size(ion_image, 1), upper_limit]; 
       ion_image = imresize(ion_image, newsize);
    end
    imwrite(ion_image, newmap2, [dataset_pathname num2str(array_list_of_mz_values(i,1)) '_' num2str(array_list_of_mz_values(i,2)) '.png']);
    t2 = toc(t1);
    time_remaining = t2*(size(array_list_of_mz_values,1)-i);
    time_elapsed = t2*(size(array_list_of_mz_values,1));
    fprintf('Remaining time is %s seconds, image number %s of %s. \n', num2str(time_remaining), num2str(i), num2str(size(array_list_of_mz_values,1)));
    api = elasticModule;
    api.app_status_matlab_to_ES(application_name, dataset_name, dataset_modality, 'Save Ion Images for all m/z values in spreadsheet', time_elapsed, time_remaining, ['Remaining time is ' num2str(time_remaining) ' seconds, image number ' num2str(i) ' of ' num2str(size(array_list_of_mz_values,1)) '.'], 'process_timeline', handles);
end
api.app_status_matlab_to_ES(application_name, dataset_name, dataset_modality, 'Save Ion Images for all m/z values in spreadsheet', time_elapsed, time_remaining, 'Completed', 'process_timeline', handles);
fprintf('Done !!!\n');