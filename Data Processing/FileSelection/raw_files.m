function api = raw_files()
    api.read_raw_file = @read_raw_file;
    api.write_raw_file = @write_raw_file;
    
    function handles = read_raw_file(handles)

    end

    function write_raw_file(pathname, filename, j1)
        raw_filename = [pathname filename num2str(j1) '.raw'];
        fileID = fopen(raw_filename,'w');
        fwrite(fileID,'');
        fclose(fileID);
    end

end