function newdata = downsample3D(data, newsize)
    
    [old_L, old_M, old_N] = size(data);
   
    new_L = newsize(1);
    new_M = newsize(2);
    new_N = newsize(3);
    
    half_x = floor(new_L/2);
    half_y = floor(new_M/2);
    half_z = floor(new_N/2);

    new_x_range = [1:(half_x), (old_L-half_x+1):old_L];
    new_y_range = [1:(half_y), (old_M-half_y+1):old_M];
    new_z_range = [1:(half_z), (old_N-half_z+1):old_N];

    xfactor = new_L/old_L;
    yfactor = new_M/old_M;
    zfactor = new_N/old_N;
    type=class(data);
    if(~strcmp(type,'single')||~strcmp(type,'double'))
      f = fftn(single(data));
    else
      f = fftn(data);
    end
    f = f(new_x_range, new_y_range, new_z_range)*xfactor*yfactor*zfactor;
    'old size'
    size(data)
    'new size'
    size(f)
    temp = ifftn(f);
    
    newdata = real(temp);
    if(~strcmp(type,'single')||~strcmp(type,'double'))
        newdata=cast(newdata,type);
    end

    
