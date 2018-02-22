function apply_tolerance_to_list_of_mz_vals(tol_val)
global mz_means_list_for_each_block template
% MZ = dlmread('MZ_Values.txt',',');
MZ = mz_means_list_for_each_block;
template = zeros(size(MZ,1),2,'single'); 
for no_mz_vals = 1:size(MZ,1)
    current_mz_val = MZ(no_mz_vals); 
    tol_limit = tol_val.*sqrt(current_mz_val/100);
    lower_limit = current_mz_val - tol_limit;
    upper_limit = current_mz_val + tol_limit;
    template(no_mz_vals,1) = lower_limit;
    template(no_mz_vals,2) = upper_limit; 
end