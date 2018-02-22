function [isset, handles] = setProvenDummyValues(handles, num)
%% Start capturing provenance
% handles = guidata(hObject);
clear handles.myobj handles.startMsg
handles.myobj = gov.pnnl.proven.api.producer.ProvenanceProducer('MSI QuickView','1.0');
handles.startMsg = handles.myobj.createMessage('StartApplication');
% Setting default values for all fields in the proven context file
if isfield(handles,'autoflow')
    [answer] =  {handles.answer{num,:}}';
else
    [answer, ~]  = setup_metadata();
end
if ~isempty(answer)
    isset = 1;
    handles.myobj.setMessageTermValue(handles.startMsg,'ApplicationName',answer{1,1})
    handles.myobj.setMessageTermValue(handles.startMsg,'uniqueID',answer{2,1})
    handles.myobj.setMessageTermValue(handles.startMsg,'date',answer{3,1})
    handles.myobj.setMessageTermValue(handles.startMsg,'scientistName',answer{4,1})
    handles.myobj.setMessageTermValue(handles.startMsg,'notes',sprintf('%s', answer{7,1}))
    handles.myobj.setMessageTermValue(handles.startMsg,'datasetName',answer{5,1})
    handles.myobj.setMessageTermValue(handles.startMsg,'folderLocation',answer{6,1})
    handles.myobj.setMessageTermValue(handles.startMsg,'numRawFiles','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'rawStartNo','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'aspectRatio','null, null')
    handles.myobj.setMessageTermValue(handles.startMsg,'mzRange','null, null')
    handles.myobj.setMessageTermValue(handles.startMsg,'mzPlotVals','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'mzPlotValsThresh','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'normalizeData','null, null, null')
    handles.myobj.setMessageTermValue(handles.startMsg,'applyChangesToAllImages','0')
    handles.myobj.setMessageTermValue(handles.startMsg,'saveSettings','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'redoImage','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'redoImageExcelfileName','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'redoImageExcelSheetName','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'redoImageExcelmzRows','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'redoImagePDFno','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'exportPixelsValsToExcel','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'alignImage','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'removeLines','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'interpolatedDataValues','null, null')
    handles.myobj.setMessageTermValue(handles.startMsg,'scaleImageValues','null, null')
    handles.myobj.setMessageTermValue(handles.startMsg,'colorMap','4')
    handles.myobj.setMessageTermValue(handles.startMsg,'saveImage','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'imageListToSave','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'dpiVal','null')
    handles.myobj.setMessageTermValue(handles.startMsg,'includeAxisImageSave','0')
%     guidata(hObject,handles);
else
    isset = 0;
end