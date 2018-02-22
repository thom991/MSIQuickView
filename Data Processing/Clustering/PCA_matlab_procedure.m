function imp_mass = PCA_matlab_procedure
global first_filename number_of_scans val_min val_max val_mean
global filename count_2 sum_of_intensities colormap_3d O_was_present lower_limit_mz_value upper_limit_mz_value single_range_value double_range_value pathname
global lower_limit_mz_value_sure1 upper_limit_mz_value_sure1 ll

api = config_file;
saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
load(strcat(pathname,saveTempFilesToFolder,filesep,'mz_values.mat'))
% [coefs,scores,variances,t2] = princomp(sr);
for j = 1:number_of_scans
filename = strcat(pathname,saveTempFilesToFolder,filesep, first_filename(1:end-5),num2str(j),'.mat');
load(filename)
[coefs,scores,variances,t2] = princomp(sure1);
% percent_explained = 100*variances/sum(variances);
[st2, index] = sort(t2,'descend');
for i = 1:size(sure1,1)/3
extreme(j,i) = index(i);
% extreme(1,2) = index(2);
% extreme(1,3) = index(3);
% extreme(1,4) = index(4);
% extreme(1,5) = index(5);
% extreme(1,6) = index(6);
% extreme(1,7) = index(7);
% extreme(1,8) = index(8);
% extreme(1,9) = index(9);
% extreme(1,10) = index(10);
imp_mass(j,i) = mass_values_list(extreme(j,i),:);
end
end
% plot(mass_values_list,sure1);
% extreme = index(2)
% mass_values_list(extreme,:);

%%Kmeans

nColors = get(handles.edit_box_number_of_clusters,'string');
nColors = single(str2num(nColors)); %7;
if isempty(nColors)
    nColors = 7;
end
% val_down_interpolated_data = 5;
% val_across_interpolated_data = 2;
ab = double(imp_mass);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(imp_mass,nrows*ncols,1);
[cluster_idx cluster_center] = kmeans(ab,nColors,'replicates',5);
pixel_labels = reshape(cluster_idx,nrows,ncols);
% pixel_labels = imresize(pixel_labels(:,:),[size(pixel_labels,1)*val_down_interpolated_data,size(pixel_labels,2)*val_across_interpolated_data]);
% sum_of_intensities = imresize(sum_of_intensities(:,:),[size(sum_of_intensities,1)*val_down_interpolated_data,size(sum_of_intensities,2)*val_across_interpolated_data]);
% figure;imagesc(pixel_labels)
% figure;imagesc(sum_of_intensities)


% figure;imagesc(pixel_labels==1)
% hold on
% imagesc(pixel_labels==2)
% imagesc(pixel_labels==3)
% imagesc(pixel_labels==4)
% imagesc(pixel_labels==5)
% hold off
for i_n = 1:nColors
val_min(i_n) = min(imp_mass(pixel_labels == i_n));
val_max(i_n) = max(imp_mass(pixel_labels == i_n));
val_mean(i_n) = mean(imp_mass(pixel_labels == i_n));



%%
% global filename count_2 sum_of_intensities colormap_3d O_was_present lower_limit_mz_value upper_limit_mz_value single_range_value double_range_value pathname
% global lower_limit_mz_value_sure1 upper_limit_mz_value_sure1
current_dir = pwd;
cd(strcat(pathname,saveTempFilesToFolder))
fake_name2(1:size(filename,2)-5) = filename(1:size(filename,2)-5); 
%     cd(pathname);
%     sum_of_intensities_try55 = zeros(size(sum_of_intensities,1),size(sum_of_intensities,2),'single');
    k = 1;
    for i = 1:count_2-1
%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.mat';
%         else
%             if k == 10 && fake_name2(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.mat'; 
%             O_was_present = 1;
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.mat';                 
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.mat';   
%             end
%         end             
            fake_name2 = ll{1,k};
            fake_name2(end-3:end) = '.hdf'; 
        RAW_filename_new2 = strcat(pathname,'HDF_Files',filesep,fake_name);
%         cdf_begin = strcat('C:\delete\',fake_name2);
        load(RAW_filename_new2);
        %%
        if k == 1
            load(strcat(pathname,saveTempFilesToFolder,filesep,'mz_values.mat'));
        end
        if isempty(single_range_value)
            lower_limit_mz_value_sure1 = find(mass_values_list >= lower_limit_mz_value & mass_values_list < lower_limit_mz_value +1);
            upper_limit_mz_value_sure1 = find(mass_values_list <= upper_limit_mz_value & mass_values_list > upper_limit_mz_value -1);            
            sure1 = sum(sure1(lower_limit_mz_value_sure1(1):upper_limit_mz_value_sure1(end),:),1);
            sum_of_intensities(i,1:size(sure1,2)) = sure1;
            k = k+1;        
        elseif isempty(double_range_value)
            lower_limit_mz_value_sure1 = find(mass_values_list > lower_limit_mz_value & mass_values_list < lower_limit_mz_value +1);
            sure1 = sure1(lower_limit_mz_value_sure1(1),:);
            sum_of_intensities(i,1:size(sure1,2)) = sure1;
            k = k+1;    
        end
        %%
        
%         if k == 1
%         [value,location] = max(sure1(:));
%         [R,C] = ind2sub(size(sure1),location);
%         end
%         sum_of_intensities(i,1:size(sure1(R,:),2)) = sure1(R,:);
%         k = k+1;
    end
for count_3 = 1:size(sum_of_intensities,1)    
new_min = 0;    %min of 0 to 255
new_max = 100;  %max of 0 to 255
old_min = min(min(sum_of_intensities(count_3,:)));
old_max = max(max(sum_of_intensities(count_3,:)));    
% count_3 = 1;
% for count_3 = 1:size(sum_of_intensities,1)
for j2 = 1:size(sum_of_intensities,2)
    value = sum_of_intensities(count_3, j2);
    sum_of_intensities(count_3, j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
end
end
name_fig(i) = strcat('MZ_',val_min(i_n),'_',val_max(i_n),'.tif');
save name_fig sum_of_intensities
% cla(handles.zone_specified_plot);
% axes(handles.zone_specified_plot);
% imagesc(sum_of_intensities);
% xlabel('Time'); ylabel('Intensity');
% colormap(colormap_3d); h = colorbar('location','eastoutside'); set(h, 'YColor', [0 0 0])
cd(current_dir)
end

fileFolder = strcat(pathname,saveTempFilesToFolder);
dirOutput = dir(fullfile(fileFolder,'*.tif'));
fileNames = {dirOutput.name}';
montage(fileNames, 'DisplayRange', []);