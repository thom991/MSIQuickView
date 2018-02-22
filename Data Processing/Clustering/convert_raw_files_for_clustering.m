function list_point_count = convert_raw_files_for_clustering(input_folder,varargin)
% h = waitbar(0.25,'Please wait...');  
global pathname total_intensity_final
global cdf_filename ll names
% global list_point_count names
val = [];
disp('Please Wait.....')
tic
% if matlabpool('size') == 0
%     matlabpool open
% end
names = dir(strcat(input_folder,filesep,'*.RAW'));
filename = names(1,1).name;
% disp(filename)
nVarargs = length(varargin);%disp(nVarargs);
c = varargin; %disp(c)
if nVarargs == 2;
    output_folder = varargin(1);
    i = varargin(2);
    i = str2double(i{1,1}); output_folder = strcat(pathname,'CDF_Files');%output_folder{1,1};
end
if nVarargs == 1;
    if ischar(varargin{1,1})
        output_folder = varargin;
        output_folder = strcat(pathname,'CDF_Files'); output_folder{1,1};
        i = [];
    elseif isnumeric(varargin{1,1})
        i = varargin;
        i = str2double(i{1,1});
        output_folder = strcat(pathname,'CDF_Files');%[];
    end
end
if nVarargs == 0;
i = [];
output_folder = strcat(pathname,'CDF_Files');%[];
end
% i = varargin; i = i{1,1};disp(i)

if isempty(i)
    i = size(names,1);
end
% disp(output_folder)
if isempty(output_folder)
    output_folder = strcat(pathname,'CDF_Files');%input_folder;
end
% disp('toc')
% tempo = filename(1:size(filename,2)-5);
for k = 1:i
    tic
% fake_name2 = tempo; 
% if k < 10
%     fake_name2((size(filename,2))-4) = num2str(k);
%     fake_name2((size(filename,2))-3:(size(filename,2))) = '.RAW';
% %     if k == 9
% %         fake_name_next = fake_name2;
% %         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
% %         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';   
% %     else
% %         fake_name_next = fake_name2;
% %         fake_name_next((size(filename,2))-4) = num2str(k+1);
% %     end
% elseif k >= 10 && k < 100
%     fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%     fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';
% %         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
% %         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
% elseif k >= 100 %&& k < 100
%     fake_name2(size(filename,2)-6:size(filename,2)-4) = num2str(k);
%     fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';
% %         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
% %         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
% end
            fake_name2 = names(k,1).name;%ll{1,k};
