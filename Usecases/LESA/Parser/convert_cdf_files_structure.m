%This file will take in cdf files and save them as new cdf files using the
%structure you define. For example, if there are 20 cdf files and if you
%want 5 rows/cdf files with 4 cdfs in each line, this function will combine 4 cdf files into 1 cdf file, one for each line,
%hence generating 5 new cdf files.
%User can define the cdf filenames.
%Inputs:
%(1) Folder containing CDF files
%(2) Filename to save the new cdf files and optional raw files
%(3) number of points/columns in each line, the number of rows will be
%automatically deduced from this information
%(4) Set to true if you want to save empty raw files to adhere to
%MSIQuickView format.
%Example Call:
%From MATLAB : MSi = convert_cdf_files_structure('C:\Users\thom991\Documents\Work\Projects\Mass Spec LESA\Day8_DHB_Trip_MS\CDF_Files', 'converted', 5, true);
%From cmd : C:\Users\thom991\Documents\Work\Projects\Mass Spec LESA\Day8_DHB_Trip_MS\CDF_Files> "C:\Users\thom991\Documents\MATLAB\convert_cdf_files_structure\for_redistribution_files_only\convert_cdf_files_structure.exe" "C:\Users\thom991\Documents\Work\Projects\Mass Spec LESA\Day8_DHB_Trip_MS\CDF_Files" "converted" "5" "true"
function MSi = convert_cdf_files_structure(folderName, filenameToSave, Columns, add_raw_files)
    MSi.Filenames = dir([folderName filesep '*.cdf']);
    Columns = str2num(Columns);
    if exist([folderName filesep 'msi_quickview_dataset' filesep 'CDF_Files'], 'dir')
        delete([folderName filesep 'msi_quickview_dataset' filesep 'CDF_Files' filesep '*.cdf'])
    end
    mkdir([folderName filesep 'msi_quickview_dataset' filesep 'CDF_Files']);
    count = 1; row_no = 1;
    Temp = set_empty_values([]);
    for numFiles = 1:numel(MSi.Filenames)
        MSi.cdf_filename = MSi.Filenames(numFiles).name;
        MSi.filename = [filenameToSave num2str(row_no) '.cdf'];
        cdf_api = cdf_files();
        MSi = cdf_api.read_cdf_file(MSi);
        Temp = set_new_values(Temp, MSi);
        if count == Columns
           %write cdf file
           cdf_api.write_cdf_file([folderName filesep 'msi_quickview_dataset'], MSi.filename, Temp);
           %save empty raw files according to MSIQuickViewStructure
           if add_raw_files
               raw_api = raw_files(); 
               raw_api.write_raw_file([folderName filesep 'msi_quickview_dataset' filesep], filenameToSave, row_no);
           end           
           %clear variables
           Temp = set_empty_values(Temp);
           count = 1;
           row_no = row_no+1;
        else
           count = count+1;
        end
    end
   
    
    function Temp = set_empty_values(Temp)
        fprintf('Fcn: set_empty_values.\n')
        Temp.intensity_values = [];
        Temp.mass_values = [];
        Temp.scan_acquisition_time = [];
        Temp.total_intensity = [];
        Temp.mass_range_max = [];
        Temp.mass_range_min = [];
        Temp.point_count = [];
    end

    function Temp = set_new_values(Temp, MSi)
        fprintf('Fcn: set_new_values.\n')
        Temp.intensity_values = [Temp.intensity_values; MSi.intensity_values];
        Temp.mass_values = [Temp.mass_values; MSi.mass_values];
        Temp.scan_acquisition_time = [Temp.scan_acquisition_time; MSi.scan_acquisition_time];
        Temp.total_intensity = [Temp.total_intensity; MSi.total_intensity];
        Temp.mass_range_max = [Temp.mass_range_max; MSi.mass_range_max];
        Temp.mass_range_min = [Temp.mass_range_min; MSi.mass_range_min];
        Temp.point_count = [Temp.point_count; MSi.point_count];
    end
end

    