function convertImzmlForMsiQuickViewScrollingTool(MSi, number_of_files_to_group)
% MSI QuickView Scrolling Tool has 4 requirements:
% 1) file_info.mat with a struct named "info". Info has 3 fields:
%        1a) info.raw_filename
%        1b) info.number_of_scans
%        1c) info.pathname
% 2) mz_vals.mat with an array named "C". It has an NX1 array of mz values.
% 3) point_count.mat with an array named "r2". It has an 1XN array of how
% each single row image needs to be split up to generate actual image.
% 4) myBigData2.mat with a matrix named "X", where each row represents a 1d
% image
% 5) number_of_files_to_group: is the parameter used to determine the # of m/z values and images to create mat files
% per mat file for the scrolling tool.
number_of_files_to_group = str2double(number_of_files_to_group);
fprintf('Converting loaded imzML data for MSI QuickView Scrolling Tool inside function "convertImzmlForMsiQuickViewScrollingTool".\n');

if ~exist([MSi.Pathname 'myBigData2'],'dir')
    mkdir([MSi.Pathname 'myBigData2']);
    mkdir([MSi.Pathname 'mz_list']);
end
if exist([MSi.Pathname 'myBigData2' filesep 'myBigData2_p1.mat'],'file')
    delete([MSi.Pathname 'myBigData2' filesep 'myBigData2*'])
    delete([MSi.Pathname 'mz_list' filesep 'mz_vals*'])
    delete([MSi.Pathname 'start_end_mz_list.mat'])
end
    
% 1) Generating file_info.mat
info.raw_filename = '';
info.number_of_scans = MSi.NRow;
info.pathname = pwd;
save([MSi.Pathname 'file_info.mat'], 'info');

% 2) mz_vals.mat
% Get non-empty rows to obtain m/z values
[m,n]=find([MSi.MSo.scan.totalioncurrent]); %get all non-empty rows
firstNonEmptyRow = n(1); %get first non-empty row
C2 = MSi.MSo.scan(firstNonEmptyRow).peaks.mz(:,1);
% number_of_files = 5000;
count = 1;
for i = 1:number_of_files_to_group:length(C2)
    if (i+number_of_files_to_group-1)<length(C2)
        C = C2(i:(i+number_of_files_to_group-1));
    else
        C = C2(i:end);
    end
    save([MSi.Pathname 'mz_list' filesep 'mz_vals_p' num2str(count) '.mat'], 'C');
    count = count+1;
end

% 3) point_count.mat
r2 = repmat(MSi.NCol, 1, MSi.NRow);
save([MSi.Pathname 'point_count.mat'], 'r2');

% 4) myBigData2.mat
count = 1;
for j = 1:number_of_files_to_group:length(C2)
    matObj = matfile([MSi.Pathname 'myBigData2' filesep 'myBigData2_p' num2str(count) '.mat'],'Writable',true);
    j_end = j+number_of_files_to_group-1;
    if j_end>length(C2)
       j_end = length(C2); 
    end
    fprintf('Saving m/z %d to %d of %d \n', j, j_end,length(C2)) 
    X = zeros(j_end-j+1, length(MSi.MSo.scan));
    %count2 = 1;
    %for k = j:j_end
        for i = 1:length(MSi.MSo.scan)
           cur_pixel = MSi.MSo.scan(i).peaks.mz(j:j_end,2);
           X(:,i) = cur_pixel;
        end
        %count2 = count2+1;
    %end
    matObj.X(1:size(X,1),1:size(X,2)) = X; 
    matObj.startmz = MSi.MSo.scan(i).peaks.mz(j,1);
    matObj.endmz = MSi.MSo.scan(i).peaks.mz(j_end,1);
    start_end_mz_list{count} = [num2str(MSi.MSo.scan(i).peaks.mz(j,1)) ' - ' num2str(MSi.MSo.scan(i).peaks.mz(j_end,1))];
    count = count+1;
end
save([MSi.Pathname 'start_end_mz_list.mat'], 'start_end_mz_list');

fprintf('Completed converting imzML data to MSI QuickView Scrolling Tool format using convertImzmlForMsiQuickViewScrollingTool function.\n');
