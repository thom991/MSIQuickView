function [answer, prompt]  = setup_metadata()
prompt = {'ApplicationName','uniqueID', 'Date', 'Scientist_Name', 'Dataset_Name', 'Folder_Location', 'Notes'};
dlg_title = 'Provenance Information';
num_lines = [1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 10 50];
defaultans = {'MSI QuickView','null','null','null','null','null',''};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);