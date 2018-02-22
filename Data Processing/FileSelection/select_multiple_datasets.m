function handles = select_multiple_datasets(pathname, handles, auto)
% select_multiple_datasets : Pick multiple dataset folders and save the
% list to an excel file named workflow_files.xlsx.
% inputs: none
% outputs: 
%   1) datasets_list : names of selected folders
    if auto
        datasets_list = {'C:\Users\thom991\Desktop\MSI_testData\nic\20120612 dNic imaging Theodore Nathan', 'C:\Users\thom991\Desktop\MSI_testData\testset1'};
    else
        datasets_list = uipickfiles('Prompt','Select Dataset Folders to Execute in Batch Mode');
    end
    for i = 1:numel(datasets_list)
        MyFileInfo = dir([datasets_list{1,i} '/*.raw']);
        filename = MyFileInfo(1).name;
        num_lines = numel(MyFileInfo);
        filenames_list{i} = filename;
        num_lines_list{i} = num2str(num_lines);
        start_list{i} = 1;
        [handles.answer, handles.prompt]  = setup_metadata();
        for j = 1:numel(handles.prompt)
            temp{i,j} = handles.answer{j,1}; 
        end        
    end
    handles.answer = temp;
    handles.filenames_list = filenames_list; 
    handles.num_lines_list = num_lines_list;
    handles.start_list = start_list;
    handles.datasets_list = datasets_list;
    X=[[{'Folder Name','Raw File','Number of Scans','Start at Scan#'}, handles.prompt];datasets_list',filenames_list',num_lines_list',start_list', temp];
    if isempty(pathname)
       pathname = datasets_list{1,1}; 
    end
    create_folder(pathname, 'saveTempFilesToFolder')
    if auto
%         api = config_file;
%         saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
        folder_name = 'C:\Users\thom991\Desktop\MSI_testData\testset1\';% saveTempFilesToFolder];
    else
        folder_name = uigetdir;
    end
    xlswrite([folder_name filesep 'workflow_files.xlsx'],X)
end