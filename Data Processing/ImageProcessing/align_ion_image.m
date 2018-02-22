function handles = align_ion_image(handles)
%Align an ion image
try
    api = config_file;
    saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
    diary([saveMSIQuickViewLogs 'logs.txt'])
    handles.filename2 = handles.filename;
    handles.sum_of_intensities2 = interpolation_code(handles);
    handles.sum_of_intensities = handles.sum_of_intensities2;
    diary off
catch MExc
    disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    diary off
end