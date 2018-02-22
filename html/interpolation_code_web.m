function sum_of_intensities2 = interpolation_code_web(sum_of_intensities, number_of_scans, ~, arrayOfHdfFileNames)
%% Creating Unique list of time values
try
for i = 1:number_of_scans
    % USE 1:number_of_scans for using all lines
    % USE only i = 1%: for using only first lines time values.
    fake_name2 = arrayOfHdfFileNames(i,:);
    if strcmp(fake_name2(end-2:end), 'cdf')
        t = ncread(fake_name2,'scan_acquisition_time');
    elseif strcmp(fake_name2(end-2:end), 'hdf')
        t = hdf5read(fake_name2,'scan_acquisition_time');
    end
    if i>1
        t_final = [t; t_final];
        t_final = unique(t_final);
    else
        t_final = t;
    end
end
%% Interp 1-D
sum_of_intensities2 = NaN([size(sum_of_intensities,1),size(t_final,1)]);
for i = 1:number_of_scans
    fake_name2 = arrayOfHdfFileNames(i,:);
    if strcmp(fake_name2(end-2:end), 'cdf')
        t_old = ncread(fake_name2,'scan_acquisition_time');
    elseif strcmp(fake_name2(end-2:end), 'hdf')
        t_old = hdf5read(fake_name2,'scan_acquisition_time');
    end       
    num = size(sum_of_intensities(i,:),2) - size(t_old,1);
    x2 = interp1(t_old, sum_of_intensities(i,(1:end-num)), t_final);
    sum_of_intensities2(i,:) = x2;
end
catch
    fprintf('This is not the MSI QuickView Real-Time Tool, so skipping aligning time-points. Code will continue...\n');
end