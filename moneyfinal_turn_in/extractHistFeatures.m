function [ F, Ftest, sizes ] = extractHistFeatures( binSize )
%EXTRACTHISTFEATURES Summary of this function goes here
%   used to find the optimal bin size for histogram features
Ftest = zeros(2, binSize);
sizes = zeros(1,3);
index = 1;
paths = {'pictures/coinsTest2/nickels/','pictures/coinsTest2/quarters/'};
for j=1:size(paths,2);   
    path = char(paths(j));
    fileList = dir(path);
    s = 0;
    for i = 3:size(fileList)
        img = imread([path  '/'  fileList(i).name]);
        temp = extractCoinFeatures2(img, binSize);
        Ftest(index,:) = temp;
        index = index + 1;
        s = s + 1;
    end
    sizes(j) = s;
end

paths = {'pictures/coinsTraining/nickels/','pictures/coinsTraining/quarters/'};
F = zeros(100, binSize+1);
index = 1;
for j=1:size(paths, 2);
    path = char(paths(j));
    fileList = dir(path);
    for i = 5:size(fileList)
        ang = 0;
        im = imread([path  '/'  fileList(i).name]);
        while ang < 360
           im2 = imrotate(im, ang, 'nearest', 'crop');
            temp = extractCoinFeatures2(im2, binSize);
            F(index,:) = [temp j];
            index = index + 1;
            ang = ang + 10;
        end
    end
end

end

