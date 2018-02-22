%% This function opens up the hdf files and gets the spectrums for the ROIs selected by the user and displays the mean spectrum
function display_mean_spectrum_ROI(IT_times)
global filename pathname O_was_present unique_y_vals unique_x_vals2 new_x new_y answer ll %colormap_3d
global int_fake_matrix mass_fake_matrix roi_i final_int_vals int_fake_matrix2
load([pathname 'ROI_pts.mat'])
list_of_lines = ROI_pts.unique_y_vals; %LINE #s
list_of_scans = ROI_pts.unique_x_vals;%[120,121,122,123];
delete(pathname,'matr*.mat')

%% User Input : Excel spreadsheet name etc.
prompt = {'Enter Excel File Name:','Enter sheet name (if any):'};
dlg_title = 'Input';
num_lines = 1;
def = {'Set 1','Sheet1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

%% Get IT Times generated using the Extract_Xcal_Header_Info.exe tool. The files are in the HDF_Files2 folder in the dataset folder. Writes the following to the "Matrix_ROI" sheet for the selected ROI ONLY: Line No, Scan No, IT, RT, TIC, ST, IT Mult
range10 = 2;
fake_name2 = filename;
if exist([pathname 'Header_Files'],'dir')
    for i = 1:size(ROI_pts.unique_y_vals,2)
        [m,n] = find(ROI_pts.full_y == ROI_pts.unique_y_vals(i));
        g = ROI_pts.full_x(n); %get all m/z values for one line number
        k = ROI_pts.unique_y_vals(i);%-1;
        %         disp(k)
        fake_name2 = ll{1,k};
        fake_name2(end-3:end) = '.xls';
        disp(fake_name2)
        ii = dlmread([pathname 'Header_Files' filesep fake_name2],'\t',1, 1);
        vals = ii(g,:)';
        matObj = matfile([pathname 'matr.mat'],'Writable',true);
        matObj.X(3:6,range10:(range10+size(vals,2)-1)) = vals;
        matObj.X(7,range10:(range10+size(vals,2)-1)) = round(vals(1,:)./IT_times)*IT_times;
        range10 = range10+size(vals,2);
    end
end
if exist([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],'file')
    delete([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'])
end

%%

fake_name2 = filename;
roi = struct('int_val', {});
roi = struct('mass_val', {});
list_of_scans_b = list_of_scans;
range10 = 2;
for i = 1:numel(list_of_lines)
    
    if size(list_of_scans_b,2) == 2
        list_of_scans = ROI_pts.unique_x_vals(i,1):ROI_pts.unique_x_vals(i,2);
    end
    k = list_of_lines(i);
    fake_name2 = ll{1,k};
    fake_name2(end-3:end) = '.hdf';
    RAW_filename_new2 = strcat(pathname,'HDF_Files',filesep,fake_name2);
    intensity_values = (hdf5read(RAW_filename_new2,'intensity_values'));
    mass_values = (hdf5read(RAW_filename_new2,'mass_values'));
    %                     scan_acquisition_time = hdf5read(RAW_filename_new2,'scan_acquisition_time');
    %                     scan_acquisition_time = scan_acquisition_time/60;
    point_count = (hdf5read(RAW_filename_new2,'point_count'));
    max_size_of_point_count = max(point_count(list_of_scans(1):list_of_scans(end)));
    
    int_fake_matrix = zeros(max_size_of_point_count, numel(list_of_scans),'single');
    mass_fake_matrix = zeros(max_size_of_point_count, numel(list_of_scans),'single');
    for j = 1:numel(list_of_scans)
        range_of_point_count = sum(point_count(1:list_of_scans(j)));
        range_of_point_count2 = sum(point_count(1:(list_of_scans(j)+1)));
        int_val = intensity_values(range_of_point_count+1:range_of_point_count2);
        int_fake_matrix(1:numel(int_val),j) = int_val;
        mass_val = mass_values(range_of_point_count+1:range_of_point_count2);
        mass_fake_matrix(1:numel(mass_val),j) = mass_val;
    end
    %                     total_intensity = single(hdf5read(RAW_filename_new2,'total_intensity'));
    %                             min_time_final = min(scan_acquisition_time(:));
    %         max_time_final = max(scan_acquisition_time(:));
    %         min_time = min(scan_acquisition_time(:)); max_time = max(scan_acquisition_time(:));
    %         min_time_final = max([min_time_final min_time]); max_time_final = min([max_time_final max_time]);
    %         number_time_vals = size(scan_acquisition_time,1);
    %     end
    new_mz_list = unique(mass_fake_matrix);
    new_mz_list(new_mz_list == 0) = [];
    int_fake_matrix2 = zeros(size(new_mz_list,1), numel(list_of_scans),'single');
    %     [C,ia,ib] = intersect(mass_fake_matrix(:,1),unique_mz_list,'rows');
    for i2 = 1:numel(list_of_scans)
        ismem = ismember(new_mz_list,mass_fake_matrix(:,i2));
        x = find(ismem == 1);
        int_fake_matrix3(ismem==1,1) = int_fake_matrix(1:size(x,1),i2);
        int_fake_matrix2(:,i2) = int_fake_matrix3;
        mean_val = mean(int_fake_matrix2,2);
        roi_i(i).int_val = mean_val;
        roi_m(i).mass_val = new_mz_list;
        clear int_fake_matrix3 x mean_val
    end
    %     range1 = overnight_run;
    %     range2 = overnight_run+5000-1;
    matObj = matfile([pathname 'matr.mat'],'Writable',true);
    matObj.X(8:size(int_fake_matrix,1)+7,range10:(range10+size(int_fake_matrix,2)-1)) = int_fake_matrix;
    range10 = range10+size(int_fake_matrix,2);
    % save([pathname 'matr' num2str(i) '.mat'], 'int_fake_matrix')
    matObj = matfile([pathname 'matr.mat'],'Writable',true);
    matObj.X(8:(size(mass_fake_matrix,1)+7),1) = mass_fake_matrix(:,1);    
    clear new_mz_list mass_fake_matrix int_fake_matrix
end
[m,n] = sort(ROI_pts.full_y);
scan_no = ROI_pts.full_x(n);
% for iii = 1:size(scan_no,2)
%    sn(iii) = str2num([num2str(m(iii)) '.' num2str(scan_no(iii))]);
% end
matObj = matfile([pathname 'matr.mat'],'Writable',true);
matObj.X(1,2:(size(scan_no,2)+1)) = m;
matObj.X(2,2:(size(scan_no,2)+1)) = scan_no;
unique_m_fin = [];
for i = 1:size(roi_m,2)
    % C=cellfun(@char,{roi.mass_val},'unif',1);
    % [~,idx]=unique(C);
    m_fin = roi_m(1,i).mass_val;
    unique_m_fin = unique([unique_m_fin;m_fin]);
end
for i = 1:size(roi_m,2)
    roi_i(i).ismem = ismember(unique_m_fin,roi_m(1,i).mass_val);
end
clear roi_m m_fin
final_int_vals = zeros(size(unique_m_fin,1),size(roi_i,2),'single');
for i = 1:size(roi_i,2)
    ismem = roi_i(1,i).ismem;
    x = find(ismem == 1);
    int_fake_matrix3(ismem==1,1) = roi_i(1,i).int_val(1:size(x,1));
    final_int_vals(:,i) = int_fake_matrix3;
    clear int_fake_matrix3 x
end
mean_final_int_vals = mean(final_int_vals,2);
clear roi_i final_int_vals
subplot(2,1,2);
plot(unique_m_fin,mean_final_int_vals)
h = gcf;
% A = [unique_m_fin,mean_final_int_vals];


matObj = matfile([pathname 'matr.mat']);
[nrows, ncols] = size(matObj, 'X');
loadedData = matObj.X(1:nrows, 1:ncols);
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],loadedData,'Matrix_ROI')
names = {'Line No';'Scan No';'IT';'RT';'TIC';'ST';'IT Mult'};
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],names,'Matrix_ROI', 'A1:A7')
clear loadedData

temp_list = {'m/z value';'Mean Intensity';'x pixel values';'y pixel values';'Unique x values';'Unique y values'}';
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'], temp_list,answer{2,1}, 'A1:F1')
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],unique_m_fin,answer{2,1}, ['A2:A' num2str(numel(unique_m_fin)+1)])
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],mean_final_int_vals,answer{2,1}, ['B2:B' num2str(numel(unique_m_fin)+1)])
%where answer{1,1} is the excel file name, unique_m_fin is the list of m/z values, mean_final_int_vals is the single mean intensity value for each m/z value
%excel file created with column 1 for m/z values in the list and column
%2 the actual mean intensity values
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],new_x',answer{2,1}, ['C2:C' num2str(size(new_x,2)+1)])
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],new_y',answer{2,1}, ['D2:D' num2str(size(new_y,2)+1)])
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],unique_x_vals2',answer{2,1}, ['E2:E' num2str(size(unique_x_vals2,2)+1)])
xlswrite([pathname 'Images' filesep answer{1,1} '_ROI.xlsx'],unique_y_vals',answer{2,1}, ['F2:F' num2str(size(unique_y_vals,2)+1)])
