function MSi = Mzxml_to_cdf(number_of_files_to_group, multiple_imzml_file_per_line)
%Author: Mathew Thomas
%Date: March 28 2017
%This function loads an mzxMLfile and then converts the data 
%to match MSI QuickView cdf file format. The mzxML file has one single file
%for each pixel. This needs to be converted to separate
%cdf files per line to work with current setup of MSI QuickView.
% Example Call:
% MSi = Mzxml_to_cdf(6, true);
addpath(pwd);
fprintf('Converting mzXML file to cdf files using function mzXML_to_cdf.\n')
numberOfImzmlFilesforEachLine = 6;
numberOfRows = 5;
if multiple_imzml_file_per_line
    MSi = loadmultiplemzxmlFiles(number_of_files_to_group, numberOfImzmlFilesforEachLine, numberOfRows);
    MSi = readmzXMLFile(MSi, 1);
end
fprintf('Done converting mzXML file to cdf files using function mzXML_to_cdf.\n')


function MSi = loadmultiplemzxmlFiles(number_of_files_to_group, numberOfImzmlFilesforEachLine, numberOfRows)
%Load multiple imzML files and grab data (each imzml file represents a
%single pixels in a line. So if there are 6 pixels in each line and 5 rows,
%there will be 30 total imzml files.
%Returns "MSi"
% Get a single imzML file name
[MSi.Filenames,MSi.Pathname] = ...
   uigetfile({'*.mzXML' 'Imaging Data (*.mzXML)'}, ...
              'Select .mzXML file to load',pwd,'MultiSelect','On');
% Display all selected files in the console          
fprintf('Selected Files:\n');
for i = 1:numel(MSi.Filenames)          
    fprintf('%s.\n', MSi.Filenames{i});
end


function MSi = readmzXMLFile(MSi, fileNum)
mzXMLStruct = mzxmlread([MSi.Pathname MSi.Filenames{1,fileNum}]);
