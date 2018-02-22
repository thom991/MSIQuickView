function [uz2,rows_to_remove] = generate_mz_rows_to_remove(uz2,locs, mz_means_list_for_each_block, tol_val, start_end_loc_for_means)
global mz_rows_to_group_together count_rows_to_combine count_rows_to_remove count_mean_rows_to_remove list_of_rows_to_combine list_of_rows_to_remove list_of_mean_rows_to_remove
count = 1;
count2 = 1;
current_loc = 1;
count_rows_to_combine = 1;
count_rows_to_remove = 1;
count_mean_rows_to_remove = 1;
% mz_rows_to_remove = zeros(size(uz2,1), 1, 'single');
for numbr_of_locs = 1:size(locs,1)
%     disp(numbr_of_locs)
t1 = tic;
current_mz_val = mz_means_list_for_each_block(numbr_of_locs);
tol_limit = tol_val.*sqrt(current_mz_val/100);
lower_limit = current_mz_val - tol_limit;
upper_limit = current_mz_val + tol_limit;
[m_tol2,n_tol] = find(uz2 >= lower_limit & uz2 <= upper_limit);
m_tol_list = current_loc:locs(numbr_of_locs);
m_tol = intersect(m_tol_list,m_tol2);
loc_list = start_end_loc_for_means(count2,1):start_end_loc_for_means(count2,2);
rows_to_combine = intersect(m_tol,loc_list);
rows_to_remove = setxor(m_tol,loc_list);
mean_rows_to_remove = rows_to_combine(2:end);
% toc(t1); fprintf('Time1 is %f',num2str(t1));
% disp(rows_to_remove);
% disp(size(rows_to_remove));
% if size(rows_to_remove,2) > 0
% t2 = tic;
list_of_rows_to_combine(count_rows_to_combine,1) = rows_to_combine(1);
list_of_rows_to_combine(count_rows_to_combine,2) = rows_to_combine(end);
count_rows_to_combine = (count_rows_to_combine+1);
% end
list_of_rows_to_remove(count_rows_to_remove:(count_rows_to_remove+(size(rows_to_remove,2)-1)),1) = rows_to_remove;
list_of_mean_rows_to_remove(count_mean_rows_to_remove:(count_mean_rows_to_remove+(size(mean_rows_to_remove,2)-1)),1) = mean_rows_to_remove;
count_rows_to_remove = (count_rows_to_remove+size(rows_to_remove,2));
count_mean_rows_to_remove = (count_mean_rows_to_remove+size(mean_rows_to_remove,2));
% toc(t2); fprintf('Time2 is %f',num2str(t2));
% disp(size(m_tol))
% if isempty(m_tol)
%    m_tol(1) = current_loc;
%    m_tol(end) = locs(numbr_of_locs);
%    starting_point = m_tol(1);
%    ending_point = m_tol(end);    
% else
% if numbr_of_locs > 1
% m_tol = m_tol+locs(numbr_of_locs-1);    
% % % m_tol = m_tol(end)+locs(numbr_of_locs-1);
% % starting_point = m_tol(1);
% % ending_point = m_tol(end);
% % else
% % starting_point = m_tol(1);
% % ending_point = m_tol(end);    
% end
% end
% size_start = size(uz2(current_loc:(starting_point-1)),1);
% size_end = size(uz2((ending_point+1):locs(numbr_of_locs)),1);
% mz_rows_to_remove(count:(count+size_start+size_end - 1),1) = [(current_loc:(m_tol(1)-1)), ((m_tol(end)+1):locs(numbr_of_locs))];
current_loc = locs(numbr_of_locs) + 1;
% count = count+size_start+size_end;

% mz_rows_to_group_together(count2,1) = m_tol(1);
% mz_rows_to_group_together(count2,2) = m_tol(end);
count2 = count2+1;
time1 = toc(t1); %fprintf('Time_Left is %f \n',num2str(tt));
tt = (time1.*(size(locs,1)-numbr_of_locs))./60;
disp(tt)
end
% uz2(mz_rows_to_remove) = [];