function [ centroid, numPixels ] = findCenteroidAndSize( L, num )
%FINDCENTEROIDANDSIZE Summary of this function goes here
%   Detailed explanation goes here
numPixels = length(find(L == num));
[r, c] = size(L);
xs = [];
ys = [];
for i=1:r
    for j=1:c
        if L(i, j) == num
            xs = [xs, j];
            ys = [ys, i];
        end
    end
end
centroid = [mean(xs), mean(ys)];
end

