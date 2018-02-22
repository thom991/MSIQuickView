function handles = load_excel_file_containing_dataset_list(useDefault, handles)
    api = config_file;
    saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
    if ~useDefault
        [excel_filename, excel_pathname] = ...
            uigetfile({[pathname filesep saveTempFilesToFolder filesep 'workflow_files.xlsx']},'Select/Modify Excel File');
    else
        excel_pathname = [pwd filesep];
        excel_filename = 'workflow_files.xlsx';
    end
    [num,txt] = xlsread([excel_pathname excel_filename]);
    handles.datasets_list = txt(2:end,1);
    handles.filenames_list = txt(2:end,2);
    handles.num_lines_list = num(:,1);
    handles.start_list = num(:,2);
%     handles.metadata.
end