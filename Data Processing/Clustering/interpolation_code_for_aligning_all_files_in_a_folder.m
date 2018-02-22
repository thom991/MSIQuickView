% global t_final
function interpolation_code_for_aligning_all_files_in_a_folder(filename,k2, number_of_scans, no_of_intensity_files)
%interpolation_code_for_aligning_all_files_in_a_folder('Brain 3-1.raw',1, 15, 10)
global O_was_present pathname ll
tic
api = config_file;
saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
cd(strcat(pathname,saveTempFilesToFolder))
%% Creating Unique list of time values
% files = dir(['C:\delete' '/*.hdf']);
% if isempty(t_final)
% k2 = k;
k = k2;
fake_name2 = filename(1:size(filename,2)-5); 
for i = 1%:number_of_scans%size(files,1)  
%
% USE 1:number_of_scans for using all lines
%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';
%             if k+1 <= number_of_scans
%             if k == 9 && fake_name2(size(filename,2)-5) ~= '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';   
% %             elseif k == 8 && fake_name2(size(filename,2)-5) ~= '0'
% %                 fake_name_next = fake_name2;
% %                 fake_name_next(size(filename,2)-4) = num2str(k+1);
% %                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw'; 
%             elseif k == 9 && fake_name2(size(filename,2)-5) == '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                 fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';   
%             else
%                 fake_name_next = fake_name2;
%                 fake_name_next((size(filename,2))-4) = num2str(k+1);
%             end    
%             else
%                 fake_name_next = fake_name2;
%             end            
%         else
%             if k == 10 && filename(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW'; 
%             O_was_present = 1;
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else        
%                     fake_name_next = fake_name2;
%                 end
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';     
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.RAW'; 
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                     fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             end
%         end            
           fake_name2 = ll{1,k};
           if k+1 <= number_of_scans
            fake_name_next = ll{1,k+1};
           end
        cdf_begin = strcat(pathname,'HDF_Files',filesep,fake_name2);
        hdf_filename = [cdf_begin(1:end-4) '.hdf' ];
%
% if k < 10
%     fake_name2((size(filename,2))-4) = num2str(k);
%     fake_name2((size(filename,2))-3:(size(filename,2))) = '.raw';
%     if k == 9
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';   
%     else
%         fake_name_next = fake_name2;
%         fake_name_next((size(filename,2))-4) = num2str(k+1);
%     end
% else 
%     fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%     fake_name2(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     if k+1 < number_of_scans
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     else
%         fake_name_next = fake_name2;
%     end
% end
% % RAW_filename_new2 = strcat(pathname,fake_name2);
% cdf_begin = strcat('C:\delete\',fake_name2);
% % cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
% hdf_filename = [cdf_begin(1:end-4) '.hdf' ]; 
t = hdf5read(hdf_filename,'scan_acquisition_time');
if i>1
    t_final = [t; t_final];
    t_final = unique(t_final);
else
    t_final = t;
end
% end
k = k+1;
end
%% Interp 1-D
for no_of_files_to_align = 1:no_of_intensity_files 
% save strcat('sum_of_intensities_aligned_',no_of_files_to_align-1,'.mat') sum_of_intensities
%  save(strcat('sum_of_intensities_aligned_',num2str(no_of_files_to_align-1),'.mat'),sum_of_intensities)
sum_of_intensities = load(strcat('sum_of_intensities', num2str(no_of_files_to_align),'.mat'));
sum_of_intensities = sum_of_intensities.sum_of_intensities2;
k = k2;
sum_of_intensities2 = zeros(size(sum_of_intensities,1),size(t_final,1),'single');
fake_name2 = filename(1:size(filename,2)-5); 
for i = 1:number_of_scans%size(files,1)
% fake_name2 = filename(1:size(filename,2)-5); 

%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';
%             if k+1 <= number_of_scans
%             if k == 9 && fake_name2(size(filename,2)-5) ~= '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';   
% %             elseif k == 8 && fake_name2(size(filename,2)-5) ~= '0'
% %                 fake_name_next = fake_name2;
% %                 fake_name_next(size(filename,2)-4) = num2str(k+1);
% %                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw'; 
%             elseif k == 9 && fake_name2(size(filename,2)-5) == '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                 fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';   
%             else
%                 fake_name_next = fake_name2;
%                 fake_name_next((size(filename,2))-4) = num2str(k+1);
%             end    
%             else
%                 fake_name_next = fake_name2;
%             end            
%         else
%             if k == 10 && filename(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW'; 
%             O_was_present = 1;
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else        
%                     fake_name_next = fake_name2;
%                 end
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';     
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.RAW'; 
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                     fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             end
%         end            
           fake_name2 = ll{1,k};
           if k+1 <= number_of_scans
            fake_name_next = ll{1,k+1};
           end
        cdf_begin = strcat(pathname,'HDF_Files',filesep,fake_name2);
        hdf_filename = [cdf_begin(1:end-4) '.hdf' ];
% if k < 10
%     fake_name2((size(filename,2))-4) = num2str(k);
%     fake_name2((size(filename,2))-3:(size(filename,2))) = '.raw';
%     if k == 9
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';   
%     else
%         fake_name_next = fake_name2;
%         fake_name_next((size(filename,2))-4) = num2str(k+1);
%     end
% else 
%     fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%     fake_name2(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     if k+1 < number_of_scans
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     else
%         fake_name_next = fake_name2;
%     end
% end
% % RAW_filename_new2 = strcat(pathname,fake_name2);
% cdf_begin = strcat('C:\delete\',fake_name2);
% % cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
% hdf_filename = [cdf_begin(1:end-4) '.hdf' ]; 
% cd('C:\delete')
t_old = hdf5read(hdf_filename,'scan_acquisition_time');
num = size(sum_of_intensities(i,:),2) - size(t_old,1);
x2 = interp1(t_old, sum_of_intensities(i,(1:end-num)), t_final);
sum_of_intensities2(i,:) = x2;
% disp(size(t_old,1))
k = k+1;
end
%% Replacing NaNs with values
for i = 1:number_of_scans
ii = find(isnan(sum_of_intensities2(i,:)) == 1);
lower_ts = find(ii < size(t_final,1)/2);
if ~isempty(lower_ts)
    for temp = 1:size(lower_ts,2)
        sum_of_intensities2(i,ii(temp)) = sum_of_intensities2(i,ii(size(lower_ts,2))+1);
    end
end
higher_ts = find(ii > size(t_final,1)/2);
if ~isempty(higher_ts)
    for temp = 1:size(higher_ts,2)
        sum_of_intensities2(i,ii(higher_ts(temp))) = sum_of_intensities2(i,ii(higher_ts(1))-1);
    end
end
end
save(strcat('sum_of_intensities_aligned_',num2str(no_of_files_to_align),'.mat'),'sum_of_intensities2')
time = toc; disp(time);
end
