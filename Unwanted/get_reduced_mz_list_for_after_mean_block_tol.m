% main_list = list_of_rows_to_combine;
% main_list2 = list_of_rows_to_remove;
list_of_rows_to_combine = (main_list);
list_of_rows_to_remove = (main_list2);
list_of_rows_to_combine(:,3) = zeros(size(list_of_rows_to_combine,1),1);
current_row_no_list_of_rows_to_combine = 1;
current_row_no_in_list_of_rows_to_remove = 1;
change_row = [];
ij = 1;
while ij <= size(list_of_rows_to_combine,1) 
   vals = list_of_rows_to_combine(ij,1:2);
   start_val = vals(1); 
   end_val = vals(2);
   diff_val = diff(vals); %37
   if current_row_no_in_list_of_rows_to_remove < size(list_of_rows_to_remove,1)
   if list_of_rows_to_remove(current_row_no_in_list_of_rows_to_remove) == end_val + 1
       next_start_val = list_of_rows_to_combine(ij+1,1); %72
%        diff_val =  diff_val ;%+ 
no_vals = size(end_val + 1:next_start_val,2) - 1; %2
list_of_rows_to_combine(ij,3) = no_vals;
       change_row = 1;
   else
       no_of_vals_to_remove =  0;
   end
   end
       if diff_val > 0
           list_of_rows_to_combine(ij+1:end,1:2) = list_of_rows_to_combine(ij+1:end,1:2) - (diff_val);
           list_of_rows_to_remove(current_row_no_in_list_of_rows_to_remove:end) = list_of_rows_to_remove(current_row_no_in_list_of_rows_to_remove:end) - diff_val; 
       else
           
       end
   if change_row == 1
       list_of_rows_to_combine(ij+1:end,1:2) = list_of_rows_to_combine(ij+1:end,1:2) - no_vals;
       current_row_no_in_list_of_rows_to_remove = current_row_no_in_list_of_rows_to_remove+no_vals;    
       list_of_rows_to_remove(current_row_no_in_list_of_rows_to_remove:end) = list_of_rows_to_remove(current_row_no_in_list_of_rows_to_remove:end) - no_vals;
       change_row = 0;
   end
   ij = ij + 1;
end