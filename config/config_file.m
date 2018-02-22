function api = config_file

    api.read_config_values = @read_config_values;
    api.read_config_keys = @read_config_keys;
    api.load_config_file_info = @load_config_file_info;
    
    function values = read_config_values(header, value)
        %To read
        %Example Call:
        % values = read_config_file('SaveImage', 'saveImage');
        ini = IniConfig();
        ini.ReadFile('config.ini');
        values = ini.GetValues(header, value);
    end

    function keys = read_config_keys(header)
        %To read
        %Example Call:
        % values = read_config_file('SaveImage', 'saveImage');
        ini = IniConfig();
        ini.ReadFile('config.ini');
        keys = ini.GetKeys(header);
    end

    function handles = load_config_file_info(api, handles)
        handles.saveMSIQuickViewLogs = api.read_config_values('Log', 'saveMSIQuickViewLogs');
        handles.saveDataToFolder = api.read_config_values('Folder', 'saveDataToFolder');
        handles.saveTempFilesToFolder = api.read_config_values('Folder','saveTempFilesToFolder');
        handles.saveImagesToFolder = api.read_config_values('Folder', 'saveImagesToFolder');
        handles.seeProvenDebugInfo = api.read_config_values('Folder', 'seeProvenDebugInfo'); 
        handles.elasticsearchIP = api.read_config_values('Elasticsearch','IP');
        handles.data_access = api.read_config_values('Data', 'access');
        handles.indexName = api.read_config_values('IndexName', 'indexName'); 
    end

end