function open_all_selected_mz_using_pca_lda_as_pdf(no_of_images_per_page, range_selected, k2, number_of_scans)
%eg;
%open_all_selected_mz_using_pca_lda_as_pdf(6, 1, 1, 15)
% hObject    handle to pca_analysis_code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global i_n image_window_to_display_value
global filename size_sum_of_intensities count_2 normalize_data_mode O_was_present lower_limit_mz_value upper_limit_mz_value single_range_value double_range_value pathname ll
% global lower_limit_mz_value_sure1 upper_limit_mz_value_sure1 imp_mass
% global final_mz_val final_mz_val_u sum_of_intensities_temp
% global fake_name RAW_filename_new2
% if exist('C:\delete_mat_files')
%     if size(dir('C:\delete_mat_files'),1) > 2
%     rmdir('C:\delete_mat_files','s')
%     end
% end
if isdeployed
   no_of_images_per_page = str2num(no_of_images_per_page);
   range_selected = str2num(range_selected);
   k2 = str2num(k2);
   number_of_scans = str2num(number_of_scans);
end
current_dir = pwd;
if isempty(filename)
   [filename, pathname, filterindex] = uigetfile( ...
{  '*.yep;*.baf;*.RAW';'*.*'}, ...
   'Pick a RAW file'); 
end
if exist(strcat(pathname,saveTemporaryFilesToFolder),'dir')
    if size(dir(strcat(pathname,saveTemporaryFilesToFolder)),1) > 2
    rmdir(strcat(pathname,saveTemporaryFilesToFolder),'s')
