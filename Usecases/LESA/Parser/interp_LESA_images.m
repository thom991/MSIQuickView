function [ imatrix ] = interp_LESA_images( sum_of_intensities, nrows, ncols, handles )
global XSpacing YSpacing
MSi.NRow = nrows;
MSi.NCol = ncols;

MSi.XSpacing = XSpacing;
MSi.YSpacing = YSpacing;

%Enter ItType and Order
MSi.ItType = 'linear';
MSi.ItOrder = 2;

% Interpolate ?
if MSi.ItOrder > 0 
    imatrix = interp2(sum_of_intensities,MSi.ItOrder,MSi.ItType);
end

% New plot in heatmap axes
dx    = MSi.XSpacing/1000;
dy    = MSi.YSpacing/1000;
xdata = [0 dx*(MSi.NCol-1)] + dx/2;
ydata = [0 dy*(MSi.NRow-1)] + dy/2;
axes(handles.axes1)
imagesc(xdata,ydata,imatrix);
% Disable context menu colormap editor
colorbar('UIContextMenu',[]);
end

