function newdata = downsample2D(data, newsize)
    
    [oldrows, oldcols] = size(data);
   
    rows = newsize(1);
    cols = newsize(2);
    
    half_x_diff = floor((oldrows-rows)/2);
    half_y_diff = floor((oldcols-cols)/2);
    
%     new_x_range = (half_x_diff):(oldrows-half_x_diff-1);
%     new_y_range = (half_y_diff):(oldcols-half_y_diff-1);

    new_x_range = [1:half_x_diff+1, (oldrows-half_x_diff):oldrows];
    new_y_range = [1:half_y_diff+1, (oldcols-half_y_diff):oldcols];
    
%     size(new_x_range)
%     size(new_y_range)

    xfactor = rows/oldrows;
    yfactor = cols/oldcols;
    
    f = fft2(data);
%     f = fftshift(f);
    f = f(new_x_range, new_y_range)*xfactor*yfactor;
    size(f)
    temp = ifft2(f);
%     temp = ifftshift(temp);
    
    newdata = real(temp);
    
