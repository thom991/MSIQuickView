%% This code will load Josh's matrix and a point list that defines the number of scans per line 
% It will split the single matrix into 92 different matrixes and use matObj
% to partially save data to the 92 files. 
%% Once we have 92 files representing the 92 datasets, each matrix is saved as text file.
load('C:\Users\thom991\Desktop\smaller92.mat')
load('C:\Users\thom991\Desktop\1-8-2013 92 MS2\First 92 MS2 image\point_list.mat')
cd('C:\Users\thom991\Desktop\deleteplz')
count = 1;
for sec = 1:size(r2,2)
sector1 = oo(:,count:count+r2(sec)-1);
% fprintf('Sec is %f \n',sec)
for i = 1:92;
fprintf('Sec is %f and i is %f \n',sec, i)
x = sector1(:,i:92:end);
if sec == 1
matObj = matfile(['section' num2str(i) '.mat'],'Writable',true);
% save(['section' num2str(i) '.mat'], 'x')
matObj.matr(1:size(sector1,1),1:size(x,2)) = x;
% save(['section' num2str(i) '_Part' num2str(sec) '.mat'], 'x')
else
matObj = matfile(['section' num2str(i) '.mat'],'Writable',true);
[nrows, ncols] = size(matObj,'matr');    
matObj.matr(1:size(sector1,1),ncols+1:ncols+size(x,2)) = x;
end
end
% disp('Done')
% oo(:,1:r2(sec)) = [];
% disp('Done2')
count = count+r2(sec);
end
mz = oo(:,1);
save('mz_vals.mat','mz')
load('C:\Users\thom991\Desktop\deleteplz\mz_vals.mat')
for i = 1:92
load(['C:\Users\thom991\Desktop\deleteplz\section' num2str(i) '.mat'])
dlmwrite(['Part' num2str(i) '.txt'], [mz, matr], 'delimiter', '\t')
end
