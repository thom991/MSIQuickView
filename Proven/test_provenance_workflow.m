function handles = test_provenance_workflow(~, handles, true)
%% Example Call:
% handles = guidata(hObject);test_provenance_workflow(handles);
handles.prov_filename = 'messages.txt';
handles.prov_pathname = 'C:\MSIQuickView_code_GIT\Proven\';
handles.pathname = 'C:\Users\thom991\Desktop\MSI_testData\testset1';
api = provenance_information;
api.seeProvenDebugInfo(handles);
handles = select_multiple_datasets(handles.pathname, handles, true);
cd(handles.pathname);
handles = load_excel_file_containing_dataset_list(1, handles);
