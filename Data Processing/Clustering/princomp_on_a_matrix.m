function imp_mass2 = princomp_on_a_matrix(matr, uz4, isos_dir)
% load(matr)
fprintf('Begin Step 4 of 5.... \n')
[pc10,score10] = princomp(matr); %[pc10,score10,latent10,tsquare10]
[st3, index2] = sort(score10(:,1),'descend');
if size(uz4,1) > size(uz4,2)
    uz3 = uz4;
else
    uz3 = uz4';
end
for i = 1:size(index2,1)
extreme2(i,1) = index2(i);
imp_mass2(i,1) = uz3(extreme2(i,1),:);
end
current_dir = pwd;
cd(isos_dir); %disp(current_dir)
if exist('PCA_List.xls','file')
delete('PCA_List.xls')
end
xlswrite('PCA_List.xls', imp_mass2)
cd(current_dir)
% save princomp_results.mat imp_mass2

% fake_mz = [];
% temp = find(imp_mass2 > 429 & imp_mass2 < 430);
% for iii = 1:size(temp,1); fake_mz(iii) = imp_mass2(temp(iii)); end
