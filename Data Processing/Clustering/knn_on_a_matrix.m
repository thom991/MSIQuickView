function mass_classification_list = knn_on_a_matrix(matrix_start, uz4,isos_dir)
global pathname
% if matlabpool('size') == 0
%     matlabpool open 8
% end
cd(strcat(pathname,'CDF_Files'))
disp('Performing Task !!!!')
% load(strcat(matrix,'\matrix.mat'))
% load(strcat(matrix,'\m1.mat'))
% k_start_lda = get(handles.start_lda,'string');
% k_start_lda = single(str2num(k_start_lda));
% k_last_lda = get(handles.last_lda,'string');
% k_last_lda = single(str2num(k_last_lda));
matrix_start = matrix_start(~any(isnan(matrix_start),2),:);
% new_matr_int(new_matr_int == 'NaN') = [];
% new_matr_int = reshape(new_matr_int,[100,size(point_count,1)]);
% m2 = m1';
for i_knn = 1:size(matrix_start,1)
%     disp(i_knn)
Sample = matrix_start(i_knn,:);
A2 = matrix_start;
A2(i_knn,:) = [];
Training = A2;%(A(i_knn,:) == []);
m2 = uz4';
m2(i_knn,:) = [];
Group = m2;%(m1(1,i_knn) == []);
Class(i_knn) = [];%knnclassify(Sample, Training, Group);
% disp(i_knn)
end
%%
for i_class = 1:size(matrix_start,1)
    mass_classification_list(i_class,1) = uz4(i_class);
    mass_classification_list(i_class,2) = Class(i_class);
end
current_dir = pwd;
cd(isos_dir)
if exist('Class_List.xls','file')
delete('Class_List.xls')
end
xlswrite('Class_List.xls', mass_classification_list)
cd(current_dir)
% save knn_results.mat mass_classification_list
disp('DONE !!!!')