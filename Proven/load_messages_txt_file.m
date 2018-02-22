function data = load_messages_txt_file(handles)
file = fopen([handles.prov_pathname handles.prov_filename]);
d = textscan(file,'%s','delimiter','\n');
fclose(file);
data = loadjson(d{1,1}{numel(d{1,1}),1});