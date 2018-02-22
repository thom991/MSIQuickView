function api1 = save_logs
    api1.start_logging = @start_logging;
    api1.stop_logging = @stop_logging;
    api1.delete_logs = @delete_logs;
    
    function start_logging()
        api = config_file;
        saveMSIQuickViewLogs = api.read_config_values('Folder', 'saveMSIQuickViewLogs');
        diary([saveMSIQuickViewLogs 'logs.txt'])
    end

    function stop_logging()
        diary off
    end

    function delete_logs()
        if exist([saveMSIQuickViewLogs 'logs.txt'],'file')
            delete([saveMSIQuickViewLogs 'logs.txt'])   
        end
    end
end