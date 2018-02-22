%% Load Josh's matrix and break it down into chunks and save it as hdf files separately for each Line......
% Here I am creating a new folder HDF_Files2 and save the files in
% HDF_Files, only difference being the files are now alligned along mz
function break_spectrometry_toolkit_matrix_into_hdfs
global first_filename pathname number_of_scans filename ll
[filename_txt, pathname_txt, filterindex_txt] = uigetfile({  '*.txt','txt-files (*.txt)'});
r = dlmread([pathname_txt filename_txt]);
fake_name2 = first_filename;
if exist([pathname 'points_count_list.mat'],'file')
    load([pathname 'points_count_list.mat'])
else
    for i = 1:number_of_scans
    k = i;
%         tic
            fake_name2 = ll{1,k};
            fake_name2(end-3:end) = '.hdf'; 
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
        RAW_filename_new2 = strcat(pathname,'HDF_Files',filesep,fake_name2);
                    point_count = (hdf5read(RAW_filename_new2,'point_count'));
                    list_point_count(i) = size(point_count,1);
    end
    save([pathname 'points_count_list.mat'],'list_point_count')
end
mkdir([pathname 'Matrix_Chunks'])
% mkdir([pathname 'HDF_Files'])
   mz = r(:,1);
   save([pathname 'Matrix_Chunks' filesep 'mz.mat'],'mz') 
   r(:,1) = [];
fake_name2 = first_filename;   
for i = 1:number_of_scans
   k = i;
%         tic
            fake_name2 = ll{1,k};
            fake_name2(end-3:end) = '.hdf'; 
%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.hdf';
%         else
%             if k == 10 && fake_name2(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.hdf'; 
%             O_was_present = 1;
%             elseif k>10 %&& ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.hdf';                 
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.hdf';   
%             end
%         end                   
        disp(fake_name2)
        RAW_filename_new2 = strcat(pathname,'HDF_Files',filesep,fake_name2); 
%         disp(RAW_filename_new2_check)
fprintf('Converting %s \n', fake_name2)
cdf_begin = strcat(pathname,'CDF_Files',filesep,fake_name2);
hdf_begin = strcat(pathname,'HDF_Files',filesep,fake_name2);
cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
hdf_filename = [hdf_begin(1:end-4) '.hdf' ]; 
%                     intensity_values = single(hdf5read(RAW_filename_new2,'intensity_values'));
%                     mass_values = single(hdf5read(RAW_filename_new2,'mass_values'));
                    scan_acquisition_time = hdf5read(RAW_filename_new2,'scan_acquisition_time');
                    scan_acquisition_time = scan_acquisition_time/60;
%                     point_count = single(hdf5read(RAW_filename_new2,'point_count'));  
                    total_intensity = (hdf5read(RAW_filename_new2,'total_intensity'));
%                             min_time_final = min(scan_acquisition_time(:)); 
%         max_time_final = max(scan_acquisition_time(:));
%         min_time = min(scan_acquisition_time(:)); max_time = max(scan_acquisition_time(:));  
%         min_time_final = max([min_time_final min_time]); max_time_final = min([max_time_final max_time]);

   p = list_point_count(i);
   mz1 = repmat(mz,p,1);
   mat_new = r(:,1:p);
   B_point_count = repmat(size(mat_new,1),p,1);
   mat_new = reshape(mat_new,[size(mat_new,1)*size(mat_new,2),1]);
%    disp(size(mat_new));
   val.mat_new = mat_new;
   val.point_count = B_point_count;
%    hdf5write([pathname 'HDF_Files2' filesep fake_name2],'intensity_values',val.mat_new,'mass_values',mz1,'point_count',val.point_count,'total_intensity',total_intensity,'scan_acquisition_time',scan_acquisition_time);
   r(:,1:p) = [];
end