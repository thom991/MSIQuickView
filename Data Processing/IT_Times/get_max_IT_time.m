function IT_times = get_max_IT_time(pathname,ll)
%% Function to get the max IT time (ERROR IT Time) from a folder containing xls files of IT times for all scans and all lines
% Input: folder containing the IT files (xls)
% Output: IT_timess, for e.g., 500
load([pathname 'ROI_pts.mat'])
for i = 1:size(ROI_pts.unique_y_vals,2)
    [m,n] = find(ROI_pts.full_y == ROI_pts.unique_y_vals(i));
    g = ROI_pts.full_x(n);
    k = ROI_pts.unique_y_vals(i);%-1;
    %         disp(k)
    fake_name2 = ll{1,k};
    fake_name2(end-3:end) = '.xls';
    disp(fake_name2)
    ii = dlmread([pathname 'Header_Files' filesep fake_name2],'\t',1, 1);
    vals = ii(g,:)';
    max_val(i) = max(max(vals(1,:)));
end
IT_times = max(max_val(:));