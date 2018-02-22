[FileName,PathName,FilterIndex] = uigetfile('*yep');
req_name = strcat(PathName,FileName);
part1 = 'CompassXport -a "';
part2 = req_name;
part3 = '" -o "';
part4 = strcat(PathName,'converted_file','_',FileName(1:end-3),'mzXML','"');
name = strcat(part1,part2,part3,part4);
dos(name);
data_set = [];%mzxmlread(part4(1:end-1));
% data_set --> Index --> Offset
for i = 1:data_set.mzXML.msRun.scanCount 
    values(i) = data_set.index.offset(1,i).value;
end
figure; subplot(5,1,1);plot(values); title('offset values'); %Does not look like the required data
% data_set --> peaks
for i = 1:data_set.mzXML.msRun.scanCount 
    values_temp = data_set.scan(i,1).peaks.mz;
    values2(i) = mean(values_temp);
end
subplot(5,1,2);plot(values2); title('Mean of Peaks (mz) from 1:scant count number');
for i = 537%:data_set.mzXML.msRun.scanCount 
    values_intensity = data_set.scan(i,1).peaks.mz(2:2:end);
    values_time = data_set.scan(i,1).peaks.mz(1:2:end);
subplot(5,1,4);plot(values_time,2*values_intensity); title('Mean of Peaks (mz) from 1:scant count number');
end
% data_set --> peak_count
for i = 1:data_set.mzXML.msRun.scanCount 
    values3(i) = data_set.scan(i,1).peaksCount;
%     values2(i) = mean(values_temp);
end
subplot(5,1,3);plot(values3); title('Plot of Peaks Count (mz) from 1:scant count number');
for i = 1:data_set.mzXML.msRun.scanCount 
    values_temp = data_set.scan(i,1).totIonCurrent;
    values4(i) = values_temp;
end
subplot(5,1,5);plot(values4); title('Total Ion Current');
for i = 1:data_set.mzXML.msRun.scanCount 
    time = data_set.index.offset(1,i).value;
%     time2 = data_set.index.offset(1,i+1).value;
    time_trial(i) = time/(data_set.index.offset(1,1).value);%/3600;
%     values4(i) = values_temp;
end