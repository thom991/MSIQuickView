function [m, uz4, L, I, mz, compare_matr] = linkage_analysis(pathname5,filename5,min_no_of_pixels, pdist_option, linkage_option,pathname6,filename6,number_of_matrixes_to_open)
% global 
disp(min_no_of_pixels)
M2 = dlmread(strcat(pathname5,filename5));%('aligned_2D8R4T1_sn3_2.5e3.txt');
mz = M2(:,1);
m = M2(:,2:end);
disp('m');disp(size(m))
for i = 1:size(m,1)
    num2 = m(m(i,:)>0);
    num(i) = size(num2,2);
end
% min_no_of_pixels = str2num(get(handles.min_pixel_no,'string'));
if isempty(min_no_of_pixels)
    min_no_of_pixels = 1;
end
for i = 1:size(m,1)
   if num(i) < min_no_of_pixels
      m(i,:) = 0; 
   end
end
mz(all(m==0,2),:)=[];
m(all(m==0,2),:)=[];
compare_matr = size(m,1);
%%
if number_of_matrixes_to_open > 1
M3 = dlmread(strcat(pathname6,filename6));%('aligned_2D8R4T1_sn3_2.5e3.txt');
mz2 = M3(:,1);
m2 = M3(:,2:end);   
disp('m2');disp(size(m2))
%
for i = 1:size(m2,1)
    num2 = m2(m2(i,:)>0);
    num(i) = size(num2,2);
end
% min_no_of_pixels = str2num(get(handles.min_pixel_no,'string'));
if isempty(min_no_of_pixels)
    min_no_of_pixels = 1;
end
for i = 1:size(m2,1)
   if num(i) < min_no_of_pixels
      m2(i,:) = 0; 
   end
end
mz2(all(m2==0,2),:)=[];
m2(all(m2==0,2),:)=[];
%
if size(m2,2) <= size(m,2)
    m(end+1:end+size(m2,1),1:size(m2,2)) = m2;
    mz(end+1:end+size(m2,1)) = mz2;
elseif size(m2,2) > size(m,2)
    m(:,end+size(m2,2)) = 0;
    m(end+1:end+size(m2,1),1:size(m2,2)) = m2;    
    mz(end+1:end+size(m2,1)) = mz2;        
end
end
%%
clear M2
disp('stage 1')
if isempty(pdist_option)
  pdist_option = 'correlation';  
end
if isempty(linkage_option)
  linkage_option = 'average';  
end
% m=mat2gray(m)*(1-realmin) + realmin;
disp(size(m))
% disp(size(M2))
%Linkage Analysis
uz4 = mz;
D = pdist(m,pdist_option);
disp('stage 5')
% Z = squareform(D);
disp('stage 6')
L = linkage(D,linkage_option);%,'average','correlation');
% c = cophenet(L,D);
I = inconsistent(L);