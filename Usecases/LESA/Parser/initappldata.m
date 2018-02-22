function MSi = initappldata(applpath,verstr)
% INITAPPLDATA  Initialize MSiReader application data structure
%   MSi = initappldata(applpath,verstr,handles)
% Input
%   applpath   full path to the MSiReader m-file
%   verstr     software version as a character string
%   handles    MSiReader gui handles
% Output
%   MSi        MSiReader application data structure
%              maintained using getappdata,setappdata
%
% The MSi structure is initialize and the preferences INI file is read.
% Keyword names in the INI file that match structure fields are used as initial
% values.  The INI file also contains defalut arguments for the Bioinformatics
% toolbox functions.  These are saved in MSi.  Gui edit fields and popup menu
% selections are also initialized from values in MSi.

% Copyright 2012, North Carolina State University
% Written by Guillaume Robichaud and Ken Garrard

% Variable names to extract from rastir structure
rastirvars  = {'roi_num_spotsperscan' 'roi_num_scanlines'    ...
               'roi_spot_spacing'     'roi_scanline_spacing' ...
               'pattern'              'typedirseq_idx'};

% Types of values in rastirvars list, 1==numeric, 0==string 
rastirvartypes = [1 1 1 1 0 1];

% Declare application structure
MSi = struct( ...
   'Magic',                    185581,      ...  % Magic number
   'VersionString',            verstr,      ...  % MSiReader version string
   'AboutText',                '',          ...  % About box text
   'ComputerType',             [],          ...  % PC,Mac,Linux and 32,64 bit
   'MatlabVersion',            [],          ...  % Matlab release
   'BioinfoToolbox',           [],          ...  % Bioinformatics   Toolbox version
   'StatsToolbox',             [],          ...  % Statistics       Toolbox version
   'ImageToolbox',             [],          ...  % Image Processing Toolbox version
   'Applpath',                 [],          ...  % Path to MSiReader files
   'Userpath',                 [],          ...  % Current user directory
   'Pathname',                 [],          ...  % Data file path
   'Filename',                 [],          ...  % Data file name
   'BGPathname',               [],          ...  % Background noise file path
   'BGFilename',               [],          ...  % Background noise file name
   'ExportPeaksFilename',      [],          ...  % Name of exported peaks list file
   'SessionReload',            [],          ...  % Reloaded MAT session full file name
   'Loadtype',                 0,           ...  % mzXML, imzXML, IMG, Bruker, ...
   'NCol',                     10,          ...  % Number of  pixels (horizontal)
   'NRow',                     10,          ...  % Number of  pixels (vertical)
   'XSpacing',                 200,         ...  % horizontal pixel spacing (mm)
   'YSpacing',                 200,         ...  % Vertical   pixel spacing (mm)
   'RastirPattern',            'one-way',   ...  % Raster option: 'one-way' or 'meander'
   'RastirSequence',           1,           ...  % Raster selector: type,dir,seq (1..6)
   'mzCenter',                 369.35,      ...  % Interrogated m/z value
   'mzStep',                   0.01,        ...  % m/z step size (Da)
   'Binsize',                  0.1,         ...  % m/z bin  size
   'Binunits',                 1,           ...  % m/z bin  units (1==Da, 2==ppm)
   'mzMin',                    369.25,      ...  % Minimum m/z value in bin
   'mzMax',                    369.45,      ...  % Maximum m/z value in bin
   'mzMinofRange',             200,         ...  % Global m/z minimum in data set
   'mzMaxofRange',             2000,        ...  % Global m/z maximum in data set
   'LocalMinScale',            0,           ...  % Minimum intensity in selection
   'LocalMaxScale',            2000,        ...  % Maximum intensity in selection
   'NormScale',                1000000,     ...  % Normalization intensity
   'Numscan',                  0,           ...  % Number of scans in data set
   'NumscanNoise',             0,           ...  % Number of scans in noise data set
   'mzSliderIncr',             0.05,        ...  % Relative units (%)
   'NormCenter',               519.14,      ...  % Abundance normalization m/z
   'MaxColorScale',            443.3,       ...  % Color map saturation abundance
   'ColorMap',                 'jet',       ...  % Heatmap plot color scheme
   'CursorColor',              'magenta',   ...  % Cursor color
   'SpectrumROIColor',         'magenta',   ...  % ROI selection color
   'InterrogatedROIColor',     'magenta',   ...  % Interrogated region selection color
   'ReferenceROIColor',        'green',     ...  % Reference    region selection color
   'ItType',                   'linear',    ...  % Type  of interpolation
   'ItOrder',                  2,           ...  % Order of interpolation
   'ItOrder_roi',              0,           ...  % Order of interpolation for roi tools
   'CutoffNorm',               1000,        ...  % Normalization abundance cutoff
   'Pixelation',               2,           ...  % Heatmap pixelation 1=sum, 2=max
   'IntPeakCutoff',            80,          ...  % Interrogated ROI peak cutoff (%)
   'RefPeakCutoff',            20,          ...  % Reference    ROI peak cutoff (%)
   'MinPeakRatio',             2.0,         ...  % Minimum interrogated/reference ratio
   'PeakThreshold',            100,         ...  % Threshold for peak picking algorithms
   'mzResampleOption',         1,           ...  % 1==roi, 2==allmz, 3==uniform
   'BaselineThreshold',        10,          ...  % Minimum data points for baseline correction
   'Resolution',               0,           ...  % Minimum m/z scale increment
   'ResultMatrix',             [],          ...  % Storage for abundance matrix
   'ExportFiletype',           'png',       ...  % File type for image export
   'MSo',                      [],          ...  % Structure for MS file data
   'MSoNoise',                 [],          ...  % Structure for noise or BG file
   'XLSNumRows',               0,           ...  % Number of rows in 1st sheet of XLS template
   'MarkerPreallocation',      10000,       ...  % Pre-allocation size of peak marker vectors
   'MaxMarkerstoView',         500,         ...  % Maximum number of markers sent to msviewer
   'TextExportDelimiter',      '\t',        ...  % Column delimiter for an exported text file
   'TextExportFormat',         '%10.6f',    ...  % Format for spectrum export to a text file
   'TextExportNewline',        'pc',        ...  % Newline terminator, 'pc'==CR/LF
   'TextExportChunk',          4000,        ...  % Chunk size for text export with dlmwrite()
   'TextExportOptions',        [],          ...  % Options for text export with dlmwrite()
   'MaxExcelRows',             1048576,     ...  % Maximum number of rows in an Excel file
   'is64bit',                  true,        ...  % Is Matlab 64-bit
   'ExportToExcel',            true,        ...  % Export spectra,peaks to Excel (false==TXT)
   'hasExcel',                 true,        ...  % Is Excel or COM-server installed
   'AutoAbundanceUpdate',      true,        ...  % Update abundance scale in updateMSi() 
   'NoiseSubtractionEnable',   false,       ...  % Enable Noise/Background checkbox
   'NoiseSubtraction',         false,       ...  % Noise/Background subtraction
   'NoiseFileSelected',        false,       ...  % Noise/Background file selected
   'Normalize',                false,       ...  % Normalize abundance data
   'BaselineCorrectionEnable', true,        ...  % Baseline correction
   'ParabolicCentroid',        true,        ...  % Use parabolic centroid peak algorithm
   'ViewPeaks',                true,        ...  % Plot peak finder results with msviewer
   'ExportPeaks',              true,        ...  % Export peak finder results to XLSX file
   'IncludeIntensity',         false,       ...  % Include abundance with exported peaks list
   'UseXLSTemplate',           true,        ...  % Export into an Excel template file
   'ExportSpectrum',           false,       ...  % Export the full mz,Intensity spectrum
   'mzResampleOptionEnable',   false,       ...  % mzResample context menu enable/disable
   'isROI',                    false,       ...  % Is an ROI active
   'ScanCursor',               [],          ...  % Scan numbers in selected     ROI
   'ScanInterrogatedROI',      [],          ...  % Scan numbers in interrogated ROI
   'ScanReferenceROI',         [],          ...  % Scan numbers in reference    ROI
   'InstructionsText',         [],          ...  % Default instructions text
   'CursorToolText',           [],          ...  % Instructions for cursor tool
   'ROIToolText',              [],          ...  % Instructions for ROI tool
   'ROISpectrumText',          [],          ...  % Instructions for spectrum plot
   'PeakInterrogatedText',     [],          ...  % Instructions for interrogated ROI selection
   'PeakReferenceText',        [],          ...  % Instructions for reference    ROI selection
   'PeakFinderText',           [],          ...  % Instructions for peak finder tool
   'HeatmapAxes',              [],          ...  % Handle of heatmap plot axes
   'WaitbarHandle',            [],          ...  % Handle of waitbar dialog
   'CursorHandle',             [],          ...  % Handle of cursor tool
   'ROIHandle' ,               [],          ...  % Handle of ROI tool
   'InterrogatedROIHandle',    [],          ...  % Handle of interrogated ROI tool
   'ReferenceROIHandle',       [],          ...  % Handle of reference    ROI tool
   'PeaksOptions',             [],          ...  % Options for mspeaks()
   'ResampleOptions',          [],          ...  % Options for msresample_scan()
   'BackadjOptions',           [],          ...  % Options for msbackadj()
   'RastirInfoNames',          {rastirvars},     ...  % Rastir var names
   'RastirInfoTypes',          {rastirvartypes}, ...  % Rastir var types
   'DateString',               '',               ...  % Timestamp for MSiReader title
   'DateFormat',               'HH:MM:SS dddd, yyyy.mm.dd', ...  % Format of date/time string
   'HelpFilename',             'MSiReaderUserManual.pdf',   ...  % Name of help file
   'XLSTemplateFilename',      'MassExcessTemplate.xlsx',   ...  % Excel export template
   'EmptyTemplateFilename',    'EmptyTemplate.xlsx'         ...  % Excel export template
);

