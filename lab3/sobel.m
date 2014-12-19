function [ horzEdges, vertEdges, allEdges, gradient, direction, strongDirection ] = sobel( grayImg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
grayImg = double(grayImg);

horzFilter = [-1 0 1; -2 0 2; -1 0 1]/8;
horzEdges = filter2(horzFilter, grayImg, 'same');
vertFilter = [1 2 1; 0 0 0 ; -1 -2 -1];
vertEdges = filter2(vertFilter, grayImg, 'same');
allEdges = horzEdges + vertEdges;
gradient = sqrt((horzEdges .* horzEdges) + (vertEdges .* vertEdges));
direction = atan2(vertEdges, horzEdges);
strongDirection = direction;

threshold = max(max(gradient))/8;
strongDirection(find(gradient < threshold)) = -pi;
end

