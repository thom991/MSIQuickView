function xml_saving(n1)
% xml_Saving Save experimental details to a xml file.
% n1 = 'Brain 3-1.raw';
% n2 = 15;
% x = {n1,n2};%,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16,n17,n18,n19,n20,n21,val1_lower_lim,val1_upper_lim,val2_lower_lim,val2_upper_lim,val3_lower_lim,val3_upper_lim,val4_lower_lim,val4_upper_lim,val5_lower_lim,val5_upper_lim,val6_lower_lim,val6_upper_lim,val7_lower_lim,val7_upper_lim,val8_lower_lim,val8_upper_lim,enter_multiple_values,threshold_values,n22,n23,n24,n25,n26,normalize_data_checkbox,n28,n29,lines_to_remove_from_image,val_across_interpolated_data,val_down_interpolated_data,higher_limit_for_grayscale_color,lower_limit_for_grayscale_color,org_sum_of_int1,org_sum_of_int2};    
docNode = com.mathworks.xml.XMLUtils.createDocument('MSI_Settings_for_the_dataset');
    docRootNode = docNode.getDocumentElement;
    
    thisElement = docNode.createElement('Filename');
    thisElement.appendChild(docNode.createTextNode(n1));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('count_2');
    thisElement.appendChild(docNode.createTextNode(num2str(n2)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('Number_of_scans');
    thisElement.appendChild(docNode.createTextNode(num2str(n3)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('size_sum_of_intensities1');
    thisElement.appendChild(docNode.createTextNode(num2str(n4)));
    docRootNode.appendChild(thisElement);

    thisElement = docNode.createElement('size_sum_of_intensities2');
    thisElement.appendChild(docNode.createTextNode(num2str(n5)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('colormap_3d');
    thisElement.appendChild(docNode.createTextNode(colormap_3d));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('O_present');
    thisElement.appendChild(docNode.createTextNode(num2str(O_was_present)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('lower_limit_mz_values');
    thisElement.appendChild(docNode.createTextNode(num2str(lower_limit_mz_value)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('upper_limit_mz_value');
    thisElement.appendChild(docNode.createTextNode(num2str(upper_limit_mz_value)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('single_range_value');
    thisElement.appendChild(docNode.createTextNode(num2str(single_range_value)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('double_range_value');
    thisElement.appendChild(docNode.createTextNode(num2str(double_range_value)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('check_point_count');
    thisElement.appendChild(docNode.createTextNode(num2str(check_point_count)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('image_window_to_display_value');
    thisElement.appendChild(docNode.createTextNode(num2str(image_window_to_display_value)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('next_sum_folder');
    thisElement.appendChild(docNode.createTextNode(num2str(next_sum_folder)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('size_count_limits');
    thisElement.appendChild(docNode.createTextNode(num2str(size_count_limits)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('upper_limits_count');
    thisElement.appendChild(docNode.createTextNode(num2str(upper_limits_count)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('lower_limits_count');
    thisElement.appendChild(docNode.createTextNode(num2str(lower_limits_count)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('normalize_data_mode');
    thisElement.appendChild(docNode.createTextNode(num2str(normalize_data_mode)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('pwd');
    thisElement.appendChild(docNode.createTextNode(pwd));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('start_with_line_number');
    thisElement.appendChild(docNode.createTextNode(n20));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('pathname');
    thisElement.appendChild(docNode.createTextNode(pathname));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val1_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val1_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val1_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val1_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val2_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val2_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val2_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val2_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val3_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val3_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val3_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val3_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val4_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val4_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val4_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val4_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val5_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val5_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val5_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val5_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val6_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val6_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val6_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val6_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val7_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val7_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val7_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val7_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val8_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val8_lower_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val8_upper_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(val8_upper_lim)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('enter_multiple_values');
    thisElement.appendChild(docNode.createTextNode(enter_multiple_values));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('threshold_values');
    thisElement.appendChild(docNode.createTextNode(threshold_values));
    docRootNode.appendChild(thisElement);    
    
    thisElement = docNode.createElement('across_val');
    thisElement.appendChild(docNode.createTextNode(across_val));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('down_val');
    thisElement.appendChild(docNode.createTextNode(down_val));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('apply_manipulations_to_all');
    thisElement.appendChild(docNode.createTextNode(num2str(apply_manipulations_to_all)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('user_input_for_mode_manual');
    thisElement.appendChild(docNode.createTextNode(num2str(user_input_for_mode_manual)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('user_input_for_mode_auto');
    thisElement.appendChild(docNode.createTextNode(num2str(user_input_for_mode_auto)));
    docRootNode.appendChild(thisElement);
     
    thisElement = docNode.createElement('normalize_data_checkbox');
    thisElement.appendChild(docNode.createTextNode(num2str(normalize_data_checkbox)));
    docRootNode.appendChild(thisElement);    
    
    thisElement = docNode.createElement('normalize_data_lower_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(n28)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('normalize_data_higher_lim');
    thisElement.appendChild(docNode.createTextNode(num2str(n29)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('lines_to_remove_from_image');
    thisElement.appendChild(docNode.createTextNode(num2str(lines_to_remove_from_image)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val_across_interpolated_data');
    thisElement.appendChild(docNode.createTextNode(num2str(val_across_interpolated_data)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('val_down_interpolated_data');
    thisElement.appendChild(docNode.createTextNode(num2str(val_down_interpolated_data)));
    docRootNode.appendChild(thisElement);
      
    thisElement = docNode.createElement('higher_limit_for_grayscale_color');
    thisElement.appendChild(docNode.createTextNode(num2str(higher_limit_for_grayscale_color)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('lower_limit_for_grayscale_color');
    thisElement.appendChild(docNode.createTextNode(num2str(lower_limit_for_grayscale_color)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('org_sum_of_int1');
    thisElement.appendChild(docNode.createTextNode(num2str(org_sum_of_int1)));
    docRootNode.appendChild(thisElement);
    
    thisElement = docNode.createElement('org_sum_of_int2');
    thisElement.appendChild(docNode.createTextNode(num2str(org_sum_of_int2)));
    docRootNode.appendChild(thisElement);
    
    xmlFileName = strcat(pathname,'Image_Files',filesep,'saving_parameters','.xml');
    xmlwrite(xmlFileName,docNode);
%     edit(xmlFileName);
    