function [start_end_loc_for_means, mz_means_list_for_each_block, locs] = generate_mz_means_list_for_each_block(uz2, thresh_val)
uz2_diff = diff(uz2);
[locs] = find(uz2_diff > thresh_val);
% locs = locs - 1;
if locs(end) < size(uz2,1)
locs(end+1) = size(uz2,1);
end
current_loc = 1;
count = 1;
%plot ??
mz_means_list_for_each_block = zeros(size(locs,1),1);
start_end_loc_for_means = zeros(size(locs,1),2);
for numbr_of_locs = 1:size(locs,1)
    mz_means_list_for_each_block(numbr_of_locs,1) = mean(uz2(current_loc:locs(numbr_of_locs)));
    start_end_loc_for_means(count,1) = current_loc;
    start_end_loc_for_means(count,2) = locs(numbr_of_locs);
    current_loc = locs(numbr_of_locs) + 1;
    count = count + 1;
end
Y = [thresh_val thresh_val];
X = [1 size(uz2_diff,1)];
% axes(handles.stats_plot1)
plot(uz2_diff)
hold on
% scatter(locs(1:end-1),pks)
line(X,Y,'LineWidth',2,'LineStyle','-.','Color',[.2 .2 .2])
hold off
% set(handles.stats_table1,mz_means_list_for_each_block) 