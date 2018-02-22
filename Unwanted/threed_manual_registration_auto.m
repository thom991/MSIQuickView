% global original_pts modified_pts
function threed_manual_registration_auto(cdata)
% prompt = {'Please Enter Slice #:'};
% dlg_title = 'Input';
% num_lines = 1;
% def = {'1'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
% i2 = str2num(answer{1,1});
for i2 = 1:16
        load(['C:\threed_trial_images\Ginput_Positions' num2str(i2) '.mat'])
% %         x = u(1:end/2);
% %         y = u(end/2+1:end);
        H = imcrop(cdata, [position(1) position(2) position(3) position(4)] ); 
        figure(1);imagesc(H);colormap(strcat('hot','(32)'));%axis image
        B = H;%imresize(H, [500 500]);
        % imwrite(B,strcat('C:\threed_trial_images\Part',num2str(i),'.png'),'png')
        save(strcat('C:\threed_trial_images\Part',num2str(i2),'.mat'),'B')
%         save(['C:\threed_trial_images\Ginput_Positions' num2str(i2) '.mat'], 'u')
end



% for i = 1%:19
%     rotationGUI(i)
%     uiwait
% end
% save(['C:\threed_trial_images\original_pts' num2str(i) '.mat'],'org_pts')
% save(['C:\threed_trial_images\modified_pts' num2str(i) '.mat'],'mod_pts')