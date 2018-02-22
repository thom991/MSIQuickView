function create_folder(pathname, fieldName)
api = config_file;
folderName = api.read_config_values('Folder', fieldName);
if ~exist(strcat(pathname,folderName),'dir')
    mkdir(strcat(pathname,folderName));
end