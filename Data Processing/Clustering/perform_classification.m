% %create zero matrix for Brain3-1 dataset.
% %row_no is the mz value for which to generate the image
% %1115 is the max scan number for this dataset.
% 
% %load matrix.mat
% load('C:\Users\thom991\Documents\Work\Projects\Mass Spect\Brain\matrix.mat')
% m = matrix_start(8000:8500,:);
% clear matrix_start
% %for uz list
% load('C:\Users\thom991\Documents\Work\Projects\Mass Spect\Brain\uz4.mat')
% mz = uz4(8000:8500);
% clear uz4
% 
% %% For generating pdf
% count4 = 1;
% h = figure(1);
% filename = 'images_for_matrix.raw';
% % img = zeros(15,1115,'single');
% % s1 = [1115,1106,1105,1109,1111,1107,1106,1096,1098,1100,1107,1108,1107,1106,1090];
% s1 = [143,140,144,144,142,144, 143, 144, 145, 144,144, 144, 142,144, 142,143,143,...
%     144,143,145,146,146,144,145,148,148];   
% for row_no = 1:size(m,1)
% img = zeros(26,148,'single');
% % row_no = 30;
% count = 1;
% for i = 1:26%15
%    img(i,1:s1(i)) = m(row_no,count:count+s1(i)-1); 
%    count = count + s1(i);
% end
% subplot(5,2,count4);imagesc(img); title(strcat('mz = ', num2str(mz(row_no)))); %pause(1);
% % kk = dir('C:\delete_mat_files');
% % number_of_mzs = size(kk,1) - 2;
%            if count4 == 10 || row_no == size(m,1)
%            count4 = 0;
% %            if row_no == 1;
% %            export_fig(strcat(filename(1:end-3),'pdf'), h)
%            fnout = ['C:\Users\thom991\Desktop\for_ingela2\images',num2str(row_no), '.pdf'];
%            print('-dpdf','-r150',fnout);
% %            batch = batch + 1;             
% %            else
% %            export_fig(strcat(filename(1:end-3),'pdf'), h,'-append')  
% %            end               
%            clf(h)
%            h = figure(1); set(h, 'Visible','off');
%            disp(row_no)
% %            else
% %            export_fig(strcat(filename(1:end-3),'pdf'), h,'-append')  
%            end
% %         end
%         count4 = count4 + 1;    
% end
% system(['C:\vis_xcalibur_raw_files\pdftk' ' ' strcat('C:\Users\thom991\Desktop\for_ingela2','\*.pdf') ' ' 'output' ' ' strcat('C:\Users\thom991\Desktop\for_ingela2\','combined.pdf')]);

%%
function perform_classification(list_point_count, filename5, pathname5)
% clear all
% clc
%Read in Josh's Matrix
count100 = 1;
file_no = 56;
for kk = 0.1:0.2:1.1
M = dlmread([pathname5,filename5]);%('aligned_2D8R4T1_sn3_2.5e3.txt');
mz = M(:,1);
m = M(:,2:end);
for i = 1:5177
    num2 = m(m(i,:)>0);
    num(i) = size(num2,2);
end
for i = 1:5177
   if num(i) < 30
      m(i,:) = 0; 
   end
end
mz(all(m==0,2),:)=[];
m(all(m==0,2),:)=[];
% m=mat2gray(m)*(1-realmin) + realmin;

%Linkage Analysis
uz4 = mz;
D = pdist(m,'correlation');
Z = squareform(D);
L = linkage(Z,'complete','correlation');
c = cophenet(L,D);
I = inconsistent(L);
cut_off_val = kk;
disp(kk)
T2 = cluster(L,'cutoff',cut_off_val);
class_list_final = zeros(max(T2(:)),100,'single');
class_list_final(class_list_final==0) = NaN;
% class_list_final2 = zeros(max(T2(:)),100,'single');
class_list_final2 = class_list_final;
for class_list = 1:max(T2(:))
   current_class = find(T2 == class_list);
    for i_current_class = 1:size(current_class,1)
        if current_class(i_current_class) <= size(uz4,1)
            new_current_list(i_current_class) = uz4(current_class(i_current_class));
            new_mz_loc_list(i_current_class) = current_class(i_current_class);
        else
            new_current_list(i_current_class) = strcat(current_class,'*');
            new_mz_loc_list(i_current_class) = strcat(current_class,'*');
        end
    end   
Cluster_fn.(sprintf('Class%d', class_list)) = new_current_list;
class_list_final(class_list,1:size(new_current_list,2)) = new_current_list;
class_list_final2(class_list,1:size(new_current_list,2)) = new_mz_loc_list;
new_current_list = [];
new_mz_loc_list = [];
end
s1 = list_point_count;%[143,140,144,144,142,144, 143, 144, 145, 144,144, 144, 142,144, 142,143,143,...
    %144,143,145,146,146,144,145,148,148]; 
j2 = 1;
for i = 1:size(class_list_final2,1)
%     uu = class_list_final2(~isnan(class_list_final2(i,:)));
    [m2,n2] = find(~isnan(class_list_final2(i,:)));
    for i3 = 1:size(n2,2)
    uu(i3) = class_list_final2(i,n2(i3));
    end
    if i == 1
    i55 = i;
    end
    if size(uu,2) > 0 %&& size(uu,2) <= 10 
        for j = 1:size(uu,2)
            img = zeros(26,148,'single');
            % row_no = 30;
            count = 1;
            for i2 = 1:26%15
               img(i2,1:s1(i2)) = m(uu(j),count:count+s1(i2)-1); 
               count = count + s1(i2);
            end
%             img = histeq(img, [0, 255]);
            h = subplot(6,3,j2); imagesc(img); title(strcat('Class',num2str(i),' mz ', num2str(mz(uu(j))))); %pause(.5); 
            axis off 
            j2 = j2+1;
%             i55 = i;
            if j2 > 18%10
                   if i == 1
                   mkdir(['C:\Users\thom991\Desktop\for_ingela',num2str(count100)])
                   end        
                   fnout = ['C:\Users\thom991\Desktop\for_ingela',num2str(count100),'\images',num2str(i55*10^-4), '.pdf'];
                   print('-dpdf','-r150',fnout);
                   i55 = i55 + 1;
                   j2 = 1;
                   clf(figure(1))                        
            end
        end
           if i == 1
           mkdir(['C:\Users\thom991\Desktop\for_ingela',num2str(count100)])
           end        
        if j2 == 19%11
           fnout = ['C:\Users\thom991\Desktop\for_ingela',num2str(count100),'\images',num2str(i55*10^-4), '.pdf'];
           print('-dpdf','-r150',fnout);
           i55 = i55+1;
           j2 = 0;
           clf(figure(1))           
        end
%         j2 = j2+1;
    end
%     h1 = [];
% cla reset
%     clf(figure(1))
uu = [];
% delete(h1);
end
% system(['C:\vis_xcalibur_raw_files\pdftk' ' ' strcat('C:\Users\thom991\Desktop\for_ingela',num2str(count100),'\*.pdf') ' ' 'output' ' ' strcat('C:\Users\thom991\Desktop\for_ingela',num2str(count100),'\combined.pdf')]);
system(['C:\vis_xcalibur_raw_files\pdftk' ' ' strcat('C:\Users\thom991\Desktop\for_ingela',num2str(count100),'\*.pdf') ' ' 'output' ' ' strcat('C:\Users\thom991\Desktop\diff_methods_pdfs\pdf_list',num2str(file_no),'.pdf')]);
count100 = count100 + 1;
file_no = file_no + 1;
end