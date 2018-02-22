function MSi = loadimzMLfile(split_files, number_of_files_to_group)
% LOADIMZMLFILE  Load an imzML format data file
%   MSi = loadimzMLfile(MSi,handles)
% Input
%   MSi        MSiReader application data structure
%   handles    MSiReader GUI handles
% Output
%   MSi        MSiReader application data structure

% Copyright 2012, North Carolina State University
% Written by Guillaume Robichaud and Ken Garrard

fprintf('Inside function loadimzMLfile.\n');

applpath = [pwd filesep];
% Initialize application data structure
MSi = initappldata(applpath,'0.06');

% Get a single imzML file name
[MSi.Filename,MSi.Pathname] = ...
   uigetfile({'*.imzML' 'Imaging Data (*.imzML)'}, ...
              'Select .imzML file to load',pwd,'MultiSelect','Off');

% Return if user clicked cancel button
if isequal(MSi.Filename,0) || isequal(MSi.Pathname,0)
   return;
end

% Make sure the .ibd file is in the same folder
[tilde,fname] = fileparts(MSi.Filename); %#ok<ASGLU>
if isempty(dir([MSi.Pathname fname '.ibd']))
   errordlg({['''' fname '.ibd'''] 'not found in the same directory.'}, ...
            'Load imzML File','modal');
   return;
end

% Add imzMLConverter to the dynamic java path
javaclasspath([pwd filesep 'Dependencies' filesep 'imzMLConverter' filesep 'imzMLConverter.jar']);

% Display waitbar dialog
wtex = 'Reading imzML file, initializing parser ...';


% Initialize imzML parser and get pixel dimensions of the image
imzML = imzMLConverter.ImzMLHandler.parseimzML([MSi.Pathname MSi.Filename]);
cols  = imzML.getWidth();
rows  = imzML.getHeight();

% Check for errors
if (cols == 0) || (rows == 0)
   % Return with an error message
   errordlg({'''Spots per line'' and/or ''number of lines'' parameters'
             'cannot be found in the file.'},'Load imzML file','modal');
   return;
end

% Save number of spots per line and number of lines
MSi.NCol = cols;
MSi.NRow = rows;

% Setup scan list
scanidx = 1:(MSi.NCol*MSi.NRow);

% Fill structure with empty scans
numscan = MSi.NRow*MSi.NCol;
for k = 1:numscan
   MSi.MSo.scan(k).peaks.mz        = [];
   MSi.MSo.scan(k).totalioncurrent = 0;
end

% Storage for peaks data
mzmin = zeros(numscan,1);
mzmax = mzmin;
resol = mzmin;

% imzML file bug workaround -- read first scan and throw it away
try
   imzML.getSpectrum(1,1);
catch ME %#ok<NASGU>
end

% Read the imzML file one scan at a time
wtex = 'Reading imzML file, scan %d of %d';
for j = 1:MSi.NRow
   for k = 1:MSi.NCol
      % Scan index
      si = k + (j-1) * MSi.NCol;


      % Skip scans that are not in the ROI
      if ~scanidx(si), continue; end

      % Skip empty scans
      if isempty(imzML.getSpectrum(k,j)), continue; end

      % Get the mz and abundance data for this scan
      MSi.MSo.scan(si).peaks.mz(:,1) = imzML.getSpectrum(k,j).getmzArray();
      MSi.MSo.scan(si).peaks.mz(:,2) = imzML.getSpectrum(k,j).getIntensityArray();

      % Make sure m/z are monotonically increasing
      if ~issorted(MSi.MSo.scan(si).peaks.mz,'rows')
         MSi.MSo.scan(si).peaks.mz = sortrows(MSi.MSo.scan(si).peaks.mz,1);
      end

      % Get the total ion current, calculate it if missing or errors
      try   TICstr = imzML.getSpectrum(k,j).getCVParam(mzML.Spectrum.totalIonCurrentID).getValue();
            TIC    = str2double(TICstr);
      catch ME %#ok<NASGU>
         TIC = 0;
      end
      if isempty(TIC) || (TIC < 1)
           MSi.NumscanMissingTIC            = MSi.NumscanMissingTIC + 1;
           MSi.MSo.scan(si).totalioncurrent = sum(MSi.MSo.scan(si).peaks.mz(:,2));
      else MSi.MSo.scan(si).totalioncurrent = TIC;
      end

      % Set scans with all zero m/z to empty
      if ~any(MSi.MSo.scan(si).peaks.mz(:,1))
         MSi.MSo.scan(si).peaks.mz = [];
      end

      % Update peaks data
      if ~isempty(MSi.MSo.scan(si).peaks.mz)
         mzmin(si) = min(MSi.MSo.scan(si).peaks.mz(:,1));
         mzmax(si) = max(MSi.MSo.scan(si).peaks.mz(:,1));
         if size(MSi.MSo.scan(si).peaks.mz,1) > 1
            resol(si) = min(diff(MSi.MSo.scan(si).peaks.mz(:,1)));
         end
      end
   end
end

% Find overall range and resolution
MSi.mzMaxofRange = round(max(mzmax));
MSi.mzMinofRange = round(min(mzmin(mzmin~=0)));
MSi.Resolution   = min(resol(resol~=0));

% Save m/z range and resolution vectors
MSi.mzScanRange = [mzmin mzmax resol];
if isempty(split_files)
    convertImzmlForMsiQuickViewScrollingTool(MSi, number_of_files_to_group);
end

fprintf('Loaded imzML file, function loadimzMLfile complete.\n');
