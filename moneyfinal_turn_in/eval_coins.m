function [cs] = eval_coins()
% used to find the accuracies of classifiers

histNet = {};
net = {};
bestNet = {};
load('cnn28x28nopenny7578.mat');
load('histNetNoPenny7784.mat');
load('edgeNetnoP6108.mat')

addpath('matlab');
vl_setupnn();


testDir = {'/coinsTest2/dimes', ...
         '/coinsTest2/nickels', ...
         '/coinsTest2/quarters'} ;
%{
testDir = {'/coinsTraining/dimes', ...
         '/coinsTraining/nickels', ...
         '/coinsTraining/quarters'} ;
%}    
x2 = {};
y2 = [];
index = 1;
for j=1:size(testDir, 2);
    path = [fullfile('pictures'), char(testDir(j))];
    fileList = dir(path);
    for i = 3:size(fileList)
        img = imread([path  '/'  fileList(i).name]);
        x2{1, index} = img;
        y2 = [y2, j];
        index = index + 1;     
    end
end

correct = 0;
total = size(y2,2);
cs = [];
for i=1:total
    img = x2{1,i};
    [cl1, scores1] = classifyWithCNN(img);
    [cl2, scores2] = classifyWithHist(img);
    [cl3, scores3] = classifyWithEdge(img);
    if cl1 == cl2
        c = cl1;
    elseif cl2 == cl3
        c = cl2;
    elseif scores1(cl1) > .999
        c = cl1;
    else
        c = cl2;
    end
    if c == y2(i)
        correct = correct + 1;
    else
        cs = [cs; cl1 scores1(cl1) cl2 scores2(cl2) cl3 scores1(cl3) c y2(i)];
    end
end
cs
correct/total

function [class, scores] = classifyWithCNN(img)
    net.layers{end}.type = 'softmax';
    ratio = net.imageSize / size(img, 1);
    img = imresize(img, ratio, 'bilinear');
    if(size(img, 3) == 3)
        img = rgb2gray(img);
    end
    img = single(img);
    res = vl_simplenn(net, img) ;
    scores = squeeze(gather(res(end).x));
    [confidence, class] = max(scores);
end

function [class, score] = classifyWithHist(img)
    f = extractCoinFeatures2(img, 140);
    score = histNet(transpose(f));
    class = vec2ind(score);
end

function [class, score] = classifyWithEdge(img)
    f = extractCoinFeatures(img);
    score = bestNet(transpose(f));
    class = vec2ind(score);
end

end