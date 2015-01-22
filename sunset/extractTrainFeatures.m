function [ allFeatures ] = extractTrainFeatures( )
%EXTRACTTRAINFEATURES Summary of this function goes here
%   Detailed explanation goes here
allFeatures = [];
path = 'sunsetDetectorImages/TrainSunset/';
fileList = dir(path);
for i = 3:size(fileList)
    im = imread([path  '/'  fileList(i).name]);
    allFeatures = [allFeatures; extractFeatures(im), 1];
end

path = 'sunsetDetectorImages/TrainNonsunsets/';
fileList = dir(path);
for i = 3:size(fileList)
    im = imread([path  '/'  fileList(i).name]);
    allFeatures = [allFeatures; extractFeatures(im), -1];
end
end

