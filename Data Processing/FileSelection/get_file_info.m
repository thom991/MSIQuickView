function api = get_file_info
    api.get_dataset_name = @get_dataset_name;
    function dataset_name = get_dataset_name(pathname)
        [~,dataset_name,~] = fileparts(pathname(1:end-1));
        fprintf('Dataset is %s.\n', dataset_name);
    end
end