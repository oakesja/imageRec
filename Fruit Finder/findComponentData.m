function [ centroids, sizes] = findComponentData( mask )
%FINDCOMPONENTDATA Summary of this function goes here
%   Detailed explanation goes here
[L, num] = bwlabel(mask, 4);
centroids = [];
sizes = [];
for i=1:num
    [c, s] = findCenteroidAndSize(L, i);
    centroids = [centroids; c];
    sizes = [sizes; s];
end
end

