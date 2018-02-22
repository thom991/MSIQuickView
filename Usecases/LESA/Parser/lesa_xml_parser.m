function lesa_xml_parser(folder, x, y, orientation)
% x = '5,6,7,8,8,8,8,8,8,7,6,5'; y = '12'; orientation = 'left';
%% Orientation Options: 'left', 'right', 'none'
fprintf('Starting parsing function to convert the xml data to MSI QuickView format.\n');
pathname = fileparts(folder);
cur_path = pwd;
%% Function to parse xml LESA files to the MSI QuickView fileformat.
% Files are here: \\pnl\projects\MSSHARE\Anderton\Sorgrum_image\xml
% Sample Call:
% lesa_xml_parser('C:\Users\thom991\Documents\Work\Projects\Mass Spec LESA\Uncommon Roster Pattern\Week 2 F163\*.xml', '[5,6,7,8,8,8,8,8,8,7,6,5]', '12', 'right');
% lesa_xml_parser('C:\Users\thom991\Documents\Work\Projects\Mass Spec LESA\Uncommon Roster Pattern\Week 1 F155\*.xml', '[2, 3, 4, 4, 4, 4, 4, 4, 3, 3, 2]', '11', 'right');
% lesa_xml_parser('C:\Users\thom991\Documents\Work\Projects\Mass Spec LESA\Uncommon Roster Pattern\Week 2 F159\*.xml', '[3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 6, 6]', '12', 'left');
file_count = 1;
file = dir(folder);
mass_values_final = [];
x = str2num(x);
max_x = max(x(:));
y = str2num(y);
cd(pathname)
for j1 = 1:y
    mass_values = [];
    intensity_values = [];
    point_count = [];
    total_intensity = [];
    start_count = 1;
    for x1 = 1:max_x
        if (strcmp(orientation, 'right') && x(j1) < max_x && (x1<(max_x-x(j1)+1))) || (strcmp(orientation, 'left') && x(j1) < max_x && (x1>x(j1)))
            point_count(x1) = 5;
            [mass_values, intensity_values] = append_start_of_spectrum(start_count, mass_values, intensity_values);
            for len_points = start_count+2
                    mass_values(len_points) = 0;
                    intensity_values(len_points) = 0;
            end
            [mass_values, intensity_values] = append_end_of_spectrum(len_points, mass_values, intensity_values);
            total_intensity(x1) = sum(intensity_values(:));
            scan_acquisition_time = 1:numel(total_intensity);
            start_count = len_points + 2 + 1;            
        else%if strcmp(orientation, 'right') || strcmp(orientation, 'regular') %&& x(j1) < max_x
            if strcmp(orientation, 'right')
                diff = max_x-(max_x-x1);