%     cd('C:\');
    mkdir(strcat(pathname,saveTemporaryFilesToFolder));
    end
else
%     cd('C:\');
    mkdir(strcat(pathname,saveTemporaryFilesToFolder));    
end
% mkdir('C:\delete_mat_files');
% h = waitbar(0.25,'Please wait...');
% range_selected = get(handles.select_range_mz_vals_for_pca,'Value');
% k2 = get(handles.start_with_line_number_editbox,'string');
% k2 = single(str2num(k2));
    k = k2;
    [open_excel_filename,open_excel_pathname] = uigetfile({  '*.xls','xls-files (*.xls)'}, ...
   'Pick the Excel file'); 
%
opening_xls_sheet = xlsread(strcat(open_excel_pathname,filesep,open_excel_filename));
fprintf('Loading the excel file \n')
if strcmp(open_excel_filename(1),'C')
final_mz_val = zeros(1,(size(opening_xls_sheet,1)*2),'single');
final_mz_val(1:2:size(final_mz_val,2)) = opening_xls_sheet(:,1);
final_mz_val(2:2:size(final_mz_val,2)) = opening_xls_sheet(:,2);    
final_mz_val = final_mz_val';
elseif strcmp(open_excel_filename(1),'P')
final_mz_val = opening_xls_sheet(:,1);    
end
% final_mz_val = final_mz_val';
% final_mz_val = [442.25
% 464.166687
% 414.0833435
% 412.25
% 479.8333435
% 1013
% 925.5
% 512.083374
% 454.166687
% 1004.666687
% 954.666687
% 1085.166748
% 853.75
% 1130.25
% 824.5
% 625.75
% 1029.166748
% 836.666687
% 1181
% 1072.416748
% 809.583374
% 1450.333374
% 1498.166748
% 1017.333374
% 623.75
% 1219.5
% 784.083374
% 472.25
% 999.416687
% 581.083374
% 1027.166748
% 495
% 987.416687
% 665.083374
% 776.75
% 1066.916748
% 1172.083374
% 1278.666748
% 755.083374
% 1221.416748
% 1055.75
% 994.5
% 1042.166748
% 1034.25
% 1261.75
% 954.166687
% 649.916687
% 1530.333374
% 881.583374
% 767.333374
% ];%pca_for_scans;
fake_name = filename;
fprintf('Saving temporary files for generating the images \n');
% class(number_of_scans)
    for i = 1:number_of_scans
        tic
        fprintf('Obtaining Image for Line %u \n',i)
%         if k < 10
%             fake_name(size(filename,2)-4) = num2str(k);
%             fake_name(size(filename,2)-3:size(filename,2)) = '.hdf';
%         else
%             if k == 10 && fake_name(size(filename,2)-5) == '0'
%             fake_name(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name(size(filename,2)-3:size(filename,2)) = '.hdf'; 
%             O_was_present = 1;
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name(size(filename,2)-3:size(filename,2)) = '.hdf';                 
%             else
%             fake_name(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name(size(filename,2)-2:size(filename,2)+1) = '.hdf';   
%             end
%         end           
            fake_name2 = ll{1,k};
            fake_name2(end-3:end) = '.hdf';         
        
        RAW_filename_new2 = strcat(pathname,'HDF_Files',filesep,fake_name);
%         disp(RAW_filename_new2)
%         disp(k)
% disp(fake_name)
                    intensity_values = (hdf5read(RAW_filename_new2,'intensity_values'));
                    mass_values = (hdf5read(RAW_filename_new2,'mass_values'));
                    scan_acquisition_time = hdf5read(RAW_filename_new2,'scan_acquisition_time');
                    scan_acquisition_time = scan_acquisition_time/60;
                    point_count = (hdf5read(RAW_filename_new2,'point_count'));  
                    total_intensity = (hdf5read(RAW_filename_new2,'total_intensity'));
                            min_time_final = min(scan_acquisition_time(:)); 
        max_time_final = max(scan_acquisition_time(:));
        min_time = min(scan_acquisition_time(:)); max_time = max(scan_acquisition_time(:));  
        min_time_final = max([min_time_final min_time]); max_time_final = min([max_time_final max_time]);
        number_time_vals = size(scan_acquisition_time,1);
% size_count_limits = size(lower_limits_count,2);
for oo = 1:size(final_mz_val,1)
    sum_of_intensities_temp3 = [];
    lower_limit_mz_value = final_mz_val(oo);% - 0.00001;
    upper_limit_mz_value = final_mz_val(oo);% + 0.00001;
                    low_bar = single(lower_limit_mz_value);
                    high_bar = single(upper_limit_mz_value);
for scan_numb = 1:size(point_count,1)
        number_time_vals_final = size(scan_acquisition_time,1);
        int_val = intensity_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
        mass_val = mass_values(sum(point_count(1:scan_numb-1))+1:sum(point_count(1:scan_numb)));
if isempty(single_range_value) %size(r,1) > 1

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
    higher_number_new = higher_number;%(end);%(1) + sum(point_count(2:i2));    

                    elseif isempty(double_range_value)     
                    if isempty(single_limit_mz_value)
                            uiwait
                    end
%                     h_l = imline(gca, [single_limit_mz_value single_limit_mz_value], [0 max(int_val(:))]);%,@get_line_info_Callback); 
%                     api = iptgetapi(h_l);
%                     api.setColor([1 0 0]);
%                     fcn = makeConstrainToRectFcn('imline', [0, max(mass_val(:))],...
%                     [0, max(int_val(:))]);
%                     api.setPositionConstraintFcn(fcn);          
  
                    axis tight
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
if isempty(single_range_value)
    sum_of_intensities_temp3(1,scan_numb) = sum(int_val(lower_number_new:higher_number_new));%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));    
elseif isempty(double_range_value)
sum_of_intensities_temp3(1,scan_numb) = int_val(single_number_new);    
end
end
    if normalize_data_mode == 1
    sum_of_intensities_temp3 = sum_of_intensities_temp3./total_intensity';%,1:size(scan_acquisition_time,1)),1);%sum(single(intensity_values(lower_number_new : higher_number_new)));    
    end   

current_dir = pwd;
cd(strcat(pathname,saveTemporaryFilesToFolder))
if i == 1
    sum_of_intensities_temp2 = sum_of_intensities_temp3;
    vname = sprintf('x%d',i);
    eval([vname, '=sum_of_intensities_temp2;'])
    save(strcat('sum_of_intensities',num2str(oo),'.mat'),vname)
    row_num = 1;
    if i == 1
        size_sum_of_intensities(i) = size(sum_of_intensities_temp2,1);
    end
else
    sum_of_intensities_temp2 = sum_of_intensities_temp3;
    vname = sprintf('x%d',i);
    eval([vname, '=sum_of_intensities_temp2;'])    
    save(strcat('sum_of_intensities',num2str(oo),'.mat'),vname,'-append')
    if i == 1
        size_sum_of_intensities(i) = size(sum_of_intensities_temp2,1);
    end    
end
cd(current_dir)
end                    
                    k_final_2 = count_2;
                    k = k + 1;
                    row_num = row_num + 1;
                    time_taken = toc;
                    fprintf('Time Taken for Line %u is %f \n', i, time_taken);
    end
% current_dir = pwd;    
cd(strcat(pathname,saveTempFilesToFolder))   
%
fprintf('Combining and displaying Grayscale Images \n')
fig_no = 1;
for ii = 1:size(final_mz_val,1)
    tic
    sum_of_intensities2 = zeros(number_of_scans, max(size_sum_of_intensities(:)), 'single');
    load(strcat('sum_of_intensities',num2str(ii),'.mat'))
    for j = 1:size(sum_of_intensities2,1)
        vname = sprintf('x%d',j);
        eval_vname = size(eval(vname),2);
        sum_of_intensities2(j,1:eval_vname) = eval(vname);
    end
                        new_min = 0;    %min of 0 to 255
                    new_max = 100;  %max of 0 to 255
                    old_min = min(sum_of_intensities2(:));
                    old_max = max(sum_of_intensities2(:));
                    for i = 1:size(sum_of_intensities2,1)
                        for j2 = 1:size(sum_of_intensities2,2)
                        value = sum_of_intensities2(i, j2);
                        sum_of_intensities2(i,j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
                        end
                    end
    save(strcat('sum_of_intensities',num2str(ii),'.mat'),'sum_of_intensities2')
    %%
    i_n = ii;
% if range_selected == 1
% %     name_fig = strcat('MZ__min',num2str(round(final_mz_val(i_n))),'__max',num2str(final_mz_val_u(i_n)),'.tif');
% % else
% %     name_fig = strcat('MZ__min',num2str(round(final_mz_val(i_n))),'.tif');
% end
sum_of_intensities_temp = imresize(sum_of_intensities2(:,:),[size(sum_of_intensities2,1)*10,size(sum_of_intensities2,2)*10]);
% if isempty(image_window_to_display_value) 
%     image_window_to_display_value = 1;
% end
% if image_window_to_display_value == 1
% cla(handles.zone_specified_plot);
% axes(handles.zone_specified_plot);
% else
% cla(handles.zone_specified_plot2);
% axes(handles.zone_specified_plot2);
% end
if fig_no == 1
    close(figure(1)); figure(1) 
end
subplot((no_of_images_per_page/2),2,fig_no); 
imagesc(sum_of_intensities_temp); axis off; 
if range_selected == 1
% title(strcat('MZ__min',num2str(final_mz_val(i_n))),'__max',num2str(final_mz_val_u(i_n)))%subplot(3,3,i);
% else
title(strcat('\it m/z \rm  ==',num2str(final_mz_val(i_n))))%subplot(3,3,i);    
end
if i_n == 1 && (fig_no == no_of_images_per_page)
% if image_window_to_display_value == 1
export_fig('trial.pdf', figure(1))%handles.zone_specified_plot)
% else
% export_fig('trial.pdf', figure(1))%handles.zone_specified_plot2)
% end
elseif (fig_no == no_of_images_per_page)
% if image_window_to_display_value == 1
export_fig('trial.pdf', figure(1),'-append') 
elseif ii == size(final_mz_val,1)
    export_fig('trial.pdf', figure(1),'-append')
% else
% export_fig('trial.pdf', handles.zone_specified_plot2,'-append')   
% end
end
% if i_n == 25;
%     break;
% end
% k = k2; 
    %%
    fig_no = fig_no + 1;
    if fig_no > no_of_images_per_page
        fig_no = 1;
    end
    time_taken = toc; fprintf('Estimated time remaining is %f \n', time_taken*abs(ii-size(final_mz_val,1)))
end
fprintf('PDF Saved !!! \n')
cd(current_dir)
close(figure(1))
% close(h)
