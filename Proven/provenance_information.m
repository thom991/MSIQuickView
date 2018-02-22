function api = provenance_information

    api.send_data_to_Proven = @send_data_to_Proven;
    api.send_provenance_text_file_to_ES = @send_provenance_text_file_to_ES;
    api.msiquickview_prov_save_button_clicked = @msiquickview_prov_save_button_clicked;
    api.seeProvenDebugInfo = @seeProvenDebugInfo;
    
    %% Save the provenance data to text file
    function send_data_to_Proven(msiquickview_version, input_data_names_from_UI, input_data_from_UI)
        %% Inputs
        % msiquickview_version :  jar version number as a string, default 1.0
        % input_data_from_UI : list of data inputs from the UI (passed from the
        % Java call)
        % input_proven_list : proven list of variables provided for the application
        % Example call
        % send_data_to_Proven('1.0', ['ApplicationName'; 'uniqueID'; 'date'; 'scientistName'; 'notes'; 'datasetName'; 'folderLocation'; 'numRawFiles'; 'rawStartNo'; 'aspectRatio'; 'mzRange'; 'mzPlotVals'; 'mzPlotValsThresh'; 'normalizeData'; 'applyChangesToAllImages'; 'saveSettings'; 'redoImage'; 'redoImageExcelfileName'; 'redoImageExcelSheetName'; 'redoImageExcelmzRows'; 'redoImagePDFno'; 'exportPixelsValsToExcel'; 'alignImage'; 'removeLines'; 'interpolatedDataValues'; 'scaleImageValues'; 'colorMap'; 'saveImage'; 'imageListToSave'; 'dpiVal'; 'includeAxisImageSave'], ['MSI QuickView'; 'A001'; '01/01/16'; 'Julia Laskin'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null'; 'null']);
        fprintf('Saving Experimental Information to Proven File/Server.\n')
        t1 = tic;
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
    end

    %% Push the Provenance information to ES
    function send_provenance_text_file_to_ES(application_name, dataset_name, dataset_modality, file_location, handles)
        %% Example Call
        % api = provenance_information;
        % api.send_provenance_text_file_to_ES('MSI_QuickView', 'nic1', 'nanodesi', 'C:\MSIQuickView_code_GIT\html\Proven\messages.txt')
        api = elasticModule;
        api.provenance_info_matlab_to_ES(application_name, dataset_name, dataset_modality, file_location, 'provenance', handles);
    end

    %% Executes when user hits Save Provenance button from the MSI QuickView UI
    function msiquickview_prov_save_button_clicked(handles, execs, myobj, startMsg, pathname)
        set(handles.software_free, 'BackgroundColor', 'red');
        normalize_data_lower_lim = get(handles.normalize_data_lower_limit,'string');
        normalize_data_higher_lim = get(handles.normalize_data_higher_limit,'string');
        normalize_data_checkbox = get(handles.normalize_data_checkbox, 'Value');
        try
            [myobj, startMsg] = set_proven_variable('normalizeData', [num2str(normalize_data_checkbox) ', ' normalize_data_lower_lim ', ' normalize_data_higher_lim], myobj, startMsg);
            execs{numel(execs)+1} = 'submit_prov_Callback(hObject,[],handles)';
            execs_str = strjoin(execs,', ');
            myobj.setMessageTermValue(startMsg,'uniqueID',execs_str);
            cur_dir = pwd;
            mkdir([pathname 'Proven'])
            cd([pathname 'Proven'])
            myobj.sendMessage(startMsg)
            disp('done saving provenance info')
        catch
            helpdlg('Provenance Information could not be saved, check error file. The jar file might not be accessible to MATLAB.');
        end
        try
            disp('Pushing provenance info to ES')
            api = get_file_info;
            dataset_name = api.get_dataset_name(pathname);
            send_provenance_text_file_to_ES('MSI_QuickView', dataset_name, 'nanodesi', [pathname 'Proven' filesep 'messages.txt'], handles)
            disp('done pushing provenance info to ES')
        catch
            helpdlg('Looks like Elasticsearch is either not running or installed on this machine. Please start it in order to push the saved information to Elasticsearch. The ip-address for which ES to use is set in the config.ini in the config folder.');
        end
        cd(cur_dir)
        set(handles.software_free, 'BackgroundColor', 'green');
    end

    function [myobj, startMsg] = set_proven_variable(prov_var_name, prov_var_val, myobj, startMsg)
        myobj.setMessageTermValue(startMsg, prov_var_name, num2str(prov_var_val));
    end

    function seeProvenDebugInfo(handles)
        api = config_file;
        seeProvenDebugInfo = api.read_config_values('Provenance', 'seeDebugInfo');
        if seeProvenDebugInfo
            data = load_messages_txt_file(handles);
            uiwait(msgbox(data.hasProvenance.uniqueID, 'Provenance Steps', 'help'));
        end
    end
end