% Save full path to MSiReader application m-file
MSi.Applpath = applpath;

% Save current directory
MSi.Userpath = pwd;

% Default bioinfo toolbox function arguments
% These will be merged with prefs file contents and saved in the application
% data structure as cell arrays.  For mspeaks(), the 'HeightFilter' parameter
% value is supplied by the Peak Threshold field in the MSiPeakfinder GUI.

BioInfoPeaks = struct( ...
   'Denoising',       false, ...
   'Base',            4,     ...
   'Levels',          10,    ...
   'NoiseEstimator',  'mad', ...
   'Multiplier',      1,     ...
   'PeakLocation',    1      ...
);

BioInfoResample = struct( ...
   'Rangewarnoff',  true,      ...
   'Window',        'flattop', ...
   'Cutoff',        0.5        ...
);

BioInfoBackadj = struct( ...
   'WindowSize',        200,        ...
   'StepSize',          200,        ...
   'RegressionMethod',  'pchip',    ...
   'EstimationMethod',  'quantile', ...
   'SmoothMethod',      'none',     ...
   'QuantileValue',     0.1,        ...
   'PreserveHeights',   false       ...
);

% Preferences keynames with character values
inicharkeys = ...
   {'VersionString' 'RastirPattern' 'ColorMap' 'CursorColor' 'SpectrumROIColor' ...
    'InterrogatedROIColor' 'ReferenceROIColor' 'ItType' 'ExportFiletype'        ...
    'TextExportDelimiter' 'TextExportFormat' 'TextExportNewline' 'DateString'   ...
    'DateFormat' 'HelpFilename' 'XLSTemplateFilename' 'EmptyTemplateFilename'   ...
    'NoiseEstimator' 'Window' 'RegressionMethod' 'EstimationMethod'             ...
    'SmoothMethod'};