%             elseif strcmp(orientation, 'left')
%                 diff = max_x-(max_x-x1);                
            else
                diff = x1;
            end                
            fprintf('Working on pixel %s on line %s.\n', num2str(diff), num2str(j1));
            filename = file(file_count,1).name;
            file_count = file_count+1;
            [s] = xml2struct(filename);
            j = 1;
            point_count(diff) = numel(s.root.analysis.DataAnalysis.ms_spectrum.ms_peaks.pk)+4;
            [mass_values, intensity_values] = append_start_of_spectrum(start_count, mass_values, intensity_values);
            for len_points = start_count+2:numel(s.root.analysis.DataAnalysis.ms_spectrum.ms_peaks.pk)+start_count-1+2
                if numel(s.root.analysis.DataAnalysis.ms_spectrum.ms_peaks.pk) > 1
                    mass_values(len_points) = str2num(s.root.analysis.DataAnalysis.ms_spectrum.ms_peaks.pk{1,j}.Attributes.mz);
                    intensity_values(len_points) = str2num(s.root.analysis.DataAnalysis.ms_spectrum.ms_peaks.pk{1,j}.Attributes.i);
                else
                    mass_values(len_points) = str2num(s.root.analysis.DataAnalysis.ms_spectrum.ms_peaks.pk.Attributes.mz);
                    intensity_values(len_points) = str2num(s.root.analysis.DataAnalysis.ms_spectrum.ms_peaks.pk.Attributes.i);
                end
                j = j+1;
            end
            [mass_values, intensity_values] = append_end_of_spectrum(len_points, mass_values, intensity_values);
            total_intensity(diff) = sum(intensity_values(:));
            scan_acquisition_time = 1:numel(total_intensity);
            start_count = len_points + 2 + 1;        
        end
    end
    mass_range_max = repmat(1500, x1,1); %max(mass_values(:))-100;
    mass_range_min = repmat(0, x1,1); %min(mass_values(:))+100;
    if ~exist([pathname filesep 'HDF_Files'],'dir')
        mkdir([pathname filesep 'HDF_Files'])        
    end
    hdf_filename = ['lesa_file' num2str(j1) '.hdf']; 
    raw_filename = ['lesa_file' num2str(j1) '.raw'];
    fileID = fopen(raw_filename,'w');
    fwrite(fileID,'');
    fclose(fileID);
    intensity_values = upsample(intensity_values, 3);
    intensity_values = [0, intensity_values(1:end-1)];
    mass_values_final = [mass_values_final, mass_values];
    mass_values = repmat(mass_values,3,1);
    mass_values = mass_values(:)'; 
    point_count = point_count*3;
    hdf5write(['HDF_Files' filesep hdf_filename],'intensity_values',intensity_values,'mass_values',mass_values,'point_count',point_count,'total_intensity',total_intensity,'scan_acquisition_time',scan_acquisition_time,'mass_range_max',mass_range_max,'mass_range_min',mass_range_min);
    %cdf files
    if ~exist([pathname filesep 'CDF_Files'],'dir')
        mkdir([pathname filesep 'CDF_Files'])        
    end    
    cdf_filename = ['lesa_file' num2str(j1) '.cdf'];
    nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'intensity_values',...
        'Dimensions',{'r1' size(intensity_values,1) 'c1' size(intensity_values,2)});
    % mass values
    nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_values',...
        'Dimensions',{'r2' size(mass_values,1) 'c2' size(mass_values,2)});
    % point_count
    nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'point_count',...
        'Dimensions',{'r3' size(point_count,1) 'c3' size(point_count,2)});
    % total_intensity
    nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'total_intensity',...
        'Dimensions',{'r4' size(total_intensity,1) 'c4' size(total_intensity,2)});
    % scan_acquisition_time
    nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'scan_acquisition_time',...
        'Dimensions',{'r5' size(scan_acquisition_time,1) 'c5' size(scan_acquisition_time,2)});
    nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_max',...
        'Dimensions',{'r6' size(mass_range_max,1) 'c6' size(mass_range_max,2)});
    nccreate([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_min',...
        'Dimensions',{'r7' size(mass_range_min,1) 'c7' size(mass_range_min,2)});
    ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'intensity_values',intensity_values)
    ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_values',mass_values)
    ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'point_count',point_count)
    ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'total_intensity',total_intensity)
    ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'scan_acquisition_time',scan_acquisition_time)
    ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_max',mass_range_max)
    ncwrite([pathname filesep 'CDF_Files' filesep cdf_filename],'mass_range_min',mass_range_min)
end
mass_values_final = unique(mass_values_final);
count = 1;
% threshold = 3;
threshold = inputdlg('Enter Threshold');
threshold = str2num(threshold{1,1});
loop_count = 1;
for i = 1:numel(mass_values_final)
    if loop_count == i
       min_max_list(count,1) = mass_values_final(i);
       loc = find(mass_values_final> (mass_values_final(i)+threshold),1);
       if isempty(loc)
          loc = i+1; 
       end
       min_max_list(count,2) = mass_values_final(loc-1);
       loop_count = loc;
       count = count + 1;
    end
end
fprintf('Saving mz ranges to spreadsheet mz_list.xls within the dataset folder.\n', num2str(x1), num2str(j1));
xlswrite([pathname filesep 'mz_list.xls'],min_max_list, datestr(date));
cd(cur_path);
fprintf('Done parsing xml files.\n');

    function [mass_values, intensity_values] = append_start_of_spectrum(start_count, mass_values, intensity_values)
        mass_values(start_count) = 0;
        mass_values(start_count+1) = 70;
        intensity_values(start_count) = 0;
        intensity_values(start_count+1) = 0;
    end

    function [mass_values, intensity_values] = append_end_of_spectrum(len_points, mass_values, intensity_values)
        mass_values(len_points+1) = 1000;
        mass_values(len_points+2) = 1500;
        intensity_values(len_points+1) = 0;
        intensity_values(len_points+2) = 0;
    end
end