function create_new_matrix_from_isos_using_reduced_mz_list(number_of_scans, filename, uz4, uz4_3,isos_dir)
global O_was_present mass int index no_of_mz_vals_from_list_length start_point count_temp en ll
global col_no int_temp no_of_mz_vals_from_list m_list_step2 m_list_step1 pathname %max_num keep_point_count new_matrix matrix_start2
current_dir = pwd;
cd(isos_dir)
t1 = tic;
for file_no = 1:number_of_scans
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
number_of_point_count_per_scan = dlmread(fake_name2,'\t',1,1);%csvread(fake_name2,1,0);    
number_of_point_count_per_scan2 = number_of_point_count_per_scan(:,1);
max_num(file_no) = max(number_of_point_count_per_scan2(:));
end
time_for_max_num_list_for_all_scans = toc(t1); fprintf('time_for_max_num_list_for_all_scans is %f \n', time_for_max_num_list_for_all_scans);
if (~isdeployed);addpath(strcat(pathname,'CDf_Files'));end
t2 = tic;
ss = sum(max_num(:)); % 8226.....first line has 455 scans, 2nd 456, 3rd 463 etc....sum of all the scans is 8226
installment = 1:100:ss;
newFileObj = matfile('matrix.mat');
matrix_start_temp = zeros(size(m_list_step2,1),100,'single');
for installment_i = 1:size(installment,2)
    newFileObj.matrix(size(m_list_step2,1),installment_i:installment_i+99) = matrix_start_temp(size(matrix_start_temp,1),size(matrix_start_temp,2));
end
if ss > installment(end)
    matrix_start_temp = zeros(size(m_list_step2,1),(ss-installment(end)),'single');
    newFileObj.matrix(size(m_list_step2,1),installment(end):ss) = matrix_start_temp(size(matrix_start_temp,1),size(matrix_start_temp,2));    
end
time_taken = toc(t2); fprintf('time_to_save_matrix_of_zeros is %f \n', time_taken);
col_no = 1; 
%%
keep_point_count = 0;%[];
t3 = tic;
for file_no = 1:number_of_scans%15
    t4 = tic;
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
number_of_point_count_per_scan = dlmread(fake_name2,'\t',1,1);%csvread(fake_name2,1,0);    
mass = (number_of_point_count_per_scan(:,2));%4
int = (number_of_point_count_per_scan(:,3));
number_of_point_count_per_scan2 = number_of_point_count_per_scan(:,1);
max_num2 = max(number_of_point_count_per_scan2(:));
point_count = zeros(max_num2,1,'single');
for i = 1:max_num2
    point_count(i) = size(find(number_of_point_count_per_scan2 == i),1);
end
%%
count_temp = 1;
matrix_start_temp2 = zeros(size(uz4,1),size(point_count,1),'single');
for no_of_mz_vals_from_list_length = 1: size(point_count,1)%(num_of_each_scans)
    if no_of_mz_vals_from_list_length > 1
    start_point = sum(point_count(1:no_of_mz_vals_from_list_length-1)) + 1;
    else
    start_point = 1;
    end
no_of_mz_vals_from_list = start_point: (start_point + point_count(count_temp)-1);
int_temp = int(no_of_mz_vals_from_list);
[C,ia,ib] = intersect(uz4,mass(no_of_mz_vals_from_list));
index = ib; %disp(index)
en = size(mass(no_of_mz_vals_from_list));%disp(no_of_mz_vals_from_list_length)
    matrix_start_temp2(ia, col_no) = int_temp(index);
%     end
    col_no = col_no + 1;
    count_temp = count_temp + 1;
end
time_step0_get_whole_matrix = toc(t4); fprintf('time_step0_get_whole_matrix_is %f \n', time_step0_get_whole_matrix)
%%
%% Reducing UZ4 part 1
% t5 = tic;
% start = 1;
% new_matrix = zeros(size(m_list_step1,1),size(matrix_start_temp2,2),'double');
% for i = 1:size(m_list_step1,1)
%     if start < m_list_step1(i)
%     new_matrix(i,:) = max(matrix_start_temp2(start:m_list_step1(i),:));
%     else
%     new_matrix(i,:) = (matrix_start_temp2(start,:));        
%     end
%     start = m_list_step1(i) + 1;
% end
% time_step1 = toc(t5); fprintf('time_step1_is %f \n', time_step1)
new_matrix = matrix_start_temp2;
%%
%% Reducing UZ4 part 2
t6 = tic;
matrix_start2 = zeros(size(m_list_step2,1),size(new_matrix,2),'single');
m_list_step2 = flipud(m_list_step2);
for i = 1:size(m_list_step2,1)
if (m_list_step2(i,2) - m_list_step2(i,1)) > 0
    new_int = max(new_matrix(m_list_step2(i,1):m_list_step2(i,2),:));
else
    new_int = (new_matrix(m_list_step2(i,1),:));
end
    matrix_start2(i,:) = new_int;
end
time_step2 = toc(t6); fprintf('time_step2_is %f \n', time_step2)
%%
t7 = tic;
fprintf('file no %f \n',file_no)
fprintf('loc1 %f \n',size(m_list_step2,1))
fprintf('loc2 %f and %f \n',sum(keep_point_count(:))+1,(sum(keep_point_count(:))+1+max_num(file_no)-1))
fprintf('loc3 %f and %f \n',size(matrix_start2,1),size(matrix_start2,2))
newFileObj.matrix(1:size(m_list_step2,1),sum(keep_point_count(:))+1:(sum(keep_point_count(:))+1+max_num(file_no)-1)) = matrix_start2(1:size(matrix_start2,1),1:size(matrix_start2,2));
time_save_part_of_matrix = toc(t7); fprintf('time_save_part_of_matrix_is %f \n', time_save_part_of_matrix)
col_no = 1;
keep_point_count(file_no) = max_num(file_no);
end
time_for_whole_loop = toc(t3); fprintf('time_for_whole_loop_is %f \n',time_for_whole_loop)
cd(current_dir)

