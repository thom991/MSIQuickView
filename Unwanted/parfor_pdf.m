function parfor_pdf(org_sum_of_int1,org_sum_of_int2,i, k, number_of_scans2, filename2)
% global number_of_scans filename
global pathname
    sum_of_intensities2 = zeros(org_sum_of_int1,org_sum_of_int2,'single');
%     load(strcat('sum_of_intensities',num2str(i),'.mat'))
    load(strcat('sum_of_intensities',num2str(i),'.mat'))
    for j = 1:size(sum_of_intensities2,1)
        vname = sprintf('x%d',j);
%         data = h5read('temp.h5',vname);
        eval_vname = size(eval(vname),2);
%         eval_vname = size(data,2);
        sum_of_intensities2(j,1:eval_vname) = eval(vname);
    end
%         figure; imagesc(sum_of_intensities2);
        sum_of_intensities2 = interpolation_code(sum_of_intensities2, filename2,k, number_of_scans2);
        new_min = 0;    %min of 0 to 255
        new_max = 100;  %max of 0 to 255
        old_min = min(min(sum_of_intensities2(:)));
        old_max = max(max(sum_of_intensities2(:)));    
        % count_3 = 1;
        for count_3 = 1:size(sum_of_intensities2,1)
        for j2 = 1:size(sum_of_intensities2,2)
            value = sum_of_intensities2(count_3, j2);
            sum_of_intensities2(count_3, j2) = ((value - old_min)./(old_max - old_min)).*(new_max - new_min) + (new_min);
        end
        end  
        save(strcat(pathname,saveTempFilesToFolder,filesep,'sum_of_intensities',num2str(i),'.mat'),'sum_of_intensities2')
%         figure(5); imagesc(sum_of_intensities2); pause(0.05);