function sd3 = generate_3d_matrix_from_2d_slices
global newdata max_x max_y max_z
x2 = load(strcat('C:\threed_trial_images\Part',num2str(1),'.mat'));
sd3(:,:,1) = x2.B; 
prompt = {'Please # of Slices:', 'Enter desired x-dimension:', 'Enter desired y-dimension:', 'Enter desired z-dimension:'};
dlg_title = 'Input';
num_lines = 1;
def = {'16',num2str(size(x2.B,2)),num2str(size(x2.B,1)),'48'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
maxi = str2num(answer{1,1});
max_x = str2num(answer{2,1});
max_y = str2num(answer{3,1});
max_z = str2num(answer{4,1});
for i = 2:maxi
x2 = load(strcat('C:\threed_trial_images\Part',num2str(i),'_modified.mat'));
sd3(:,:,i) = x2.J;
end
% newdata = downsample3D(sd3, [size(sd3,1) 500 size(sd3,3)]);
% % val_down_interpolated_data = 20;
% % val_across_interpolated_data = 1;
% % for i = 1:size(sd3,3)
% % sum_of_intensities2(:,:,i) = imresize(sd3(:,:,i),[size(sd3,1)*val_down_interpolated_data,size(sd3,2)*val_across_interpolated_data],'bilinear');
% % end
% % for i = 1:size(sd3,1)
% % sum_of_intensities3(i,:,:) = imresize(sd3(i,:,:),[size(sd3,2)*val_down_interpolated_data,size(sd3,3)*val_across_interpolated_data],'bilinear');
% % end
ny=max_y;%size(sd3,1);
nx=max_x;
nz=max_z; %% desired output dimensions
[y x z]=...
   ndgrid(linspace(1,size(sd3,1),ny),...
          linspace(1,size(sd3,2),nx),...
          linspace(1,size(sd3,3),nz));
imOut=interp3(double(sd3),x,y,z);
% 
% for i = 1:max_z
%     figure(1);imagesc(imOut(:,:,i)); pause(0.05);colormap(strcat('hot','(32)'));
% end
FileName2 = uigetdir('C:\','Select folder to save images');
%% Save vtk for paraview
writeVTK(imOut,[FileName2 filesep 'vtkTRIALfile.vtk'])
%% Save tiff for ImageJ
for i = 1:max_z
saveastiff(single(imOut(:,:,i)), [FileName2 filesep 'img' num2str(i) '.tif'])
end