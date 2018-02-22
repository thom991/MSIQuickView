function [matrix_start] = create_new_matrix_from_hdfs_using_reduced_mz_list(number_of_scans, filename, uz4, store_size)
global O_was_present mass int index no_of_mz_vals_from_list_length start_point count_temp en pathname
% matrix_start = [];
% tic
if (~isdeployed);addpath(strcat(pathname,'HDF_Filename'));end
matrix_start = zeros(store_size(1),store_size(2),'single');
col_no = 1; 
current_dir = pwd;
cd(strcat(pathname,'HDF_Filename'));
for i = 1:number_of_scans%1:15
% disp('scan_num'); disp(i);    
k = i;
count_temp = 1;
fake_name2 = ll{1,k};
fake_name2(end-3:end) = '.hdf';    

%        fake_name2 = filename; 
%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.hdf';
%         else
%             if k == 10 && fake_name2(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.hdf'; 
%             O_was_present = 1;
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.hdf';                 
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.hdf';   
%             end
%         end     
hdf_filename = fake_name2;   
% disp(hdf_filename)
% if i<10
% hdf_filename = strcat('nic0',num2str(i),'.hdf');
% hdf_filename = strcat('nic',num2str(i),'.hdf');
% end
mass = double(hdf5read(hdf_filename,'mass_values'));
int = double(hdf5read(hdf_filename,'intensity_values'));
point_count = double(hdf5read(hdf_filename,'point_count'));
%     disp(size(point_count,1));
for no_of_mz_vals_from_list_length = 1: size(point_count,1)%(num_of_each_scans)
%     disp(no_of_mz_vals_from_list_length);
    if no_of_mz_vals_from_list_length > 1
    start_point = sum(point_count(1:no_of_mz_vals_from_list_length-1)) + 1;
    else
    start_point = 1;
    end
    %disp('start_point=='); disp(start_point); disp(':'); disp((start_point + vals_for_each_scan(count_temp)-1));
%     disp(start_point); disp((start_point + point_count(count_temp)-1))
%     for 
no_of_mz_vals_from_list = start_point: (start_point + point_count(count_temp)-1);
%     t10 = tic;    
int_temp = int(no_of_mz_vals_from_list);
[C,ia,ib] = intersect(uz4,mass(no_of_mz_vals_from_list));
index = ib; %disp(index)
%     index = find(uz4 == mass(no_of_mz_vals_from_list)); disp(index)
% [N,bin]=histc(mass(no_of_mz_vals_from_list),uz4);
%     index=bin+1;
% %     if abs(mass(no_of_mz_vals_from_list)-uz4(bin))<abs(mass(no_of_mz_vals_from_list)-uz4(bin+1))
% %         fclosest=uz4(bin)
% %         index=bin;
% %     else
% %         fclosest=uz4(index)
% %     end
% %     te = toc(t10); disp(te)
en = size(mass(no_of_mz_vals_from_list));%disp(no_of_mz_vals_from_list_length)
    matrix_start(:, col_no) = int_temp(index);
%     end
    col_no = col_no + 1;
    count_temp = count_temp + 1;
end
%% OLD METHOD
% for no_of_mz_vals_from_list_length = 1: size(point_count,1)%(num_of_each_scans)
% %     disp(no_of_mz_vals_from_list_length);
%     if no_of_mz_vals_from_list_length > 1
%     start_point = sum(point_count(1:no_of_mz_vals_from_list_length-1)) + 1;
%     else
%     start_point = 1;
%     end
%     %disp('start_point=='); disp(start_point); disp(':'); disp((start_point + vals_for_each_scan(count_temp)-1));
% %     disp(start_point); disp((start_point + point_count(count_temp)-1))
%     for no_of_mz_vals_from_list = start_point: (start_point + point_count(count_temp)-1)
% %     t10 = tic;    
% % [C,ia,ib] = intersect(uz4,mass(no_of_mz_vals_from_list));
% % index = ib; disp(index)
%     index = find(uz4 == mass(no_of_mz_vals_from_list)); disp(index)
% % [N,bin]=histc(mass(no_of_mz_vals_from_list),uz4);
% %     index=bin+1;
% % %     if abs(mass(no_of_mz_vals_from_list)-uz4(bin))<abs(mass(no_of_mz_vals_from_list)-uz4(bin+1))
% % %         fclosest=uz4(bin)
% % %         index=bin;
% % %     else
% % %         fclosest=uz4(index)
% % %     end
% % %     te = toc(t10); disp(te)
%     matrix_start(index, col_no) = int(no_of_mz_vals_from_list);
%     end
%     col_no = col_no + 1;
%     count_temp = count_temp + 1;
% end
%%
end
cd(current_dir)

