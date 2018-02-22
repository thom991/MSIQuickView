function [max_num] = pdfs_for_full_matrix(number_of_scans, filename,isos_dir,matrix_file)
%% This function generates a single multipage pdf for a full matrix, which currently is output from Josh's code.
% Inputs: 
%   number_of_scans : Total number of lines in the image
%   filename : name of the first raw filename without path
%   isos_dir : location for the isos_dir output from Decon2LS
%   matrix_file : entire matrix output from Josh's program
global O_was_present M ll
%C:\Users\thom991\Desktop\ingela_Public\msi_1
%30
%d_nic01.raw
%C:\Users\thom991\Desktop\ingela_Public\msi_1\msi_1_alignment_full
%[max_num] = pdfs_for_full_matrix(30, 'd_nic01.raw','C:\Users\thom991\Desktop\ingela_Public\msi_1','C:\Users\thom991\Desktop\ingela_Public\msi_1\msi_1_alignment_full.txt')
%% To find Unique list of mz values from all the ISOS CSV files
% uz2 = [];
count_new = 1;
% current_dir = pwd;
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
            fake_name2(end-3:end+6) = '_peaks.txt'; 
number_of_point_count_per_scan = dlmread(fake_name2,'\t',1,1);
% list_mz = (number_of_point_count_per_scan(:,2));%4
% unique_mz_vals = unique(list_mz);
% uz4 = [uz2;unique_mz_vals];
% uz4 = unique(uz4);
% uz2 = uz4;
number_of_point_count_per_scan2 = number_of_point_count_per_scan(:,1);
max_num(count_new) = max(number_of_point_count_per_scan2(:));
count_new = count_new + 1;
estimated_time_remaining = toc(t1).*(number_of_scans - file_no);
fprintf('Estimated time is %f seconds \n',estimated_time_remaining)
end
ss = max(max_num(:));
% for i = 1:ss
%%
%Read mz values column only
fid = fopen('msi_1_alignment_full.txt');
mz_data = textscan(fid, '%f %*[^\n]','HeaderLines',0, 'Delimiter','\t', 'BufSize',1000000);
fid = fclose(fid);
mz_data = mz_data{1,1};
%Read int values column only
M = dlmread(matrix_file,'\t',[51480 1 51499 sum(max_num(:))]);
%%
% M = dlmread(matrix_file,'\t');
   template = zeros(number_of_scans,ss,'single'); 
% end
count = 1;
for i = 1:5000%size(M,1)
   sprintf('%f of %f',i,size(M,1))
mz_val = M(i,1);
int_val = M(i,2:size(M,2));
for j = 1:size(max_num,2)
   if j == 1
       h = figure(1);
       set(h, 'Visible','off')
       sum_of_intensities = template;
       sum_of_intensities(1,1:max_num(1)) = int_val(1,1:max_num(1));
   else
%        disp(j); disp(max_num(j)); disp(max_num(j-1));
%        disp(max_num(j-1)+1); disp(max_num(j-1)+max_num(j));
       sum_of_intensities(j,1:max_num(j)) = int_val(1,max_num(j-1)+1:max_num(j-1)+max_num(j));
   end
end
%    imwrite(sum_of_intensities,'your_hdf_file.gif','WriteMode','append')
subplot(5,2,count); imagesc(sum_of_intensities); title(strcat('mz = ', num2str(mz_val)))
% pause(.5)
if count == 10 || i == size(M,1)
   count = 0; 
   if i == 10;
   export_fig(strcat(filename(1:end-3),'pdf'), h)
   clf(h)
   else
   export_fig(strcat(filename(1:end-3),'pdf'), h,'-append')  
   clf(h)
   end
end
count = count + 1;
end
close(h)
