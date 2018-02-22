function [return_val] = check_ROI_size_with_image(image, roiList, number_of_ROIs_to_check_for)
    userRoiNames = fieldnames(roiList);
    for i = 1:number_of_ROIs_to_check_for
       if size(image) == size(roiList.(userRoiNames{i}))
          return_val = false;
       else
          return_val = true; 
       end
    end
end