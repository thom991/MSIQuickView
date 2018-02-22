function [jk] = get_s_and_pixel_loc(new_template,check,int_val2, i, normalize_data_lower_lim, normalize_data_higher_lim, normalize_data_mode2, uz2, new_template2)
% global normalize_data_mode
global pathname
sz = size(new_template,1);
% save(strcat('C:\delete_mat_files\New_Template.mat'),'new_template','-v6')
jk = 1:sz/8:sz;
jk(end+1) = sz;
jk = round(jk);
% for i3 = 1:size(new_template,1)
for i4 = 1:numel(jk)-1
    if normalize_data_mode2 == 1 & i4 == 1
%     disp(size(check))
%     disp(size(int_val2))
%     template2 = [normalize_data_lower_lim, normalize_data_higher_lim];
%     [new_template2,new_uz22] = locs_for_apply_tolerance_to_list_of_mz_vals(template2, uz2);
%     if isempty(new_template2)
%        disp('ERROR: No mz values within normalization range');
%        break;
%     else    
%     save(strcat('C:\delete_mat_files\Template2.mat'),'new_template2','-v6')
    get_s_and_pixel_loc_for_normalization(new_template2, check, int_val2, normalize_data_lower_lim, normalize_data_higher_lim, i);    
%     end
    end
    count = 1;
    p = false(numel(jk(i4):(jk(i4+1)-1)),1);
    for i3 = jk(i4):(jk(i4+1)-1)
out = cellfun(@(check)ismember(check,new_template(i3,1):new_template(i3,2)),check,'un',0);
out = cellfun(@(out)find(out==1),out,'un',0);
a = find(~cellfun(@isempty,out));
if numel(a)>0
for i2 = 1:numel(a)
b = out{1,a(i2)};
% if normalize_data_mode == 0
if b(end) > b(1)
int = sum(int_val2{1,a(i2)}(b(1):b(end)));
else
int = (int_val2{1,a(i2)}(b(1)));    
end
pixel_loc{i2,1} = [a(i2),int];
end
label2 = strcat('mz',num2str(i3));
label1 = strcat('L',num2str(i));
s.(label1).(label2) = pixel_loc;
pixel_loc = [];
p(count,1) = true;% p.(label1).(label2) = ('True');
else
% label1 = strcat('L',num2str(i));    
% label2 = strcat('mz',num2str(i3));
p(count,1) = false; % p.(label1).(label2) = ('False');    
end
count = count + 1;
    end
save(strcat(pathname,saveTempFilesToFolder,filesep,'Line',num2str(i),'_','P',num2str(i4),'.mat'),'s','-v6')
save(strcat(pathname,saveTempFilesToFolder,filesep,'Line',num2str(i),'_Info','P',num2str(i4),'.mat'),'p','-v6')
s = [];
p = [];
% For normalization
% fprintf('norm val is %f \n', normalize_data_mode2)
% if normalize_data_mode2 == 1 & i4 == 1
% %     disp(size(check))
% %     disp(size(int_val2))
%     template2 = [normalize_data_lower_lim, normalize_data_higher_lim];
%     [new_template2,new_uz22] = locs_for_apply_tolerance_to_list_of_mz_vals(template2, uz2);
%     save(strcat('C:\delete_mat_files\Template2.mat'),'new_template2','-v6')
%     get_s_and_pixel_loc_for_normalization(new_template2, check, int_val2, normalize_data_lower_lim, normalize_data_higher_lim, i);    
% end
end

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