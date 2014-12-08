% lightest yellow - 253, 252, 137 
% darkest yellow - 217, 78, 3

clear all;

img = imread('yellow-roses.png');

[row, col, x] = size(img);
mask = zeros(row, col);
mask(find(img(:,:,1) < 255 & img(:,:,1) > 170 & img(:,:,2) < 255 & img(:,:,2) > 50 & img(:,:,3) < 140)) = 1;
mask = imdilate(mask, strel('diamond', 17));
mask = imerode(mask, strel('diamond', 15));
mask = imerode(mask, strel('disk', 5));



length(find(mask == 1))
figure(2);
imshow(mask);


img2 = double(img) .* repmat(mask, [1,1,3]);
img2 = uint8(img2);
figure(3);
imshow(img2);
