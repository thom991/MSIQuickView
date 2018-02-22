function list = auto_generate_filename(handles,last_filename)
%% This function auto-generates filenames;
% Usage Tips: Specify first and last filenames and number of filenames....
% Accepted Formats: 
% First Filename: d01.RAW OR d001.RAW
%Last Filename: d0100.RAW OR d100.RAW
list{1,1} = handles.first_filename;
[~,first_filename1,~] = fileparts(handles.first_filename);
if length(last_filename) > length(handles.first_filename)
    first_filename2 = first_filename1(1:end-1);
    for loop_for_filenames = 1:handles.number_of_files-1
        number_temp = str2num(first_filename1(end)) + loop_for_filenames;
        new_filename = [first_filename2 num2str(number_temp) '.RAW'];
        list{loop_for_filenames+1,1} = new_filename;
        disp(new_filename)
    end
else
    first_filename2 = first_filename1(1:end-1);
    for loop_for_filenames = 1:handles.number_of_files-1
        number_temp = str2num(first_filename1(end)) + loop_for_filenames;
        if loop_for_filenames < 9
            new_filename = [first_filename2 num2str(number_temp) '.RAW'];
        elseif loop_for_filenames < 99
            new_filename = [first_filename2(1:end-1) num2str(number_temp) '.RAW'];            
        else
            new_filename = [first_filename2(1:end-2) num2str(number_temp) '.RAW'];            
        end
        list{loop_for_filenames+1,1} = new_filename;
        disp(new_filename)
    end    
end


