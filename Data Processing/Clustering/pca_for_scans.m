%%
function final_mz_val = pca_for_scans
global O_was_present number_of_scans first_filename pathname fake_first_filename k2 range_selected m n imp_mass
global fake_name2 k ll
m_temp = [];
size1 = [];
% k = get(handles.start_with_line_number_editbox,'string');
% k = single(str2num(k));
% k2 = k;
k = k2;
column_number = 1;
%
current_dir = pwd;
fake_first_filename = strcat(first_filename,'_scans');
fake_first_filename(end-9:end) = '_scans.RAW';
fake_name2 = fake_first_filename;
filename = fake_name2;
%         cdf_begin = strcat('C:\delete\',fake_name2);
%         cdf_filename = [cdf_begin(1:end-4) '.mat' ]; 
% fake_name2(1:size(filename,2)-5) = filename(1:size(filename,2)-5); 
%     cd(pathname);
%     sum_of_intensities_try55 = zeros(size(sum_of_intensities,1),size(sum_of_intensities,2),'single');
%     k = 1;
% k = get(handles.start_with_line_number_editbox,'string');
% k = single(str2num(k));
% list_mz_val = zeros(highest_row_val,number_of_scans);
    for i = 1:number_of_scans
                        fake_name2 = ll{1,k};
            fake_name2(end-3:end+6) = '_scans.csv';
%         if k < 10
%             fake_name2(size(filename,2)-10) = num2str(k);
%             fake_name2(size(filename,2)-9:size(filename,2)) = '_scans.csv';
%         else
%             disp(filename(size(filename,2)-11))
%             if k == 10 && strcmp(filename(size(filename,2)-11),'0')
%             fake_name2(size(filename,2)-11:size(filename,2)-10) = num2str(k);
%             fake_name2(size(filename,2)-9:size(filename,2)) = '_scans.csv'; 
%             O_was_present = 1;
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-11:size(filename,2)-10) = num2str(k);
%             fake_name2(size(filename,2)-9:size(filename,2)) = '_scans.csv';                 
%             else
%             fake_name2(size(filename,2)-10:size(filename,2)-9) = num2str(k);
%             fake_name2(size(filename,2)-8:size(filename,2)) = '_scans.csv';   
%             end
%         end             
        RAW_filename_new2 = strcat('C:\Users\thom991\Desktop\Mass Spect\ingela_nic_brain',fake_name2);
