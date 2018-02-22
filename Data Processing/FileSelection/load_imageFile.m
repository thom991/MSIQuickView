function [cdata, filename, pathname] = load_imageFile(useDefault, msg, ImgPathname, ImgFilename)
    fprintf(msg);
    if ~useDefault
        [filename, pathname] = ...
            uigetfile({'*.png';'*.tiff';'*.tif';'*.jpg';'*.*'},'Select Image to Draw ROIs On..');
    else
        pathname = ImgPathname;
        filename = ImgFilename; 
    end
    img = imread([pathname filename]);
    [r c d]=size(img);
    fprintf('Size of loaded image is %s X %s X %s.\n', num2str(r), num2str(c), num2str(d));
    if size(img, 3) == 3
       fprintf('Selected image is a RGB image.\n')
       cdata=rgb2gray(img); 
    else
       fprintf('Selected image is a grayscale image.\n') 
       cdata = img;
    end
end