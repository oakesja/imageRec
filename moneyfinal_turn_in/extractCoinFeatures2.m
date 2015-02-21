function [ features ] = extractCoinFeatures2( img, binSize )
% extracts histogram features with a given bin size
[height, width, bands] = size(img);
if bands ~= 1
    img = rgb2gray(img);
end
[Gmag, Gdir] = imgradient(img);
distance = zeros(1, height*width);
index = 1;
center = height / 2;
for y=1:height
    for x=1:width
        if Gdir(y,x) ~= 0 && (x - center)^2 + (y-center)^2 < .9 * center^2
            d = sqrt((x -center)^2 +(y-center)^2)/center;
            distance(index) = d;
            index = index + 1;
        end
    end
end
distance(distance == 0) = [];
features = hist(distance,binSize);
%features = abs(fft(features));
