function [I,labels,I_test,labels_test] = readImages( input_args )
%READIMAGES Summary of this function goes here
%   Detailed explanation goes here
I = {};
labels = [];
paths = {'pictures/coinsTraining/dimes/','pictures/coinsTraining/nickels/','pictures/coinsTraining/pennies/','pictures/coinsTraining/quarters/'};
index = 1;
for j=1:size(paths, 2);
    j
    path = char(paths(j));
    fileList = dir(path);
    for i = 3:size(fileList)
        img = imread([path  '/'  fileList(i).name]);
        [height, width, bands] = size(img);
        if bands == 3
            img = rgb2gray(img);
        end
        ratio = 32 / height;
        img = imresize(img, ratio, 'bilinear');
        if(size(img,1) == 32)
            I{1, index} = double(img);
            labels = [labels;  j-1];
            index = index + 1;
        end
        i
    end
end

I_test = {};
labels_test = [];
index = 1;
paths = {'pictures/coinsTest2/dimes/','pictures/coinsTest2/nickels/','pictures/coinsTest2/pennies/','pictures/coinsTest2/quarters/'};
for j=1:size(paths, 2);
    path = char(paths(j));
    fileList = dir(path);
    for i = 3:size(fileList)
        img = imread([path  '/'  fileList(i).name]);
        [height, width] = size(img);
        ratio = 32 / height;
        img = imresize(img, ratio, 'bilinear');
        if(size(img,1) == 32)
            I_test{1, index} = double(img);
            labels_test = [labels_test; j-1];
            index = index + 1;
        end
        i
    end
end

end
