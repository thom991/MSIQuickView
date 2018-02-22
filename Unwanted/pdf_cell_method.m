function pdf_cell_method(new_template,normalize_data_mode2,uz2)
% global filename
global number_of_scans sum_of_intensities filename
filename2 = filename;
sz = size(new_template,1);
jk = 1:sz/8:sz;
jk(end+1) = sz;
jk = round(jk);
count = 1;
% MZ = load('C:\delete_mat_files\Template.mat');
matlabpool open
parfor i = 1:8
    pdf_cell_method2(number_of_scans, sum_of_intensities, jk, i, count, filename2, normalize_data_mode2, uz2)
%     count2 = jk(i); 
% %     disp(count2);
%     g = [];
%     for j = 1:number_of_scans
%         label10 = strcat('L',num2str(j));
%         d = (load(['C:\delete_mat_files\Line' num2str(j) '_P' num2str(i) '.mat']));
%         e.(label10) = d.s.(strcat('L',num2str(j)));
%         f = (load(['C:\delete_mat_files\Line' num2str(j) '_InfoP' num2str(i) '.mat']));
%         g(:,j) = f.p;
%     end
% %     disp('1')
% for ii2 = 1:size(g,1)   
%     uu = find(g(ii2,:)== 1);
%     image_temp = zeros(size(sum_of_intensities,1),size(sum_of_intensities,2),'single');
% %     disp('2')
% for ii = 1:numel(uu)
% %     disp(strcat('L',num2str(uu(ii)))); disp(strcat('mz',num2str(count2)))
%     list1 = e.(strcat('L',num2str(uu(ii)))).(strcat('mz',num2str(count2)));
%     list1_1 = cell2mat(list1);
%     image_temp(uu(ii),list1_1(:,1)) = list1_1(:,2);
% end
% % disp('3')
% count2 = count2+1;
% h = figure(i); imagesc(image_temp); %pause(1);
%         subplot(5,2,count); imagesc(image_temp); %title(strcat('mz = ', num2str(lower_limit),':',num2str(upper_limit)))
%         % pause(.5)
%         if count == 10 || i == size(f,1)
%            count = 0; 
%            if i == 10;
%            export_fig(strcat(filename(1:end-4),'_P',num2str(i),'pdf'), h)
%            clf(h)
%            else
%            export_fig(strcat(filename(1:end-4),'_P',num2str(i),'pdf'), h,'-append')  
%            clf(h)
%            end
%         end
%         count = count + 1;  
% end
end
% matlabpool close