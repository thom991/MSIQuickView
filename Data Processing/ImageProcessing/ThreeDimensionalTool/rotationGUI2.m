function rotationGUI2(i)
    %# read image
    global original_pts modified_pts x y I I2
    x = [];
    y = [];
    IO = load(strcat('C:\threed_trial_images\Part',num2str(1),'.mat'));
    I = load(strcat('C:\threed_trial_images\Part',num2str(i-1),'.mat'));
    I = I.B;
%     subplot(2,1,1); image(I);
    I2 = load(strcat('C:\threed_trial_images\Part',num2str(i),'.mat'));
    I2 = I2.B;
%     subplot(2,1,2); image(I2);    
%     [x,y] = ginput;
%     x_org = x(1:2:end);
%     x_mod = x(2:2:end);
%     y_org = y(1:2:end);
%     y_mod = y(2:2:end);
%     org_pts = [x_org,y_org];
%     mod_pts = [x_mod,y_mod];
% %     original_pts.(['val' num2str(1)]) = org_pts;
% %     modified_pts.(['val' num2str(1)]) = mod_pts;
load(['C:\threed_trial_images\original_pts' num2str(i) '.mat'])
load(['C:\threed_trial_images\modified_pts' num2str(i) '.mat'])
TFORM = cp2tform(mod_pts, org_pts, 'similarity');
[rows cols]=size(IO.B);
% Define the location of the image in the output space
xd = [1 cols];
yd = [1 rows];
% xys = [1 1];
J = imtransform(I2,TFORM, 'Xdata', xd, 'Ydata', yd);%, 'XYScale', xys);
figure(2);imagesc(J); %colormap(strcat('hot','(32)'));
%     save(['C:\threed_trial_images\original_pts' num2str(i) '.mat'],'org_pts')
% save(['C:\threed_trial_images\modified_pts' num2str(i) '.mat'],'mod_pts')
save(strcat('C:\threed_trial_images\Part',num2str(i),'_modified.mat'),'J')
% x = round(x);
% y = round(y);
% u(i,:) = [x;y]';
%     %# setup GUI
%     hFig = figure('menu','none');
%     hAx = axes('Parent',hFig);
%     uicontrol('Parent',hFig, 'Style','slider', 'Value',0, 'Min',0,...
%         'Max',360, 'SliderStep',[1 10]./360, ...
%         'Position',[150 5 300 20], 'Callback',@slider_callback) 
%     hTxt = uicontrol('Style','text', 'Position',[290 28 20 15], 'String','0');
% 
%     %# show image
%     imagesc(I, 'Parent',hAx)
% 
%     %# Callback function
%     function slider_callback(hObj, eventdata)
%         angle = round(get(hObj,'Value'));        %# get rotation angle in degrees
%         imagesc(imrotate(I,angle), 'Parent',hAx)  %# rotate image
%         set(hTxt, 'String',num2str(angle))       %# update text
%         angle2 = angle;
%         save(strcat('C:\threed_trial_images\angle',num2str(i),'.mat'),'angle2')
%     end
%     
end