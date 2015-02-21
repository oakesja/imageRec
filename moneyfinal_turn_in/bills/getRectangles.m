function [ cc ] = getRectangles( img )
% This function will take an RGB image and return a binary image containing
% connected components of rectangles found within the original image.

%select for areas of green hue

hsv = rgb2hsv(img);
hueVals = hsv(:,:,1);
sat = hsv(:,:,2);
vals = hsv(:,:,3);
%imtool(hsv);
mask = (hueVals >  .1 & hueVals < .15 & vals > .5 & sat < .2);
%imtool(mask);
hsv = repmat( mask, [1,1,3]) .* double(hsv); %apply mask to image
%imtool(hsv);


%perform small dilation
I = imdilate(hsv, strel(ones(5,5)));


%perform an edge detection on the image
bw = bwlabel(I(:,:,1), 4);
%imtool(bw);

[height, width, bands] = size(img);
threshold = round(height * width * .1);

BW2 = bwareaopen(bw, threshold);
%return connected components
cc = BW2;

end

