function [new_template,new_uz2] = locs_for_apply_tolerance_to_list_of_mz_vals(template, uz2)
new_template = zeros(size(template,1),size(template,2),'single');
new_uz2 = new_template;
count = 1;
for i = 1:size(template,1)
   range = find(uz2 >= template(i,1) & uz2 <= template(i,2));
   if ~isempty(range)
   high_val = range(end);
   low_val = range(1);
   new_template(count,1) = low_val;
   new_template(count,2) = high_val;
   new_uz2(count,1) = template(i,1);
   new_uz2(count,2) = template(i,2);
   count = count+1;
   end
end
new_template(count:end,:) = [];
new_uz2(count:end,:) = [];

% for i3 = 1:size(new_template,1)
% out = cellfun(@(check)ismember(check,new_template(i3,1):new_template(i3,2)),check,'un',0);
% out = cellfun(@(out)find(out==1),out,'un',0);
% a = find(~cellfun(@isempty,out));
% for i2 = 1:numel(a)
% b = out{1,a(i2)};
% int = sum(int_val2{1,a(1)}(b(1):b(end)));
% pixel_loc{i2,1} = [a(i2),int];
% end
% label2 = strcat('mz',num2str(i3));
% label1 = strcat('L',num2str(1));
% s.(label1).(label2) = pixel_loc;
% end