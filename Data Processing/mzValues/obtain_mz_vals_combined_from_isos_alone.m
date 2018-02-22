function [uz4, uz4_3] = obtain_mz_vals_combined_from_isos_alone(number_of_scans, filename,isos_dir)
global O_was_present diff_uz4 uz42 m_tolerance_uz4 m_list_step1 m_list_step2 new_mz_uz4 m_list_step3 uz4 ll
%% To find Unique list of mz values from all the ISOS CSV files
uz2 = [];
count_new = 1;
current_dir = pwd;
cd(isos_dir)
for file_no = 1:number_of_scans
    t1 = tic;
    k = file_no;
%            fake_name2 = filename; 
%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)+6) = '_peaks.txt';%'_isos.csv';
%         else
%             if k == 10 && fake_name2(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)+6) = '_peaks.txt';%'_isos.csv'; 
%             O_was_present = 1;
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)+6) = '_peaks.txt';%'_isos.csv';                 
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+7) = '_peaks.txt';%'_isos.csv';   
%             end
%         end     
                fake_name2 = ll{1,k};
            fake_name2(end-3:end+6) = '_peaks.csv';
number_of_point_count_per_scan = dlmread(fake_name2,'\t',1,1);
list_mz = (number_of_point_count_per_scan(:,2));%4
unique_mz_vals = unique(list_mz);
uz4 = [uz2;unique_mz_vals];
uz4 = unique(uz4);
uz2 = uz4;
number_of_point_count_per_scan2 = number_of_point_count_per_scan(:,1);
max_num(count_new) = max(number_of_point_count_per_scan2(:));
count_new = count_new + 1;
estimated_time_remaining = toc(t1).*(number_of_scans - file_no);
fprintf('Estimated time is %f seconds \n',estimated_time_remaining)
end
fprintf('Size of original mz list is %d \n',size(uz4))
%% Reducing UZ4 part 1
% disp('Step 1')
% diff_uz4 = diff(uz4);
% diff_uz4 = diff_uz4/min(diff_uz4(:));
% fprintf('Diff list is')
% % disp(diff_uz4)
% figure(1);plot(diff_uz4);
% % f = figure;
% h = uicontrol('Position',[20 20 200 40],'String','Continue',...
%               'Callback','uiresume(gcbf)');
% disp('This will print immediately');
% uiwait(gcf); 
% disp('This will print after you click Continue');
% close(figure(1));
% prompt = {'Difference Value:','Threshold Limit:'};
% dlg_title = 'Please Enter the following';
% num_lines = 1;
% def = {'2','0'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
% diff_val = str2num(answer{1,1});
% user_entered_val = str2num(answer{2,1});
% [m_diff_uz4,n_diff_uz4] = find(diff_uz4 > diff_val); %m is the req
% start = 1;
% new_mz_uz4 = zeros(size(m_diff_uz4,1),1,'double');
% for i = 1:size(m_diff_uz4,1)
%     if start < m_diff_uz4(i)
%     new_mz_uz4(i) = mean(uz4(start:m_diff_uz4(i)));
%     else
%     new_mz_uz4(i) = (uz4(start));
%     end
%     start = m_diff_uz4(i) + 1;
% end
% m_list_step1 = m_diff_uz4;
% uz4_2 = new_mz_uz4;
% fprintf('Size of mz list after step 1 is %d \n',size(uz4_2))
uz4_2 = uz4;
m_list_step1 = uz4;
%%
%% Reducing UZ4 part 2
disp('Step 2')
user_entered_val = 0.0005;%str2double(get(handles.diff_btw_2_mz_vals, 'String'));
uz4_2 = flipud(uz4_2);
t2 = tic;
count = 1;
uz42 = zeros(size(uz4_2,1),2,'single');
i = 1;
while i <= size(uz4_2,1)
current_mz_val = uz4_2(i);
tolerance_limit = user_entered_val.*sqrt(current_mz_val/100);
lower_tolerance_limit = current_mz_val - tolerance_limit;
higher_tolerance_limit = current_mz_val + tolerance_limit;
[m_tolerance_uz4,n_tolerance_uz4] = find(uz4_2 >= lower_tolerance_limit & uz4_2 <= higher_tolerance_limit);
m_list_step2(count,1) = m_tolerance_uz4(end);
m_list_step2(count,2) = m_tolerance_uz4(1);
if size(m_tolerance_uz4,1) > 1
%     tic
    new_mz = mean(uz4_2(m_tolerance_uz4(1):m_tolerance_uz4(end)));
%     new_int = max(matrix_start(m_tolerance_uz4(1):m_tolerance_uz4(end),:));
    uz42(count) = new_mz;
%     matrix_start2(count,:) = new_int;
    count = count + 1;
%     iff_cm = toc; disp('iff_cm');disp(iff_cm);
else
    uz42(count) = uz4_2(m_tolerance_uz4(1));
%     matrix_start2(count,:) = matrix_start(m_tolerance_uz4(1),:);
    count = count + 1;
end
i = m_tolerance_uz4(end)+1;
if i == size(uz4_2,1)
    uz42(count:end) = []; 
%     matrix_start2(count:end,:) = [];
end
% single_for_loop = toc; disp('single_for_loop');disp(single_for_loop)

end
% matrix_start = flipud(matrix_start2);
uz4_3 = flipud(uz42');
% m_list_step2 = abs(m_list_step2 - (size(m_list_step1,1)+1)); %INCLUDE if
% STEP 1 is used
val = find(m_list_step2(:,2) > m_list_step2(:,1));
m_list_step3(1:size(val,1),:) = m_list_step2(val,:); 
step_2 = toc(t2); fprintf('time for step 2 is %f \n',step_2)
% m_list_step2 = flipud(m_list_step2);
% disp('step2_uz4');disp(size(uz4_3))
fprintf('Size of mz list after step 2 is %d \n',size(uz4_3))
% set(handles.matrix_size_rows, 'string', num2str(size(matrix_start,1)))
% set(handles.matrix_size_columns, 'string', num2str(size(matrix_start,2)))
% set(handles.uitable_values_cluster, 'Data', matrix_start)
% current_dir = pwd;
% cd(filename5)
% % xlswrite('matrix2.xlsx',matrix_start)
% if exist('uz42.xlsx','file')
% % delete('matrix.xlsx')
% delete('uz42.xlsx')
% end
% xlswrite('uz42.xlsx',uz4)
% save matrix2.mat matrix_start
% save uz42.mat uz4
% cd(current_dir)
% % set(handles.uitable_values_cluster, 'Data', matrix_start)
% close(h)
% disp(count)
disp('Done !')
%%
save 'uz4.mat' uz4 uz4_3
xlswrite('mz_list.xlsx',uz4, 'Org List')
xlswrite('mz_list.xlsx',uz4_2, 'After_diff')
xlswrite('mz_list.xlsx',uz4_3, 'Aftr_tol')
% uz4 = uz4_3;
cd(current_dir)