%         cdf_begin = strcat('C:\delete\',fake_name2);
%         load(RAW_filename_new2);
%             load(strcat('C:\delete_mat_files\',fake_name2(1:end-4),'_mz_values.mat'));    
%             load(strcat('C:\delete_mat_files\',fake_name2(1:end-4),'_sure1_time.mat'));    
%             sure1 = sure1_for_time;
%             list_mz_val(1:size(mass_values_list,1),k) = mass_values_list;
            k = k + 1;
%     end
%     final_list_mz_values = unique(list_mz_val);
% %     cd(current_dir);
% k = get(handles.start_with_line_number_editbox,'string');
% k = single(str2num(k));
% k2 = k;
% list_mz_val = zeros(highest_row_val,number_of_scans);
%     for i = 1:count_2-1
%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.mat';
%         else
%             if k == 10 && fake_name2(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.mat'; 
%             O_was_present = 1;
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.mat';                 
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.mat';   
%             end
%         end             
%         RAW_filename_new2 = strcat('C:\delete_mat_files\',fake_name2);
% %         cdf_begin = strcat('C:\delete\',fake_name2);
% %         load(RAW_filename_new2);
%             load(strcat('C:\delete_mat_files\',fake_name2(1:end-4),'_mz_values.mat'));    
%             load(strcat('C:\delete_mat_files\',fake_name2(1:end-4),'_sure1_time.mat'));    
%             sure1 = zeros(size(final_list_mz_values,1), size(sure1_for_time,2),'single');
%     end
%
fid = fopen(strcat(pathname,fake_name2));
C = textscan(fid,'%*s %*s %*s %*s %f %*[^\n]', 'delimiter',',','HeaderLines',1);
m1 = C{1,1};
fclose(fid);
m = [m_temp;m1];
m_temp = m;
unique_vals = unique(m);
if i == 1   
matrx_temp = zeros(size(m1,1)+50,3);
end
matrx_temp(1:size(m1,1),column_number) = m1;
size2 = size(m1,1);
new_size = max([size1,size2]);
size1 = new_size;
column_number = column_number+1;
    end
%%
    
matrx_temp(new_size+1:end,:) = [];    
% matrx = zeros(new_size,3);
matrx2 = zeros(size(matrx_temp,1),size(matrx_temp,2));
% for col = 1:size(matrx_temp,2)
% matrx(1:size(matrx_temp(:,col),1),1) = matrx_temp(:,col);
% end
% matrx(1:size(m2,1),2) = m2;
% matrx(1:size(m3,1),3) = m3;
for column_number = 1:size(matrx_temp,2)
% for i = 1:size(x,2)
% m = []; n = [];location = [];
    [m,n] = ismember(unique_vals,matrx_temp(:,column_number));
    n(n==0) = [];
% end
% z = zeros(size(x,1),1);
number_of_ones = size(m(m == 1));
if number_of_ones(1) > 1
location = find(m == 1);
for j = 1:number_of_ones(1)
    matrx2(location(j),column_number) = matrx_temp(n(j),column_number);
%     sure1_check(location(j),column_number) = sure1_mass(n(j),column_number); 
%     row_num = row_num + 1;
%     if row_num > size(sure1,1)
%         row_num = 1;
%     end
end
end
end

[coefs,scores,variances,t2] = princomp(matrx2);
[st2, index] = sort(t2,'descend');
for i = 1:size(index,1)
extreme(i,1) = index(i);
% extreme(1,2) = index(2);
% extreme(1,3) = index(3);
% extreme(1,4) = index(4);
% extreme(1,5) = index(5);
% extreme(1,6) = index(6);
% extreme(1,7) = index(7);
% extreme(1,8) = index(8);
% extreme(1,9) = index(9);
% extreme(1,10) = index(10);
imp_mass(i,1) = unique_vals(extreme(i,1),:);
end

try1 = round(imp_mass);
[m,n] = unique(try1);
n = sort(n);
if range_selected == 1
    for u = 1:size(n,1)
        final_mz_val(u) = imp_mass(n(u));
        if u < size(n,1)
            final_mz_val_u(u) = imp_mass(n(u+1)-1);
        else
            final_mz_val_u(u) = imp_mass(end);
        end
    end
else
for u = 1:size(n,1)
    final_mz_val(u) = imp_mass(n(u));
end
end

% ab = sum_of_intensities2; nColors = 6; nrows = size(sum_of_intensities,1); ncols = size(sum_of_intensities,2);
% ab = reshape(ab,nrows*ncols,1);
% [cluster_idx cluster_center] = kmeans(ab,nColors,'replicates',2);
% pixel_labels = reshape(cluster_idx,nrows,ncols);
% figure;imagesc(pixel_labels)
% p1 = ismember(pixel_labels,1); BW1 = bwareaopen(p1, 10);
% figure;subplot(6,2,1);imagesc(p1);
% subplot(6,2,2);imagesc(BW1);
% p2 = ismember(pixel_labels,2); BW2 = bwareaopen(p2, 10);
% subplot(6,2,3);imagesc(p2)
% subplot(6,2,4);imagesc(BW2);
% p3 = ismember(pixel_labels,3); BW3 = bwareaopen(p3, 10);
% subplot(6,2,5);imagesc(p3);
% subplot(6,2,6);imagesc(BW3);
% p4 = ismember(pixel_labels,4); BW4 = bwareaopen(p4, 10);
% subplot(6,2,7);imagesc(p4);
% subplot(6,2,8);imagesc(BW4);
% p5 = ismember(pixel_labels,5); BW5 = bwareaopen(p5, 10);
% subplot(6,2,9);imagesc(p5);
% subplot(6,2,10);imagesc(BW5);
% p6 = ismember(pixel_labels,6); BW6 = bwareaopen(p6, 10);
% subplot(6,2,11);imagesc(p6);
% subplot(6,2,12);imagesc(BW6);
