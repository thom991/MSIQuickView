function C = load_scrolling_UI(handles, id, pathname)
load([pathname 'mz_list' filesep 'mz_vals_p' num2str(id) '.mat'])
C = single(C);
x = strtrim(cellstr(num2str(C, 8)));
set(handles.listbox1,'string',x);
