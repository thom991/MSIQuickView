function pdf_for_full_mat_file(tol_val)
global max_num number_of_scans filename
MZ = dlmread('MZ_Values.txt',',');
count = 1;
for no_mz_vals = 76057:size(MZ,1)
    template = zeros(number_of_scans,max(max_num(:)),'single'); 
    current_mz_val = MZ(no_mz_vals); 
    tol_limit = tol_val.*sqrt(current_mz_val/100);
    lower_limit = current_mz_val - tol_limit;
    upper_limit = current_mz_val + tol_limit;
    [m_tol2,n_tol] = find(MZ >= lower_limit & MZ <= upper_limit);
    for i = 1:18
%         sprintf('%f of %f',i,size(M,1))
    % mz_val = M(i,1);
    int_val = sum(Matrix(m_tol2(1):m_tol2(end),:),1);
    for j = 1:size(max_num,2)
       if j == 1
           h = figure(1);
%            set(h, 'Visible','off')
           sum_of_intensities = template;
           sum_of_intensities(1,1:max_num(1)) = int_val(1,1:max_num(1));
       else
    %        disp(j); disp(max_num(j)); disp(max_num(j-1));
    %        disp(max_num(j-1)+1); disp(max_num(j-1)+max_num(j));
           sum_of_intensities(j,1:max_num(j)) = int_val(1,max_num(j-1)+1:max_num(j-1)+max_num(j));
       end
    end
    end
        subplot(5,2,count); imagesc(sum_of_intensities); title(strcat('mz = ', num2str(lower_limit),':',num2str(upper_limit)))
        % pause(.5)
        if count == 10 || i == size(MZ,1)
           count = 0; 
           if i == 10;
           export_fig(strcat(filename(1:end-3),'pdf'), h)
           clf(h)
           else
           export_fig(strcat(filename(1:end-3),'pdf'), h,'-append')  
           clf(h)
           end
        end
        count = count + 1;    
end