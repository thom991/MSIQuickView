function mass_classification_list = knn_on_a_matrix_after_pca(matrix_start, uz4, imp_mass2, k_start_lda, k_last_lda, isos_dir)
global Sample Training Group pathname
% if matlabpool('size') == 0
%     matlabpool open 8
% end
cd(strcat(pathname,'CDF_Files'))
fprintf('Begin Step 5 of 5.... \n')
% disp('Performing Task !!!!')
% load(strcat(matrix,'\matrix.mat'))
% load(strcat(matrix,'\m1.mat'))
% k_start_lda = get(handles.start_lda,'string');
% k_start_lda = single(str2num(k_start_lda));
% k_last_lda = get(handles.last_lda,'string');
% k_last_lda = single(str2num(k_last_lda));
if isempty(k_start_lda)
    k_start_lda = 1;
end
if isempty(k_last_lda)
    k_last_lda = size(matrix_start,1);
end
matrix_start = matrix_start(~any(isnan(matrix_start),2),:);
reduced_pca_list_start = k_start_lda;
reduced_pca_list_end = k_last_lda;
% new_matr_int(new_matr_int == 'NaN') = [];
% new_matr_int = reshape(new_matr_int,[100,size(point_count,1)]);
% m2 = m1';
count = 1;
for i_knn = reduced_pca_list_start:reduced_pca_list_end
tic    
%     disp(i_knn)
current_mz_val = imp_mass2(i_knn);
corresponding_mz_in_uz4 = find(uz4 == current_mz_val);
Sample = matrix_start(corresponding_mz_in_uz4,:);
A2 = matrix_start;
A2(corresponding_mz_in_uz4,:) = [];
Training = A2;%(A(i_knn,:) == []);
m2 = uz4';%(reduced_pca_list_start:reduced_pca_list_end)
m2(corresponding_mz_in_uz4,:) = [];
Group = m2;%(m1(1,i_knn) == []);
Class(count) = [];%knnclassify(Sample, Training, Group);
count = count + 1;
estimated_time_remaining = (toc.*(reduced_pca_list_end - i_knn)) + 5;
fprintf('Estimated time is %f seconds \n',estimated_time_remaining)
% disp(i_knn)
end
%%
for i_class = 1:count-1
    mass_classification_list(i_class,1) = imp_mass2(i_class);
    mass_classification_list(i_class,2) = Class(i_class);
end
% save knn_results.mat mass_classification_list
current_dir = pwd; %disp(current_dir)
cd(isos_dir)
if exist('Class_List.xls','file')
delete('Class_List.xls')
end
xlswrite('Class_List.xls', mass_classification_list)
cd(current_dir)
disp('DONE !!!!')