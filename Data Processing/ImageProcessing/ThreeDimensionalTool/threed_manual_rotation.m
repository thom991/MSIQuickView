function threed_manual_rotation
prompt = {'Please Enter Slice #:'};
dlg_title = 'Input';
num_lines = 1;
def = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
i = str2num(answer{1,1});
if exist(['C:\threed_trial_images\original_pts' num2str(i) '.mat'],'file')
    % Construct a questdlg with three options
choice = questdlg('File for rotation already exists, Replace ?', ...
	'Warning', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
rotationGUI(i)
uiwait
    case 'No'
rotationGUI2(i)
end
else
rotationGUI(i)
uiwait    
end
