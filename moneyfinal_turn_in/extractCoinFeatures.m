function [ features ] = extractCoinFeatures( img )
%EXTRACTFEATURE 
%  extracts 40 x 40 binary edge mask using sobel filter
[height, width, bands] = size(img);
ratio = 40 / height;
img = imresize(img, ratio, 'bilinear');
if bands ~= 1
    img = rgb2gray(img);
end
BW = edge(img,'sobel', 0);
features = BW(:)';