%             fake_name2(end-3:end) = '.hdf'; 
input_folder3 = strcat(input_folder,filesep);
RAW_filename_new2 = strcat(input_folder3,fake_name2); %disp(RAW_filename_new2); %disp(i)
% cdf_begin = strcat('C:\delete\',fake_name2);
% cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
% hdf_filename = [cdf_begin(1:end-4) '.hdf' ]; 
cdf_filename2 = [fake_name2(1:end-4) '.cdf' ]; 
% hdf_filename2 = [fake_name2(1:end-4) '.hdf' ]; 
if ispc
    output_folder2 = strrep(output_folder, '\', '\\'); 
    name_list = ['C:\\Xcalibur\\system\\programs\\XConvert /SL /DA "%s" /O', ' ', output_folder2]; %disp(name_list)
    cmd = sprintf (name_list, RAW_filename_new2);    %filename format for conversion into cdf
%     disp(cmd)
    system (cmd);
else
    disp('File conversion only works on Windows Platform !')
end
%         intensity_values = single(ncread(cdf_filename,'intensity_values'));
%         mass_values = single(ncread(cdf_filename,'mass_values'));
%         scan_acquisition_time = single(ncread(cdf_filename,'scan_acquisition_time'));  %CAN BE REM
%         scan_acquisition_time = single(scan_acquisition_time/60);   %CAN BE REM
%         total_intensity = ncread(cdf_filename,'total_intensity');
%         point_count = single(ncread(cdf_filename,'point_count'));
%         %%SAVE HDF
% %         tic
%         hdf5write(hdf_filename,'intensity_values',intensity_values,'mass_values',mass_values,'point_count',point_count,'total_intensity',total_intensity,'scan_acquisition_time',scan_acquisition_time);    
fprintf('Converted %s to %s File in %f seconds \n', fake_name2, cdf_filename2, toc)    
% disp(toc)
end
% current_folder = pwd;
% cd(output_folder)
% matlabpool close
% tempo = filename(1:size(filename,2)-5);
for k = 1:i
    tic
% fake_name2 = tempo; 
% if k < 10
%     fake_name2((size(filename,2))-4) = num2str(k);
%     fake_name2((size(filename,2))-3:(size(filename,2))) = '.RAW';
% %     if k == 9
% %         fake_name_next = fake_name2;
% %         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
% %         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';   
% %     else
% %         fake_name_next = fake_name2;
% %         fake_name_next((size(filename,2))-4) = num2str(k+1);
% %     end
% elseif k >= 10 && k<100
%     fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%     fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';
% elseif k >= 100% && k<100
%     fake_name2(size(filename,2)-6:size(filename,2)-4) = num2str(k);
%     fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';    
% %         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
% %         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
% end
fake_name2 = names(k,1).name;%ll{1,k};
% fake_name_next = ll{1,k+1};
input_folder3 = strcat(output_folder,filesep);
% disp(input_folder3)
% RAW_filename_new2 = strcat(input_folder3,fake_name2); %disp(RAW_filename_new2); %disp(i)
cdf_begin = strcat(input_folder3,fake_name2);
cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
% hdf_filename = [cdf_begin(1:end-4) '.hdf' ]; 
cdf_filename2 = [fake_name2(1:end-4) '.cdf' ]; 
% hdf_filename2 = [fake_name2(1:end-4) '.hdf' ]; 
% disp(hdf_filename)
%     output_folder2 = strrep(output_folder, '\', '\\'); 
%     name_list = ['C:\\Xcalibur\\system\\programs\\XConvert /SL /DA "%s" /O', ' ', output_folder2]; %disp(name_list)
%     cmd = sprintf (name_list, RAW_filename_new2);    %filename format for conversion into cdf
% %     disp(cmd)
%     system (cmd);
%         intensity_values = single(ncread(cdf_filename,'intensity_values'));
%         mass_values = single(ncread(cdf_filename,'mass_values'));
%         scan_acquisition_time = single(ncread(cdf_filename,'scan_acquisition_time'));  %CAN BE REM
%         scan_acquisition_time = single(scan_acquisition_time/60);   %CAN BE REM
%         total_intensity = ncread(cdf_filename,'total_intensity');
        point_count = (ncread(cdf_filename,'point_count'));
        total_intensity = ncread(cdf_filename,'total_intensity');
        val = vertcat(val, total_intensity);
%         disp(size(point_count))
        list_point_count(k) = size(point_count,1);
        %%SAVE HDF
%         tic
save(strcat(input_folder,filesep,'points_count_list.mat'),'list_point_count')
%         hdf5write(hdf_filename,'intensity_values',intensity_values,'mass_values',mass_values,'point_count',point_count,'total_intensity',total_intensity,'scan_acquisition_time',scan_acquisition_time);        
fprintf('Obtained Points List in %f seconds\n', toc)    
% disp(toc)
end
total_intensity_final = val';
save(strcat(input_folder,filesep,'total_intensity.mat'),'total_intensity_final')
% cd(current_folder)
% matlabpool close
disp('DONE !!!')
% close(h)
% RAW_File_Convert('C:\Users\thom991\Documents\Work\Projects\Mass Spect\Brain Sample 2','C:\Users\thom991\Documents\Work\Projects\Mass Spect\Brain Sample 2',3)
% cd C:\Users\thom991\Desktop\raw_file_convert\raw_file_convert\distrib
%raw_file_convert.exe "C:\Users\thom991\Desktop\brain" "C:\Users\thom991\Desktop\del3" "4"
%OR
%raw_file_convert.exe "C:\Users\thom991\Desktop\brain"