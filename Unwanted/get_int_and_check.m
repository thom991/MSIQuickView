function [check1_1,int_val2_1] = get_int_and_check(mass_val,mass_mzs, int_val)
check1_1 = find(ismember(mass_val,mass_mzs) == 1);
int_val2_1 = int_val;
% mass_mzs2{scan_numb} = mass_mzs;
% check{scan_numb} = check1_1;
% int_val2{scan_numb} = int_val2_1;