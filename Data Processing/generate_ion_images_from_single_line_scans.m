function xnorm = generate_ion_images_from_single_line_scans(file_name, org_sum_of_intensities1, org_sum_of_intensities2, ~)
% This function takes the sum_of_intensities%.mat files that have the
% structure X1,X2,X3....XN and generates ion image without saving the
% output. This is useful to generate real time ion images for an excel
% spreadsheet during the actual imaging process. 
% If the sum_of_intensities%.mat file has the full ion map, it will just
% display that ion image as well.....
ss = load(file_name);
r = structfun(@numel,ss);
if size(r,1) > 1
    sum_of_intensities2 = NaN([org_sum_of_intensities1,org_sum_of_intensities2]);
    for j = 1:size(sum_of_intensities2,1)
        vname = sprintf('ss.x%d',j);
        eval_vname = size(eval(vname),2);
        sum_of_intensities2(j,1:eval_vname) = eval(vname);
    end
else
    sum_of_intensities2 = ss.sum_of_intensities2;
end
xnorm = sum_of_intensities2; %scale_image_to_fixed_limits(0, 100, sum_of_intensities2);
