% global t_final
function sum_of_intensities2 = interpolation_code_clustering(sum_of_intensities, filename2)
global O_was_present t_final pathname cdf_filename ll %t_old 
tic
O_was_present = 1;
cd(strcat(pathname,'HDF_Files'))
%% Creating Unique list of time values
number_of_scans = dir([pathname 'HDF_Files' '/*.hdf']);
number_of_scans = size(number_of_scans,1);
% if isempty(t_final)
k = 1;
k2 = k;
filename = cdf_filename;
fake_name2 = filename(1:size(filename,2)-5); 
% fprintf('filename == %s \n',filename); disp(filename); fprintf('k is %f \n', k); 
if isempty(t_final)
for i = 1:number_of_scans%size(files,1)  
% USE 1:number_of_scans for using all lines
% USE only i = 1%: for using only first lines time values.

%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';
%             if k+1 <= number_of_scans
%             if k == 9 && fake_name2(size(filename,2)-5) ~= '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';   
% %             elseif k == 8 && fake_name2(size(filename,2)-5) ~= '0'
% %                 fake_name_next = fake_name2;
% %                 fake_name_next(size(filename,2)-4) = num2str(k+1);
% %                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw'; 
%             elseif k == 9 && fake_name2(size(filename,2)-5) == '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                 fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';   
%             else
%                 fake_name_next = fake_name2;
%                 fake_name_next((size(filename,2))-4) = num2str(k+1);
%             end    
%             else
%                 fake_name_next = fake_name2;
%             end            
%         else
%             if k == 10 && filename(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW'; 
%             O_was_present = 1;
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else        
%                     fake_name_next = fake_name2;
%                 end
%             elseif k>10 && ~isempty(O_was_present)&& k <100% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';     
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             else
%             fake_name2(size(filename,2)-5:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.RAW'; 
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                     fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             end
%         end            
           fake_name2 = ll{1,k};
           if k+1 <= number_of_scans
            fake_name_next = ll{1,k+1};
           end
        cdf_begin = fake_name2;
        hdf_filename = [cdf_begin(1:end-4) '.hdf' ];
%
% if k < 10
%     fake_name2((size(filename,2))-4) = num2str(k);
%     fake_name2((size(filename,2))-3:(size(filename,2))) = '.raw';
%     if k == 9
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';   
%     else
%         fake_name_next = fake_name2;
%         fake_name_next((size(filename,2))-4) = num2str(k+1);
%     end
% else 
%     fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%     fake_name2(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     if k+1 < number_of_scans
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     else
%         fake_name_next = fake_name2;
%     end
% end
% % RAW_filename_new2 = strcat(pathname,fake_name2);
% cdf_begin = strcat('C:\delete\',fake_name2);
% % cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
% hdf_filename = [cdf_begin(1:end-4) '.hdf' ]; 
t = ncread(hdf_filename,'scan_acquisition_time');
if i>1
    t_final = [t; t_final];
    t_final = unique(t_final);
else
    t_final = t;
end
% end
k = k+1;
end
end
%% Interp 1-D
k = k2;
sum_of_intensities2 = NaN([size(sum_of_intensities,1),size(t_final,1)]);
fake_name2 = filename(1:size(filename,2)-5); 
for i = 1:number_of_scans%size(files,1)
% fake_name2 = filename(1:size(filename,2)-5); 

%         if k < 10
%             fake_name2(size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';
%             if k+1 <= number_of_scans
%             if k == 9 && fake_name2(size(filename,2)-5) ~= '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';   
% %             elseif k == 8 && fake_name2(size(filename,2)-5) ~= '0'
% %                 fake_name_next = fake_name2;
% %                 fake_name_next(size(filename,2)-4) = num2str(k+1);
% %                 fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw'; 
%             elseif k == 9 && fake_name2(size(filename,2)-5) == '0'
%                 fake_name_next = fake_name2;
%                 fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                 fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';   
%             else
%                 fake_name_next = fake_name2;
%                 fake_name_next((size(filename,2))-4) = num2str(k+1);
%             end    
%             else
%                 fake_name_next = fake_name2;
%             end            
%         else
%             if k == 10 && filename(size(filename,2)-5) == '0'
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW'; 
%             O_was_present = 1;
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else        
%                     fake_name_next = fake_name2;
%                 end
%             elseif k>10 && ~isempty(O_was_present)% == 1
%             fake_name2(size(filename,2)-5:size(filename,2)-4) = num2str(k);
%             fake_name2(size(filename,2)-3:size(filename,2)) = '.RAW';     
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-5:size(filename,2)-4) = num2str(k+1);
%                     fake_name_next(size(filename,2)-3:size(filename,2)) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             else
%             fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%             fake_name2(size(filename,2)-2:size(filename,2)+1) = '.RAW'; 
%                 if k+1 <= number_of_scans
%                     fake_name_next = fake_name2;
%                     fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%                     fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.RAW';
%                 else
%                     fake_name_next = fake_name2;
%                 end            
%             end
%         end            
           fake_name2 = ll{1,k};
           if k+1 <= number_of_scans
            fake_name_next = ll{1,k+1};
           end
        cdf_begin = fake_name2;
        hdf_filename = [cdf_begin(1:end-4) '.hdf' ];
% if k < 10
%     fake_name2((size(filename,2))-4) = num2str(k);
%     fake_name2((size(filename,2))-3:(size(filename,2))) = '.raw';
%     if k == 9
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';   
%     else
%         fake_name_next = fake_name2;
%         fake_name_next((size(filename,2))-4) = num2str(k+1);
%     end
% else 
%     fake_name2(size(filename,2)-4:size(filename,2)-3) = num2str(k);
%     fake_name2(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     if k+1 < number_of_scans
%         fake_name_next = fake_name2;
%         fake_name_next(size(filename,2)-4:size(filename,2)-3) = num2str(k+1);
%         fake_name_next(size(filename,2)-2:size(filename,2)+1) = '.raw';
%     else
%         fake_name_next = fake_name2;
%     end
% end
% % RAW_filename_new2 = strcat(pathname,fake_name2);
% cdf_begin = strcat('C:\delete\',fake_name2);
% % cdf_filename = [cdf_begin(1:end-4) '.cdf' ]; 
% hdf_filename = [cdf_begin(1:end-4) '.hdf' ]; 
t_old = hdfread(hdf_filename,'scan_acquisition_time');
num = size(sum_of_intensities(i,:),2) - size(t_old,1);
x2 = interp1(t_old, sum_of_intensities(i,(1:end-num)), t_final);
sum_of_intensities2(i,:) = x2;
% disp(size(t_old,1))
k = k+1;
end
%% Replacing NaNs with values
% for i = 1:number_of_scans
% q = ~isnan(sum_of_intensities2(i,:)); 
% ix = find(q,1,'first');
% sum_of_intensities2(i,1:ix-1) = sum_of_intensities2(i,ix);
% ix = find(q,1,'last');
% sum_of_intensities2(i,ix+1:end) = sum_of_intensities2(i,ix);
% end



% sum_of_intensities2(isnan(sum_of_intensities2)) = 0;

% for i = 1:number_of_scans
% ii = find(isnan(sum_of_intensities2(i,:)) == 1);
% lower_ts = find(ii < size(t_final,1)/2);
% if ~isempty(lower_ts)
%     for temp = 1:size(lower_ts,2)
%         current_NaN = lower_ts(temp); 
%         [ff_m, ff_n] = find(~isnan(sum_of_intensities2(i, current_NaN:end))== 1, 1);
%         sum_of_intensities2(i, current_NaN) = sum_of_intensities2(i, current_NaN + ff_n - 1);  
% %         while temp2 < size(lower_ts,2)
% %             if isnan(sum_of_intensities2(i,temp2+1)) == 0
% %                 sum_of_intensities2(i,ii(temp)) = sum_of_intensities2(i,ii(size(lower_ts,2))+1);
% %                 temp2 = size(lower_ts,2); 
% %                 loc = ii(size(lower_ts,2))+1;             
% %             end
% %         end
% %         temp2 = loc;
%     end
% end
% higher_ts = find(ii > size(t_final,1)/2);
% if ~isempty(higher_ts)
%     for temp2 = 1:size(higher_ts,2)
%         current_NaN2 = higher_ts(temp2); 
%         [ff_m2, ff_n2] = find(~isnan(sum_of_intensities2(i, (size(t_final,1)/2):end))== 1);
%         ff_n2 = ff_n2(end);
%         sum_of_intensities2(i, current_NaN2) = sum_of_intensities2(i, current_NaN + ff_n - 1);  
%         sum_of_intensities2(i,ii(higher_ts(temp))) = sum_of_intensities2(i,ii(higher_ts(1))-1);
%     end
% end
% end
% time = toc; %disp(time);
