function handles = load_presaved_matfile(pathname, list, handles)
    load([pathname 'Saved_Parameters' '.mat'])
    count_2 = list{1,2};
    number_of_scans = list{1,3};
    colormap_3d = list{1,6};
    O_was_present = list{1,7};
    lower_limit_mz_value = list{1,8};
    upper_limit_mz_value = list{1,9};
    single_range_value = list{1,10};
    double_range_value = list{1,11};
    check_point_count = list{1,12};
    image_window_to_display_value = list{1,13};
    next_sum_folder = list{1,14};
    size_count_limits = list{1,15};
    upper_limits_count = list{1,16};
    lower_limits_count = list{1,17};
    normalize_data_mode = list{1,18};
    across_val = list{1,40};
    down_val = list{1,41};
    apply_manipulations_to_all = list{1,42};
    val1_lower_lim = list{1,22};
    set(handles.start_with_line_number_editbox,'string',num2str(list{1,20}));
    set(handles.apply_manipulations_to_all_images, 'Value',apply_manipulations_to_all);
    set(handles.lower_limit_mz_value_box, 'string',num2str(lower_limit_mz_value));
    set(handles.upper_limit_mz_value_box, 'string',num2str(upper_limit_mz_value));
    sum_of_intensities = NaN([list{1,4},list{1,5}]);
    set(handles.text_for_number_of_scans, 'string',num2str(number_of_scans));
    set(handles.enter_vals_for_multiple_mz, 'string',num2str(list{1,38}));
    set(handles.editbox_for_enter_threshold_value, 'string',num2str(list{1,39}));
    set(handles.aspect_ratio_across_edit, 'string',num2str(across_val));
    set(handles.aspect_ratio_down_edit, 'string',num2str(down_val));
    set(handles.normalize_data_checkbox, 'Value',list{1,45});
    set(handles.normalize_data_lower_limit, 'string',num2str(list{1,46}));
    set(handles.normalize_data_higher_limit, 'string',num2str(list{1,47}));
    set(handles.remove_lines_edit_box, 'string',num2str(list{1,48}));
    set(handles.editbox_across_interpolated_data, 'string',num2str(list{1,49}));
    set(handles.editbox_down_interpolated_data, 'string',num2str(list{1,50}));
    set(handles.new_lowest_gray_value, 'string',num2str(list{1,52}));
    set(handles.new_highest_gray_value, 'string',num2str(list{1,51}));
    org_sum_of_int1 = list{1,53};
    org_sum_of_int2 = list{1,54};
    handles.count_2 = count_2; handles.colormap_3d = colormap_3d; handles.O_was_present = O_was_present; handles.lower_limit_mz_value = lower_limit_mz_value; handles.upper_limit_mz_value = upper_limit_mz_value; handles.single_range_value = single_range_value; handles.double_range_value = double_range_value; handles.check_point_count = check_point_count; handles.image_window_to_display_value = image_window_to_display_value; handles.next_sum_folder = next_sum_folder; handles.size_count_limits = size_count_limits; handles.upper_limits_count = upper_limits_count; handles.lower_limits_count = lower_limits_count; handles.normalize_data_mode = normalize_data_mode; handles.apply_manipulations_to_all = apply_manipulations_to_all; handles.val1_lower_lim = val1_lower_lim; handles.sum_of_intensities = sum_of_intensities; handles.org_sum_of_int1 = org_sum_of_int1; handles.org_sum_of_int2 = org_sum_of_int2; handles.cdf_filename = cdf_filename; handles.instrument_bruker = instrument_bruker; handles.local_mfiles = local_mfiles; 
