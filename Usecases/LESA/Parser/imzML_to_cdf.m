function imzML_to_cdf(number_of_files_to_group, single_imzml_file_for_entire_dataset, multiple_imzml_file_per_line)
%Author: Mathew Thomas
%Date: June 23 2016
%This function loads an imzMLfile from Bruker Instrument (loadimzMLfile() function) and then converts the data 
%to match MSI QuickView cdf file format. The imzML file has one single file
%in which the entire data is loaded. This needs to converted to separate
%cdf files per line to work with current setup of MSI QuickView.
addpath(pwd);
fprintf('Converting imzML file to cdf files using function imzML_to_cdf.\n')
numberOfImzmlFilesforEachLine = 6;
numberOfRows = 5;
if single_imzml_file_for_entire_dataset
    loadSingleImzmlFile(number_of_files_to_group);
end
fprintf('Done converting imzML file to cdf files using function imzML_to_cdf.\n')

%Hard-coded values for testing purpose
% dirName = 'C:\Users\thom991\Documents\Work\Projects\Mass Spec\Test Data';
% mkdir([dirName filesep 'CDF_Files']);

function loadSingleImzmlFile(number_of_files_to_group)
%Load an imzML file and grab data (entire data is within a single file.
%Returns "MSi"
MSi = loadimzMLfile([], number_of_files_to_group);

%Create empty CDF folder inside current imzml directory
mkdir([MSi.Pathname filesep 'CDF_Files']);

%Setting count to 1 to start with line 1 and jump to the correct starting
%point
count = 1;

%Looping through number of lines in the data/image
for j = 1:MSi.NRow

%Resetting intensity and mass values for each line    
intensity_values = [];
mass_values = [];
point_count = [];
total_intensity = [];

i1 = 1; %setting incrementer for point_count and total_intensity since they have to start at 1.

% For each line, create arrays for total_intensity vs.
% scan_acquisition_time (which is set to default increments here since it not present in the data)
% and mass_values vs. intensity_values.
for i = count:(count+MSi.NCol-1)
    total_intensity(i1) = MSi.MSo.scan(i).totalioncurrent;
    point_count(i1, 1) = numel(MSi.MSo.scan(1).peaks.mz(:,2));
    mass_values = [mass_values; MSi.MSo.scan(i).peaks.mz(:,1)];
    intensity_values = [intensity_values; MSi.MSo.scan(i).peaks.mz(:,2)];
    i1 = i1+1;
end


count= i+1; %Increment count to match starting point for next line
scan_acquisition_time = 1:MSi.NCol; %Set to default increments
mass_range_min = MSi.mzScanRange(1,1); %Minimum m/z value
mass_range_max = MSi.mzScanRange(1,2); %Maximum m/z value
mass_range_min = repmat(mass_range_min, numel(point_count));
mass_range_max = repmat(mass_range_max, numel(point_count));

%% Save the variables to a cdf file, named Line*.cdf
curDirName = [MSi.Pathname filesep 'CDF_Files' filesep 'Line' num2str(j) '.cdf']; %File name

%Creating required variables with properties into the netcdf file
% total_intensity
nccreate(curDirName,'total_intensity',...
    'Dimensions',{'r4' size(total_intensity,1) 'c4' size(total_intensity,2)});
% scan_acquisition_time
nccreate(curDirName,'scan_acquisition_time',...
    'Dimensions',{'r5' size(scan_acquisition_time,1) 'c5' size(scan_acquisition_time,2)});
nccreate(curDirName,'intensity_values',...
    'Dimensions',{'r1' size(intensity_values,1) 'c1' size(intensity_values,2)});
% mass values
nccreate(curDirName,'mass_values',...
    'Dimensions',{'r2' size(mass_values,1) 'c2' size(mass_values,2)});
% point_count
nccreate(curDirName,'point_count',...
    'Dimensions',{'r3' size(point_count,1) 'c3' size(point_count,2)});
nccreate(curDirName,'mass_range_max',...
    'Dimensions',{'r6' size(mass_range_max,1) 'c6' size(mass_range_max,2)});
nccreate(curDirName,'mass_range_min',...
    'Dimensions',{'r7' size(mass_range_min,1) 'c7' size(mass_range_min,2)});

%Writing data to the cdf file
ncwrite(curDirName,'scan_acquisition_time', scan_acquisition_time);
ncwrite(curDirName,'total_intensity', total_intensity);
ncwrite(curDirName,'intensity_values',intensity_values)
ncwrite(curDirName,'mass_values',mass_values)
ncwrite(curDirName,'point_count',point_count)
ncwrite(curDirName,'mass_range_max',mass_range_max)
ncwrite(curDirName,'mass_range_min',mass_range_min)
fprintf('Done with Line%d.\n', j);

%% Hack for now to fool MSI QuickView by saving empty raw files to mimic
%Nano-DESI datasets
dlmwrite([MSi.Pathname filesep 'Line' num2str(j) '.RAW'], []);
end