function send_data_to_Proven(msiquickview_version, input_data_names_from_UI, input_data_from_UI)
%% Inputs
% msiquickview_version :  jar version number as a string, default 1.0
% input_data_from_UI : list of data inputs from the UI (passed from the
% Java call)
% input_proven_list : proven list of variables provided for the application
%% Example call
% send_data_to_Proven('1.0', ['ApplicationName'; 'uniqueID'; 'date'; 'scientistName'; 'notes'; 'datasetName'; 'folderLocation'; 'numRawFiles'; 'rawStartNo'; 'aspectRatio'; 'mzRange'; 'mzPlotVals'; 'mzPlotValsThresh'; 'normalizeData'; 'applyChangesToAllImages'; 'saveSettings'; 'redoImage'; 'redoImageExcelfileName'; 'redoImageExcelSheetName'; 'redoImageExcelmzRows'; 'redoImagePDFno'; 'exportPixelsValsToExcel'; 'alignImage'; 'removeLines'; 'interpolatedDataValues'; 'scaleImageValues'; 'colorMap'; 'saveImage'; 'imageListToSave'; 'dpiVal'; 'includeAxisImageSave'], ['MSI QuickView'; 'A001'; '01/01/16'; 'Julia Laskin'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null']);
fprintf('Saving Experimental Information to Proven File/Server.\n')
t1 = tic;
% input_data_names_from_UI = cell(input_data_names_from_UI);
% input_data_from_UI = cell(input_data_from_UI);
myobj = gov.pnnl.proven.api.producer.ProvenanceProducer('MSI QuickView', msiquickview_version);
startMsg = myobj.createMessage('StartApplication');
try
    for loop_count = 1:numel(input_data_from_UI)
        myobj.setMessageTermValue(startMsg,input_data_names_from_UI(loop_count),input_data_from_UI(loop_count));
    end
catch MExc
    disp(MExc);
end
cur_dir = pwd;
mkdir([cur_dir filesep 'Proven'])
cd([cur_dir filesep 'Proven'])
myobj.sendMessage(startMsg)
cd(cur_dir)
t2 = toc(t1);
fprintf('Done saving experimental information to Proven File/Server in %s seconds.\n', num2str(t2));
