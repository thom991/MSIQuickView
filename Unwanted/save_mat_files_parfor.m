function save_mat_files_parfor(oo, vname, sum_of_intensities_temp2)
eval([vname, '=sum_of_intensities_temp2;'])
save(strcat('sum_of_intensities',num2str(oo),'.mat'),vname)