function get_s_and_pixel_loc_for_normalization(new_template2, check,int_val2, normalize_data_lower_lim, normalize_data_higher_lim, i)
global pathname
% sz = size(new_template,1);
% jk = 1:sz/8:sz;
% jk(end+1) = sz;
% jk = round(jk);
% % for i3 = 1:size(new_template,1)
% for i4 = 1:numel(jk)-1
%     count = 1;
%     p = false(numel(jk(i4):(jk(i4+1)-1)),1);
%     for i3 = jk(i4):(jk(i4+1)-1)
% sz = size(new_template,1);
% jk = 1:sz/8:sz;
% jk(end+1) = sz;
% jk = round(jk);
% for i3 = 1:size(new_template,1)
% for i4_2 = 1:numel(jk)-1
%     count = 1;
%     p = false(numel(jk(i4_2):(jk(i4_2+1)-1)),1);
%     for i3 = jk(i4_2):(jk(i4_2+1)-1)
% fprintf('low val is %f \n',normalize_data_lower_lim)
% fprintf('high val is %f \n',normalize_data_higher_lim)
save(strcat(pathname,saveTemporaryFilesToFolder,filesep,'Check.mat'),'check','-v6')
out2 = cellfun(@(check)ismember(check,new_template2(1,1):new_template2(1,2)),check,'un',0);
out2 = cellfun(@(out2)find(out2==1),out2,'un',0);
a2 = find(~cellfun(@isempty,out2));
disp(size(a2))
if numel(a2)>0
for i2_2 = 1:numel(a2)
b2 = out2{1,a2(i2_2)};
% if normalize_data_mode == 0
if b2(end) > b2(1)
int2 = sum(int_val2{1,a2(i2_2)}(b2(1):b2(end)));
else
int2 = (int_val2{1,a2(i2_2)}(b2(1)));    
end
pixel_loc2{i2_2,1} = [a2(i2_2),int2];
end
label2 = strcat('mz',num2str(1));
label1 = strcat('L',num2str(i));
int2.(label1).(label2) = pixel_loc2;
pixel_loc2 = [];
p2 = true;% p.(label1).(label2) = ('True');
else
% label1 = strcat('L',num2str(i));    
% label2 = strcat('mz',num2str(i3));
p2 = false; % p.(label1).(label2) = ('False');    
end
% count = count + 1;
%     end
save(strcat(pathname,saveTempFilesToFolder,filesep,'Line',num2str(i),'_','Norm.mat'),'int2','-v6')
save(strcat(pathname,saveTempFilesToFolder,filesep,'Line',num2str(i),'_Info','Norm.mat'),'p2','-v6')
int2 = [];
p2 = [];
% end
% end
% label2 = strcat('mz',num2str(i3));
% label1 = strcat('L',num2str(i));
% s.(label1).(label2) = pixel_loc;
% pixel_loc = [];
% p(count,1) = true;% p.(label1).(label2) = ('True');
% else
% % label1 = strcat('L',num2str(i));    
% % label2 = strcat('mz',num2str(i3));
% p(count,1) = false; % p.(label1).(label2) = ('False');    
% end
% count = count + 1;
%     end
% save(strcat('C:\delete_mat_files\Line',num2str(i),'_','P',num2str(i4),'.mat'),'s','-v6')
% save(strcat('C:\delete_mat_files\Line',num2str(i),'_Info','P',num2str(i4),'.mat'),'p','-v6')
% s = [];
% p = [];
% end

% for i = 1:8
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
% figure(i); imagesc(image_temp); %pause(1);
% end
% end