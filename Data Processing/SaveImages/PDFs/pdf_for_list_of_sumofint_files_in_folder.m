function pdf_for_list_of_sumofint_files_in_folder
global max_num number_of_scans filename template pathname
api = config_file;
saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
kk = dir(saveTempFilesToFolder);
number_of_mzs = size(kk,1) - 2;
count = 1;
h = figure(1);
for ij = 1:number_of_mzs
        x = load(strcat(pathname,saveTempFilesToFolder,filesep,'sum_of_intensities',num2str(ij),'.mat'));
        subplot(5,2,count); imagesc(x.sum_of_intensities2); title(strcat('mz = ', num2str(template(ij,1)),':',num2str(template(ij,2))));
%         if count == 10 || ij == number_of_mzs
%            count = 0; 
           if count == 10 || ij == number_of_mzs
           count = 0; 
           export_fig(strcat(filename(1:end-3),'pdf'), h)
           clf(h)
           h = figure(1);
           else
           export_fig(strcat(filename(1:end-3),'pdf'), h,'-append')  
           end
%         end
        count = count + 1;    
end