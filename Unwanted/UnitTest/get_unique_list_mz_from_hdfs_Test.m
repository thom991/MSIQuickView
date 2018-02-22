global unique_list_hdf_final uz4
number_of_scans = 15;
filename = 'Brain 3-1.raw';
isos_dir = ('C:\Users\thom991\Desktop\reduced_isos');
[unique_list_hdf_final] = get_unique_list_mz_from_hdfs(number_of_scans, filename);
[uz4] = obtain_mz_vals_combined_from_isos_and_hdfs(number_of_scans, unique_list_hdf_final, filename, isos_dir);

