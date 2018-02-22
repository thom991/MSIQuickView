% global t_final
function [matr_aligned] = create_aligned_matrix_for_classification(filename, no_of_intensity_files)
%interpolation_code_for_aligning_all_files_in_a_folder('Brain 3-1.raw',1, 15, 10)
global pathname
api = config_file;
saveTempFilesToFolder = api.read_config_values('Folder', 'saveTempFilesToFolder');
cd(strcat(pathname,saveTempFilesToFolder))
%% Creating Unique list of time values
% files = dir(['C:\delete' '/*.hdf']);
% if isempty(t_final)
for no_of_files_to_align = 1:no_of_intensity_files 
% save strcat('sum_of_intensities_aligned_',no_of_files_to_align-1,'.mat') sum_of_intensities
%  save(strcat('sum_of_intensities_aligned_',num2str(no_of_files_to_align-1),'.mat'),sum_of_intensities)
fprintf('Loading File %d \n',no_of_files_to_align);
sum_of_intensities = load(strcat('sum_of_intensities_aligned_', num2str(no_of_files_to_align),'.mat'));
sum_of_intensities = sum_of_intensities.sum_of_intensities2;
s1 = reshape(sum_of_intensities,1,size(sum_of_intensities,1)*size(sum_of_intensities,2));
if no_of_files_to_align == 1
    matr_aligned = zeros(no_of_intensity_files, size(s1,2),'single');
end
matr_aligned(no_of_files_to_align,:) = s1;
end
save(strcat('matr_aligned',filename(1:end-4),'.mat'),'matr_aligned')
