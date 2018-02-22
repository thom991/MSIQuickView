function handles = set_proven_variable(~, prov_var_name, prov_var_val, handles)
handles.myobj.setMessageTermValue(handles.startMsg, prov_var_name, num2str(prov_var_val));