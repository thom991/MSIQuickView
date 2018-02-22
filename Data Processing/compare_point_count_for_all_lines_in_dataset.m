function r2 = compare_point_count_for_all_lines_in_dataset(direc_name)
count = 1;
cd(direc_name)
ff = dir([direc_name '/*.cdf']);
for i = 1:size(ff,1)
name = ff(i,1).name;
% name = 'b_1.cdf';
% total_intensity = single(ncread(name,'total_intensity'));
disp(name)
disp(pwd)
scan_acquisition_time = (ncread(name,'scan_acquisition_time'));
scan_acquisition_time = scan_acquisition_time/60;
% intensity_values = single(ncread(name,'intensity_values'));
% mass_values = single(ncread(name,'mass_values'));
point_count = (ncread(name,'point_count'));
time_val = scan_acquisition_time(end);
% mass_range_max = ncread(name,'mass_range_max');
% mass_range_min = ncread(name,'mass_range_min');
% time_list = zeros(size(mass_values,1),1,'single');
% initial_scan_acquisition_time = zeros(size(scan_acquisition_time,1)+1,1);
% initial_scan_acquisition_time2 = zeros(size(scan_acquisition_time,1),1);
% initial_scan_acquisition_time(1) = 0;
% initial_scan_acquisition_time(2:end) = scan_acquisition_time;
% for i = 2:size(scan_acquisition_time,1)
%     initial_scan_acquisition_time2(i) = (initial_scan_acquisition_time(i)+initial_scan_acquisition_time(i-1))*10;%sum(initial_scan_acquisition_time(1:i))*10;
% end
% count = 1;
% for i = 1:size(point_count,1)
%     time_list(count:count+point_count(i)-1) = repmat(initial_scan_acquisition_time2(i),point_count(i),1); 
%     count = count+point_count(i);
% end
% list(count) = size(point_count,1);
fid = fopen(strcat('number_of_points_per_line','.txt'), 'a');
fprintf(fid, 'Line_number = %d\t %d\t %f\n',count, size(point_count,1),time_val);
fclose(fid);
% fid = fopen(strcat(name(1:end-4),'.txt'), 'a');
% fprintf(fid, 'X_VALUE\t    MZ_VALUE\t   INTENSITY\n');
% fclose(fid);
% y = [time_list,mass_values,intensity_values]';
% fid = fopen(strcat(name(1:end-4),'.txt'), 'a');
% fprintf(fid, '%f\t %f\t %f\n', y);
% fclose(fid);
r2(count) = size(point_count,1);
count = count+1;
end