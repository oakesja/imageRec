function [ allFeatures ] = extractTestFeatures( input_args )
%EXTRACTTESTFEATURES Summary of this function goes here
%   Detailed explanation goes here
allFeatures = [];
path = 'sunsetDetectorImages/TestSunset/';
fileList = dir(path);
for i = 3:size(fileList)
    im = imread([path  '/'  fileList(i).name]);
    allFeatures = [allFeatures; extractFeatures(im)];
end

path = 'sunsetDetectorImages/TestNonsunsets/';
fileList = dir(path);
for i = 3:size(fileList)
    im = imread([path  '/'  fileList(i).name]);
    allFeatures = [allFeatures; extractFeatures(im)];
end

path = 'sunsetDetectorImages/TestDifficultSunsets/';
fileList = dir(path);
for i = 3:size(fileList)
    im = imread([path  '/'  fileList(i).name]);
    allFeatures = [allFeatures; extractFeatures(im)];
end

path = 'sunsetDetectorImages/TestDifficultNonsunsets/';
fileList = dir(path);
for i = 3:size(fileList)
    im = imread([path  '/'  fileList(i).name]);;
    allFeatures = [allFeatures; extractFeatures(im)];
end

end

