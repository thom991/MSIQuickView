function cell_loc_for_each_scan(scan_numb,loc, int_val)
global cell_loc
% cell_loc{scan_numb,1} 
x = [loc,int_val];
x(any(x==0,2),:) = [];
cell_loc{scan_numb,1} = x;
% cell_loc{scan_numb,2} = int_val;