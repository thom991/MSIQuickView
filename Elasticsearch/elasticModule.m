function api = elasticModule

    api.app_status_matlab_to_ES = @app_status_matlab_to_ES;
    api.provenance_info_matlab_to_ES = @provenance_info_matlab_to_ES;
    api.addpath = @addpath;
    
    %% Push current process and status to ES
    function app_status_matlab_to_ES(application_name, dataset_name, dataset_modality, process, elapsed, remaining, status, module, handles)
        try
            s = py.dict(pyargs('application_name', application_name, 'dataset_name', dataset_name, 'dataset-modality', dataset_modality, 'process', process, 'elapsed', elapsed, 'remaining', remaining, 'status', status, 'elasticsearchIP', handles.elasticsearchIP, 'data_access', handles.data_access, 'indexName', handles.indexName));
            py.JSON_to_ES.main(s,module);
        catch e
            handleError(e);
        end
    end

    %% Push provenance file info to ES
    function provenance_info_matlab_to_ES(application_name, dataset_name, dataset_modality, file_location, module, handles)
        try
            s = py.dict(pyargs('application_name', application_name, 'dataset_name', dataset_name, 'dataset-modality', dataset_modality, 'text_file_location', file_location, 'elasticsearchIP', handles.elasticsearchIP, 'data_access', handles.data_access, 'indexName', handles.indexName));
            py.JSON_to_ES.main(s,module);
        catch e
            handleError(e);
        end
    end

    function addpath(curPath)
        insert(py.sys.path,int32(0),curPath);
    end

    function handleError(e)
        e.message
        if(isa(e,'matlab.exception.PyException'))
        e.ExceptionObject
        end
    end

end