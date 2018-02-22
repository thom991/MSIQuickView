global number_of_scans filename inc_pca uz4_2 uz2 only_save_matrix
only_save_matrix = 1;
inc_pca = 1;
k = get(handles.start_with_line_number_editbox,'string');
k = single(str2num(k));       
        isos_dir = uigetdir;
        disp('Getting combined list of m/z values from isos files')
[uz4_2, uz2] = obtain_mz_vals_combined_from_isos_alone_new(number_of_scans, filename,isos_dir);
uz2_diff = diff(uz2);
axes(handles.stats_plot1)
plot(uz2_diff)
set(handles.stats_table1,'Data', uz2_diff)
disp('Done!')
%%

global uz2 mz_means_list_for_each_block locs start_end_loc_for_means
thresh_val = get(handles.threshold_for_peaks,'string');
thresh_val = single(str2num(thresh_val)); 
axes(handles.stats_plot1)
[start_end_loc_for_means, mz_means_list_for_each_block, locs] = generate_mz_means_list_for_each_block(uz2, thresh_val);
set(handles.stats_table1,'Data',mz_means_list_for_each_block)


%%

global uz2 mz_means_list_for_each_block locs mz_rows_to_remove start_end_loc_for_means
tol_val = get(handles.threshold_for_peaks,'string');
tol_val = single(str2num(tol_val)); 
[uz2,mz_rows_to_remove] = generate_mz_rows_to_remove(uz2,locs, mz_means_list_for_each_block, tol_val, start_end_loc_for_means);
set(handles.stats_table1,'Data',mz_means_list_for_each_block) 


%%