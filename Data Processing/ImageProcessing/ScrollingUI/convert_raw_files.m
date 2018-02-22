function convert_raw_files(input_folder,varargin)
% eg.
% convert_raw_files('C:\Users\thom991\Desktop\Weird alignment','C:\Users\thom991\Desktop\trial')
% h = waitbar(0.25,'Please wait...');  
disp('Please Wait.....')
names = dir(strcat(input_folder,filesep,'*.RAW'));
filename = names(1,1).name;
nVarargs = length(varargin);%disp(nVarargs);
c = varargin; %disp(c)
if nVarargs == 2;
    output_folder = varargin(1);
    i = varargin(2);
    i = str2double(i{1,1}); output_folder = output_folder{1,1};
end
if nVarargs == 1;
    if ischar(varargin{1,1})
        output_folder = varargin;
        output_folder = output_folder{1,1};
        i = [];
    elseif isnumeric(varargin{1,1})
        i = varargin;
        i = str2double(i{1,1});
        output_folder = [];
    end
end
if nVarargs == 0;
i = [];
output_folder = [];
end
% i = varargin; i = i{1,1};disp(i)

if isempty(i)
    i = size(names,1);
end
% disp(output_folder)
if isempty(output_folder)
    output_folder = input_folder;
end
parfor k = 1:i
fake_name2 = names(k,1).name;%filename(1:size(filename,2)-5); 
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
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
% end
input_folder3 = strcat(input_folder,filesep);
RAW_filename_new2 = strcat(input_folder3,fake_name2); %disp(RAW_filename_new2); %disp(i)
% cdf_begin = strcat('C:\delete\',fake_name2);
% cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
if ispc
    output_folder2 = strrep(output_folder, '\', '\\'); 
    name_list = ['C:\\Xcalibur\\system\\programs\\XConvert /SL /DA "%s" /O', ' ', output_folder2]; %disp(name_list)
    cmd = sprintf (name_list, RAW_filename_new2);    %filename format for conversion into cdf
    system (cmd);
else
   disp('File conversion only works on Windows Platform !') 
end
fprintf('Converted File %s\n', RAW_filename_new2)    
end
disp('DONE !!!')
% close(h)
% RAW_File_Convert('C:\Users\thom991\Documents\Work\Projects\Mass Spect\Brain Sample 2','C:\Users\thom991\Documents\Work\Projects\Mass Spect\Brain Sample 2',3)
% cd C:\Users\thom991\Desktop\raw_file_convert\raw_file_convert\distrib
%raw_file_convert.exe "C:\Users\thom991\Desktop\brain" "C:\Users\thom991\Desktop\del3" "4"
%OR
%raw_file_convert.exe "C:\Users\thom991\Desktop\brain"