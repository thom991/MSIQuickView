function UserInput = userInput(i1,i2)
    %userInput Name a ROI Section
    %Inputs: 
    % i1 - Total number of lines in the image
    % i2 - ROI Section Part #
    prompt = {['Name for ROI section:' num2str(i2)]};
    dlg_title = 'User Input';
    num_lines = 1;
    defaultans = {i1};
    UserInput = inputdlg(prompt,dlg_title,num_lines,defaultans);
end