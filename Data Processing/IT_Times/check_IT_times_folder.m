function check_IT_times_folder(pathname)
%% Function to check the existance of IT Times within a dataset folder and generate if not present
% Requirements:
% Extract_Xcal_Header_Info.exe has to be present in the C drive for
% windows, not set up currently for Linux
if ~exist([pathname 'Header_Files'],'dir')
    warning('Header_Files folder does not exist, attempting to create one...')
    if ispc
        system('C:\MSIQuickView_code\Extract_Xcal_Header_Info.exe');
    end
end