% Preferences ignore list
% These keynames will be ignored if present in the preferences INI file.
iniignorelist = ...
   {'Magic' 'VersionString' 'AboutText' 'mzSliderIncr' 'ResultMatrix' 'MSo'     ...
    'MSoNoise' 'MarkerPreallocation' 'TextExportOptions' 'NoiseSubtraction'     ...
    'NoiseFileSelected' 'Normalize' 'BaselineCorrectionEnable' 'SessionReload'  ...
    'AutoAbundanceUpdate' 'isROI' 'ScanCursor' 'ScanInterrogatedROI'            ...
    'ScanReferenceROI' 'HeatmapAxes' 'WaitbarHandle' 'CursorHandle' 'ROIHandle' ...
    'InterrogatedROIHandle' 'ReferenceROIHandle' 'RastirInfoNames'              ...
    'RastirInfoTypes' 'DateFormat' 'EmptyTemplateFilename' 'HelpFilename'};

% Process preferences file
try
   % Update MSi structure fields with matching name,value pairs
   prefs = readINI([MSi.Applpath filesep 'MSiReaderPrefs.INI'],inicharkeys);
   MSi   = structrecon(MSi,prefs.MSiPrefs,true,{},iniignorelist);
   % Merge bioinfo prefs with defaults, convert to cell arrays and save in MSi
   MSi.PeaksOptions    = struct2pv(structrecon(BioInfoPeaks,   prefs.BioInfoPeaks));
   MSi.ResampleOptions = struct2pv(structrecon(BioInfoResample,prefs.BioInfoResample));
   MSi.BackadjOptions  = struct2pv(structrecon(BioInfoBackadj, prefs.BioInfoBackadj));
catch ME %#ok<NASGU>
end

% Save system info for this computer
MSi.ComputerType   = computer();
MSi.MatlabVersion  = ver('matlab' );
MSi.BioinfoToolbox = ver('bioinfo');
MSi.StatsToolbox   = ver('stats'  );
MSi.ImageToolbox   = ver('images' );

