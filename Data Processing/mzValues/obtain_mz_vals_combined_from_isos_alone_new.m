function [uz4_2, uz2] = obtain_mz_vals_combined_from_isos_alone_new(number_of_scans, filename,isos_dir)
global O_was_present ll
%% To find Unique list of mz values from all the ISOS CSV files
uz2 = [];
count_new = 1;
current_dir = pwd;
cd(isos_dir)
for file_no = 1:number_of_scans
    t1 = tic;
    k = file_no;
                    fake_name2 = ll{1,k};
            fake_name2(end-3:end+6) = '_peaks.csv';
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
        disp(fake_name2)
number_of_point_count_per_scan = dlmread(fake_name2,'\t',1,1);
list_mz = (number_of_point_count_per_scan(:,2));%4
unique_mz_vals = unique(list_mz);
uz4_2 = [uz2;unique_mz_vals];
uz4_2 = unique(uz4_2);
uz2 = uz4_2;
number_of_point_count_per_scan2 = number_of_point_count_per_scan(:,1);
max_num(count_new) = max(number_of_point_count_per_scan2(:));
count_new = count_new + 1;
estimated_time_remaining = toc(t1).*(number_of_scans - file_no);
fprintf('Estimated time is %f seconds \n',estimated_time_remaining)
end
fprintf('Size of original mz list is %d \n',size(uz4_2))
cd(current_dir)

% count = 1;
% uz4_2_backup = uz4_2;
% uz42 = zeros(size(uz4_2,1),1,'single');
% m_list_step2 = zeros(size(uz4_2,1),2,'single');
% while count <= size(uz4_2,1)
% current_mz_val = uz4_2(count);
% tol_limit = 1;%user_entered_val.*sqrt(current_mz_val/100);
% lower_limit = current_mz_val - tol_limit;
% upper_limit = current_mz_val + tol_limit;
% [m_tol,n_tol] = find(uz4_2 >= lower_limit & uz4_2 <= upper_limit);
% m_list_step2(count,1) = m_tol(end);
% m_list_step2(count,2) = m_tol(1);
% if size(m_tol,1) > 1
%     new_mz = mean(uz4_2(m_tol(1):m_tol(end)));
%     uz42(count) = new_mz;
%     uz4_2(m_tol(end)) = new_mz;
%     uz4_2(m_tol(1):(m_tol(end)-1)) = [];
%     count = count + 1;
% else
%     uz42(count) = uz4_2(m_tol(1));
%     count = count + 1;
% end
% if count >= size(uz4_2,1)
%     uz42(count:end) = []; 
%     m_list_step2(count:end,:) = [];
% end
% end



% count = 1;
% uz4_2_backup = uz4_2;
% while i <= size(uz4_2,1)
% current_mz_val = uz4_2(count);
% tol_limit = user_entered_val.*sqrt(current_mz_val/100);
% lower_limit = current_mz_val - tol_limit;
% upper_limit = current_mz_val + tol_limit;
% [m_tol,n_tol] = find(uz4_2 >= lower_limit & uz4_2 <= upper_limit);
% m_list_step2(count,1) = m_tol(end);
% m_list_step2(count,2) = m_tol(1);
% if size(m_tol,1) > 1
%     new_mz = mean(uz4_2(m_tol(1):m_tol(end)));
%     uz42(count) = new_mz;
%     count = count + 1;
% else
%     uz42(count) = uz4_2(m_tol(1));
%     count = count + 1;
% end
% i = m_tolerance_uz4(end)+1;
% end

% uz2_diff = diff(uz2);
% [pks,locs] = findpeaks(uz2_diff,'THRESHOLD',0.00005);
% locs(end+1) = size(uz2,1);
% current_loc = 1;
% %plot ??
% for numbr_of_locs = 1:size(locs,1)
%     mz_means_list_for_each_block(numbr_of_locs) = mean(uz2(current_loc:locs(numbr_of_locs)));
%     current_loc = locs(numbr_of_locs) + 1;
% end

% count = 1;
% current_loc = 1;
% % mz_rows_to_remove = zeros(size(uz2,1), 1, 'single');
% for numbr_of_locs = 1:size(locs,1)
% current_mz_val = mz_means_list_for_each_block(numbr_of_locs);
% tol_limit = 0.0005.*sqrt(current_mz_val/100);
% lower_limit = current_mz_val - tol_limit;
% upper_limit = current_mz_val + tol_limit;
% [m_tol,n_tol] = find(uz2(current_loc:locs(numbr_of_locs)) >= lower_limit & uz2(current_loc:locs(numbr_of_locs)) <= upper_limit);
% disp(size(m_tol))
% if isempty(m_tol)
%    m_tol(1) = current_loc;
%    m_tol(end) = locs(numbr_of_locs);
%    starting_point = m_tol(1);
%    ending_point = m_tol(end);    
% else
% if numbr_of_locs > 1
% m_tol = m_tol+locs(numbr_of_locs-1);    
% % m_tol = m_tol(end)+locs(numbr_of_locs-1);
% starting_point = m_tol(1);
% ending_point = m_tol(end);
% else
% starting_point = m_tol(1);
% ending_point = m_tol(end);    
% end
% end
% size_start = size(uz2(current_loc:(starting_point-1)),1);
% size_end = size(uz2((ending_point+1):locs(numbr_of_locs)),1);
% mz_rows_to_remove(count:(count+size_start+size_end - 1),1) = [(current_loc:(m_tol(1)-1)), ((m_tol(end)+1):locs(numbr_of_locs))];
% current_loc = locs(numbr_of_locs) + 1;
% count = count+size_start+size_end;
% end
% uz2(mz_rows_to_remove) = [];




