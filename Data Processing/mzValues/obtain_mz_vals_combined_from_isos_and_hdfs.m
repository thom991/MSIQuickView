function [uz4] = obtain_mz_vals_combined_from_isos_and_hdfs(number_of_scans, unique_list_hdf_final, filename, isos_dir)
%% For example, mz values in a list are 160, 170, 180, 190..I have a value x = 168...
%and want to determine the closest value to x within the list.....
% tic
global O_was_present ll
if matlabpool('size') == 0
    matlabpool open
end
% fprintf('Begin Step 2 of 5.... \n')
%% To find Unique list of mz values from all the ISOS CSV files
% tic
uz2 = [];
count_new = 1;
count_file_no = 1;
% number_of_scans = varargin(1);
% unique_list_hdf_final = varargin(2);
% filename = varargin(3);
% disp(number_of_scans)
% disp(unique_list_hdf_final)
% disp(filename)
current_dir = pwd;
% disp(number_of_scans)
cd(isos_dir)
for file_no = 1:number_of_scans%15
    tic
    k = file_no;
                            fake_name2 = ll{1,k};
            fake_name2(end-3:end+5) = '_isos.csv';
%            fake_name2 = filename; 
%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)+5) = '_isos.csv';
%         else
%             if k == 10 && fake_name2(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)+5) = '_isos.csv'; 
%             O_was_present = 1;
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)+5) = '_isos.csv';                 
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+6) = '_isos.csv';   
%             end
%         end     
% if file_no < 10    
% number_of_point_count_per_scan = csvread(fake_name2,1,0);
% else
% disp(fake_name2)
number_of_point_count_per_scan = csvread(fake_name2,1,0);    
% end

list_mz = (number_of_point_count_per_scan(:,4));
% disp(size(list_mz))
list_mz2 = [];
parfor new_list = 1:size(list_mz,1)
[c index] = min(abs(unique_list_hdf_final-list_mz(new_list)));
closestValues = unique_list_hdf_final(index); % Finds first one only!
list_mz2(new_list) = closestValues;
end
unique_mz_vals = unique(list_mz2);
uz4 = [uz2,unique_mz_vals];
uz4 = unique(uz4);
uz2 = uz4;
number_of_point_count_per_scan2 = number_of_point_count_per_scan(:,1);
max_num(count_new) = max(number_of_point_count_per_scan2(:));
count_new = count_new + 1;
save 'final_mz_list_uz4.mat' uz4
estimated_time_remaining = toc.*(number_of_scans - file_no);
fprintf('Estimated time is %f seconds \n',estimated_time_remaining)
end
