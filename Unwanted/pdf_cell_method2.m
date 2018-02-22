function pdf_cell_method2(number_of_scans, sum_of_intensities, jk, i, count, filename2, normalize_data_mode2, uz2)
% global filename
% filename = 'lipneg01.RAW';
% filename = filename2;
% disp(filename)
disp(size(uz2))
    count2 = jk(i); 
%     disp(count2);
    g = [];
    image_temp2 = zeros(size(sum_of_intensities,1),size(sum_of_intensities,2),'single');
    for j = 1:number_of_scans
        label10 = strcat('L',num2str(j));
        d = (load([pathname saveTempFilesToFolder filesep 'Line' num2str(j) '_P' num2str(i) '.mat']));
        e.(label10) = d.s.(strcat('L',num2str(j)));
        f = (load([pathname saveTempFilesToFolder filesep 'Line' num2str(j) '_InfoP' num2str(i) '.mat']));
        g(:,j) = f.p;
        if normalize_data_mode2 == 1
%                 label11 = strcat('L',num2str(j));
                d2 = (load([pathname saveTempFilesToFolder filesep 'Line' num2str(j) '_Norm.mat']));
                d2 = cell2mat(d2.int2.(['L' num2str(j)]).mz1);
%                 for i_norm = 1:size(d2,1)
                    image_temp2(j,d2(:,1)) = d2(:,2);
%                 end
        end     
            
            
    end
%     disp('1')
count = 1;
batch = 1;
h = figure(i); set(h, 'Visible','off'); %colormap(hot)
for ii2 = 1:size(g,1)   
    uu = find(g(ii2,:)== 1);
    image_temp = zeros(size(sum_of_intensities,1),size(sum_of_intensities,2),'single');
%     disp('2')
for ii = 1:numel(uu)
%     disp(strcat('L',num2str(uu(ii)))); disp(strcat('mz',num2str(count2)))
    list1 = e.(strcat('L',num2str(uu(ii)))).(strcat('mz',num2str(count2)));
    list1_1 = cell2mat(list1);
    image_temp(uu(ii),list1_1(:,1)) = list1_1(:,2);
end
lower_mz = uz2(count2,1); higher_mz = uz2(count2,2);
% k = 1;
if normalize_data_mode2 == 1
    image_temp = image_temp./image_temp2;
end
sum_of_intensities2 = interpolation_code(image_temp, number_of_scans, filename2);
% disp('3')
count2 = count2+1;
%imagesc(image_temp); %pause(1);
        subplot(5,2,count); imagesc(sum_of_intensities2); colormap(hot); title(strcat(num2str(lower_mz),'-',num2str(higher_mz))); %title(strcat('mz = ', num2str(lower_limit),':',num2str(upper_limit)))
        % pause(.5)
        if count == 10 && ii2 == size(g,1)
           count = 0;
%            colormap(hot)
           fnout = [pathname, saveTempFilesToFolder, filesep, 'images',num2str(i),filesep,'fig_', num2str(batch), '.pdf'];
           print('-dpdf','-r150',fnout);
           batch = batch + 1;  
           close(h)
%            h = figure(i); set(h, 'Visible','off')
        elseif count == 10 || ii2 == size(g,1)
           count = 0;
%            colormap(hot)
           fnout = [pathname, saveTempFilesToFolder, filesep, 'images',num2str(i),filesep,'fig_', num2str(batch), '.pdf'];
           print('-dpdf','-r150',fnout);
           batch = batch + 1;  
           close(h)
           h = figure(i); set(h, 'Visible','off'); %colormap(hot)            
        elseif ii2 == size(g,1)
           count = 0;
%            colormap(hot)
           fnout = [pathname, saveTempFilesToFolder, filesep, 'images',num2str(i),filesep,'fig_', num2str(batch), '.pdf'];
           print('-dpdf','-r150',fnout);
           batch = batch + 1;  
           close(h)
%            h = figure(i); set(h, 'Visible','off')             
        end
        count = count + 1;  
end