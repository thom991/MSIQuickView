% global original_pts modified_pts
function threed_manual_registration(x4)
global h2 position position2
prompt = {'Please Enter Slice #:'};
dlg_title = 'Input';
num_lines = 1;
def = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
i2 = str2num(answer{1,1});
if exist(['C:\threed_trial_images\Ginput_Positions' num2str(i2) '.mat'],'file')
    % Construct a questdlg with three options
choice = questdlg('File for cropping already exists, Replace ?', ...
	'Warning', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        if isempty(position2)
            [FileName,PathName] = uigetfile('*.mat','Select the POSITION.MAT file for Rectangular Coordinates');
            c = load([PathName FileName]);
            position2 = c.position2;
        end
%         for i = 1:20
        % image(cdata); 
        % %freehand drawing
        % h = imfreehand(gca);
        % binaryImage = h.createMask();
        % I = rgb2gray(cdata);
        % f = I.*uint8(binaryImage);
        % MyMatrix = binaryImage;
        % TF = MyMatrix==0;
        % TFrow = ~all(TF,2);
        % row_low = find(TFrow,1,'first');
        % row_high = find(TFrow,1,'last');
        % 
        % TFrow = ~all(TF,1);
        % col_low = find(TFrow,1,'first');
        % col_high = find(TFrow,1,'last');
        % 
        % row_low = row_low - 1;
        % row_high = row_high + 1;
        % col_low = col_low - 1;
        % col_high = col_high + 1;
        % 
        % H = imcrop(f, [col_low row_low (col_high-col_low) (row_high-row_low)]); 
        %% 4 point clicks per slice
        figure(1);imagesc(x4); %colormap(strcat('hot','(32)'));
%         [x,y] = ginput(4);
        h2 = imrect(gca, [position2(1) position2(2) position2(3) position2(4)]);
        position = wait(h2);
%         x = round(x);
%         y = round(y);
%         u = [x;y]';
        H = imcrop(x4, [position(1) position(2) position(3) position(4)] ); 
        figure(1);imagesc(H);%colormap(strcat('hot','(32)'));%axis image
        B = H;%imresize(H, [500 500]);
        % imwrite(B,strcat('C:\threed_trial_images\Part',num2str(i),'.png'),'png')
        save(strcat('C:\threed_trial_images\Part',num2str(i2),'.mat'),'B')
        save(['C:\threed_trial_images\Ginput_Positions' num2str(i2) '.mat'], 'position')
    case 'No'
        load(['C:\threed_trial_images\Ginput_Positions' num2str(i2) '.mat'])
%         x = u(1:end/2);
%         y = u(end/2+1:end);
        H = imcrop(x4, [position(1) position(2) position(3) position(4)]); 
        figure(1);imagesc(H);%colormap(strcat('hot','(32)'));%axis image
        B = H;%imresize(H, [500 500]);
        % imwrite(B,strcat('C:\threed_trial_images\Part',num2str(i),'.png'),'png')
        save(strcat('C:\threed_trial_images\Part',num2str(i2),'.mat'),'B')
%         save(['C:\threed_trial_images\Ginput_Positions' num2str(i2) '.mat'], 'u')
end
else
%         for i = 1:20
        % image(cdata); 
        % %freehand drawing
        % h = imfreehand(gca);
        % binaryImage = h.createMask();
        % I = rgb2gray(cdata);
        % f = I.*uint8(binaryImage);
        % MyMatrix = binaryImage;
        % TF = MyMatrix==0;
        % TFrow = ~all(TF,2);
        % row_low = find(TFrow,1,'first');
        % row_high = find(TFrow,1,'last');
        % 
        % TFrow = ~all(TF,1);
        % col_low = find(TFrow,1,'first');
        % col_high = find(TFrow,1,'last');
        % 
        % row_low = row_low - 1;
        % row_high = row_high + 1;
        % col_low = col_low - 1;
        % col_high = col_high + 1;
        % 
        % H = imcrop(f, [col_low row_low (col_high-col_low) (row_high-row_low)]); 
        %% 4 point clicks per slice
        figure(1);imagesc(x4);%colormap(strcat('hot','(32)')); 
%         [x,y] = ginput(4);
        h2 = imrect(gca, [position2(1) position2(2) position2(3) position2(4)]);
        position = wait(h2);
%         x = round(x);
%         y = round(y);
%         u = [x;y]';
        H = imcrop(x4, [position(1) position(2) position(3) position(4)] ); 
        figure(1);imagesc(H);%colormap(strcat('hot','(32)')); %axis image
        B = H; %imresize(H, [500 500]);
        % imwrite(B,strcat('C:\threed_trial_images\Part',num2str(i),'.png'),'png')
        save(strcat('C:\threed_trial_images\Part',num2str(i2),'.mat'),'B')
        save(['C:\threed_trial_images\Ginput_Positions' num2str(i2) '.mat'], 'position')
end



% for i = 1%:19
%     rotationGUI(i)
%     uiwait
% end
% save(['C:\threed_trial_images\original_pts' num2str(i) '.mat'],'org_pts')
% save(['C:\threed_trial_images\modified_pts' num2str(i) '.mat'],'mod_pts')