% 64-bit Matlab?
MSi.is64bit = ~isempty(strmatches(MSi.ComputerType,{'PCWIN64' 'GLNXA64' 'MACI64'}));

% Excel support?
% Excel support is indicated by the absence of the data processing template
% file or the failure of xlsfino() or xlsread() to processs that file.  This
% is determined by checking for an warning from either of these function calls.
% If there is excel support, the number of rows in the first column of
% sheet1 of the template is also saved in the application data structure
% for use by the export function.
if MSi.ExportToExcel
   if exist(MSi.XLSTemplateFilename,'file') ~= 2, MSi.UseXLSTemplate = false;
   else
      try
         MSi.hasExcel = ~isempty(xlsfinfo(MSi.XLSTemplateFilename));
         if MSi.hasExcel
              MSi.XLSNumRows = size(xlsread(MSi.XLSTemplateFilename,1),1);
         else MSi.XLSNumRows = 0;
         end
      catch ME %#ok<NASGU>
         MSi.hasExcel = false;
      end
      % Did we get a warning about ActiveX support?
      [~,lastwarnid] = lastwarn();
      if isequal(lastwarnid,'MATLAB:xlsfinfo:ActiveX') || ...
         isequal(lastwarnid,'MATLAB:xlsread:ActiveX'), MSi.hasExcel = false; end
   end
else
   MSi.hasExcel = false;
end

% Export to the Excel template file ?
if ~MSi.hasExcel, MSi.UseXLSTemplate = false;
end

MSi.ItType  = 'linear';
MSi.ItOrder = str2double('2');


% Validate colormap
try

catch ME %#ok<NASGU>
   MSi.ColorMap = 'jet';
end

% Text export options for dlmwrite()
MSi.TextExportOptions = {
   'delimiter',MSi.TextExportDelimiter,'precision',MSi.TextExportFormat, ...
   'newline',MSi.TextExportNewline
};


% About box text
MSi.AboutText = ...
   {'';
    sprintf('MSiReader Version %s',MSi.VersionString); ''
    'North Carolina State University'
    'W.M. Keck Fourier Transform Mass Spectrometry Laboratory';
    'Authors:  Guillaume Robichaud and Ken Garrard';
    'December 21, 2012'; ''
    'Copyright (c) 2012, North Carolina State University'
    'All rights reserved.'; ''
    'This software and all accompanying documents and'
    'data sets are distributed under the provisions of the'
    'BSD 3-Clause License.'; ''
    
    'The authors would like to gratefully acknowledge the' 
    'financial support received from the National Institutes'
    'of Health (R01GM087964), the W. M. Keck Foundation'
    'and North Carolina State University.'; ''};

% Instructions panel text values
MSi.InstructionsText = ...
   {'1- Load mzXML file, imzML file,'
    '     ..., MAT session file.'
    '   '
    '2- Select m/z of interest, change'
    '     interpolation and perform post'
    '     processing if needed.'
    '   '
    '3- Change colormap and view MS'
    '     using toolbar menu functions.'};

MSi.CursorToolText = ...
   {'1- Move the cursor tool to the'
    '     desired image location.'
    '   '
    '2- Use the spectrum generator'
    '     tool to plot the peaks.'
    '   '
    '3- The cursor can be moved in the'
    '     image to generate another'
    '     peaks plot.'
    '   '
    '4- Click the cursor tool again to'
    '     exit and resume processing.'};

MSi.ROIToolText = ...
   {'1- Select an image region with'
    '     the ROI drawing tool.'
    '   ...'};

MSi.ROISpectrumText = ...
   {'2- Use the spectrum generator'
    '     tool to plot peaks in the'
    '     selected ROI.'
    '   '
    '3- The ROI can be moved in the'
    '     image to generate another'
    '     peaks plot.'
    '   '
    '4- Click the ROI tool again to'
    '     exit and resume processing.'};

MSi.PeakInterrogatedText = ...
   {'1- Select an image zone to'
    '     interrogate with the ROI'
    '     drawing tool.'
    '   ...'};

MSi.PeakReferenceText = ...
   {'2- Select a reference zone'
    '     with the ROI drawing tool.'
    '   ...'};

MSi.PeakFinderText = ...
   {'3- Use the peak extracting tool'
    '     to plot peaks unique to the'
    '     interrogated zone (magenta).'
    '   '
    '4- The zones can be moved in the'
    '     image to generate another'
    '     peaks plots.'
    '   '
    '5- Click the peak finder tool again'
    '     to exit and resume processing.'};
