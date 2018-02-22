function handles = read_hdf_file(handles)
    handles.intensity_values = (hdf5read(strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2(1:end-4),'.hdf'),'intensity_values'));
    handles.mass_values = (hdf5read(strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2(1:end-4),'.hdf'),'mass_values'));
    handles.scan_acquisition_time = (hdf5read(strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2(1:end-4),'.hdf'),'scan_acquisition_time'));  %CAN BE REM
    handles.scan_acquisition_time = (handles.scan_acquisition_time/60);   %CAN BE REM
    handles.total_intensity = hdf5read(strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2(1:end-4),'.hdf'),'total_intensity');
    handles.lower_limit_for_time = round((min(handles.scan_acquisition_time)*60)+20/60);
    handles.upper_limit_for_time = round((max(handles.scan_acquisition_time)*60)-20/60);
    handles.first_filename = handles.filename;
    handles.mass_range_max = hdf5read(strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2(1:end-4),'.hdf'),'mass_range_max'); %mass_range_max = mass_range_max(1);
    handles.mass_range_min = hdf5read(strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2(1:end-4),'.hdf'),'mass_range_min'); %mass_range_min = mass_range_min(1);
    handles.point_count = (hdf5read(strcat(handles.pathname,'HDF_Files',filesep,handles.fake_name2(1:end-4),'.hdf'),'point_count'));