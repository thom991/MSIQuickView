function api = cdf_files()
    api.read_cdf_file = @read_cdf_file;
    api.write_cdf_file = @write_cdf_file;
    
    function handles = read_cdf_file(handles)
        handles.intensity_values = (ncread(handles.cdf_filename,'intensity_values'));
        handles.mass_values = (ncread(handles.cdf_filename,'mass_values'));
        handles.scan_acquisition_time = (ncread(handles.cdf_filename,'scan_acquisition_time'));  %CAN BE REM
        handles.scan_acquisition_time = (handles.scan_acquisition_time/60);   %CAN BE REM
        handles.total_intensity = ncread(handles.cdf_filename,'total_intensity');
        handles.lower_limit_for_time = round((min(handles.scan_acquisition_time)*60)+20/60);
        handles.upper_limit_for_time = round((max(handles.scan_acquisition_time)*60)-20/60);
        handles.first_filename = handles.filename;
        handles.mass_range_max = ncread(handles.cdf_filename,'mass_range_max'); %mass_range_max = mass_range_max(1);
        handles.mass_range_min = ncread(handles.cdf_filename,'mass_range_min'); %mass_range_min = mass_range_min(1);
        handles.point_count = (ncread(handles.cdf_filename,'point_count'));
    end

    function write_cdf_file(pathname, cdf_filename, MSi)
        nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'intensity_values',...
            'Dimensions',{'r1' size(MSi.intensity_values,1) 'c1' size(MSi.intensity_values,2)});
        % mass values
        nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_values',...
            'Dimensions',{'r2' size(MSi.mass_values,1) 'c2' size(MSi.mass_values,2)});
        % point_count
        nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'point_count',...
            'Dimensions',{'r3' size(MSi.point_count,1) 'c3' size(MSi.point_count,2)});
        % total_intensity
        nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'total_intensity',...
            'Dimensions',{'r4' size(MSi.total_intensity,1) 'c4' size(MSi.total_intensity,2)});
        % scan_acquisition_time
        nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'scan_acquisition_time',...
            'Dimensions',{'r5' size(MSi.scan_acquisition_time,1) 'c5' size(MSi.scan_acquisition_time,2)});
        nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_max',...
            'Dimensions',{'r6' size(MSi.mass_range_max,1) 'c6' size(MSi.mass_range_max,2)});
        nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_min',...
            'Dimensions',{'r7' size(MSi.mass_range_min,1) 'c7' size(MSi.mass_range_min,2)});
        ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'intensity_values',MSi.intensity_values)
        ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_values',MSi.mass_values)
        ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'point_count',MSi.point_count)
        ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'total_intensity',MSi.total_intensity)
        ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'scan_acquisition_time',MSi.scan_acquisition_time)
        ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_max',MSi.mass_range_max)
        ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_min',MSi.mass_range_min)
    end

end