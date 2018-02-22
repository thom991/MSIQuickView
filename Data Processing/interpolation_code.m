function sum_of_intensities2 = interpolation_code(handles)
tic
cd(strcat(handles.pathname,'HDF_Files'))
%% Creating Unique list of time values
try
k = get(handles.start_with_line_number_editbox,'string');
k = str2num(k);
k2 = k;
for i = 1:handles.number_of_scans%size(files,1)
    % USE 1:number_of_scans for using all lines
    % USE only i = 1%: for using only first lines time values.
    fake_name2 = handles.ll{1,k};
    cdf_begin = strcat(handles.pathname,'HDF_Files',filesep,fake_name2);
    hdf_filename = [cdf_begin(1:end-4) '.hdf' ];
    t = hdf5read(hdf_filename,'scan_acquisition_time');
    if i>1
        t_final = [t; t_final];
        t_final = unique(t_final);
    else
        t_final = t;
    end
    k = k+1;
end
%% Interp 1-D
k = k2;
sum_of_intensities2 = NaN([size(handles.sum_of_intensities,1),size(t_final,1)]);
for i = 1:handles.number_of_scans%size(files,1)
    fake_name2 = handles.ll{1,k};
    cdf_begin = strcat(handles.pathname,'HDF_Files',filesep,fake_name2);
    hdf_filename = [cdf_begin(1:end-4) '.hdf' ];
    t_old = hdf5read(hdf_filename,'scan_acquisition_time');
    num = size(handles.sum_of_intensities(i,:),2) - size(t_old,1);
    x2 = interp1(t_old, handles.sum_of_intensities(i,(1:end-num)), t_final);
    sum_of_intensities2(i,:) = x2;
    k = k+1;
end
catch
    fprintf('This is not the MSI QuickView Real-Time Tool, so skipping aligning time-points. Code will continue...\n');
end