function [unique_list_hdf_final] = get_unique_list_mz_from_hdfs(number_of_scans, filename)
%generates unique list of mz values from all the hdf files
%unique list not saved
global O_was_present pathname ll
unique_list_from_hdf = [];
% tic
fprintf('Begin Step 1 of 5.... \n')
% if (~isdeployed);addpath('C:\vis_xcalibur_raw_files');end
prev_dir = pwd;
cd(strcat(pathname,'HDF_Files'))
for i = 1:number_of_scans%1:15
    t_step1 = tic;
k = i;
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
% else
% hdf_filename = strcat('nic',num2str(i),'.hdf');
% end
mass = hdf5read(hdf_filename,'mass_values');
temp = [mass; unique_list_from_hdf];
unique_list_hdf_final = unique(temp);
unique_list_from_hdf = unique_list_hdf_final;
estimated_time_remaining = toc(t_step1).*(number_of_scans - i);
fprintf('Estimated Time is %f seconds \n',estimated_time_remaining)
% disp(size(unique_list_hdf_final))
end
cd(prev_dir)

