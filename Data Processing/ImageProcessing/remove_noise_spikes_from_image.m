function image = remove_noise_spikes_from_image(image, upper_limit)
%% Removes outlier values from the ion image that causes some pixels to appear bright while others appear really dark.
% inputs are:
% 1)ion image
% 2)upper value at which to reduce pixel values
% 3)reduce_by: value to reduce each pixel by
%% Example Call:
% test_image = randi(50,50); image = remove_noise_spikes_from_image(test_image, 5);
examine_image_values = sort(image(:));
difference_between_pixels = diff(examine_image_values);
[m,~] = find(difference_between_pixels > upper_limit);
size_percent = 5; %5%
number_of_pixels_to_include = size_percent*0.01*size(image,1)*size(image,2);
for i = 1:length(m)
   cur_val = examine_image_values(m(i));
   next_val = examine_image_values(m(i)+1);
   reduce_by = next_val - (cur_val + upper_limit);
   [m2,n2] = find(image>cur_val);
   if (length(m) < number_of_pixels_to_include) && (next_val - cur_val > 35)
       for i2 = 1:numel(m2)
          image(m2(i2),n2(i2)) = NaN; 
       end
       break;
   else
       for i2 = 1:numel(m2)
          image(m2(i2),n2(i2)) = image(m2(i2),n2(i2)) - reduce_by; 
       end
       examine_image_values = examine_image_values - reduce_by;
   end
end