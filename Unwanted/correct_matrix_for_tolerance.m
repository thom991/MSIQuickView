for i = 1:size(uz4,1)
current_mz_val = uz4(i);
tolerance_limit = 0.005.*sqrt(current_mz_val/100);
lower_tolerance_limit = current_mz_val - tolerance_limit;
higher_tolerance_limit = current_mz_val + tolerance_limit;
[m,n] = find(uz4 >= lower_tolerance_limit & uz4 <= higher_tolerance_limit); 
if size(m,1) > 1
    new_mz = mean(uz4(m(1):m(end)));
    new_int = max(matrix_start(m(1):m(end),:));
    uz4(m(1)+1:m(end)) = []; 
    matrix_start(m(1)+1:m(end),:) = [];
    uz4(m(1)) = new_mz;
    matrix_start(m(1),:) = new_int;
end
if i == size(uz4,1)
    break;
end
end