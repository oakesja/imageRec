function [ classNum ] = classifyWithNets( img )
%CLASSIFYWITHNETS 
%   Classifier for dimes, nickels, and quarters that is built
%   off of three other classifiers
histNet = {};
net = {};
bestNet = {};
load('cnn28x28nopenny7578.mat');
load('histNetNoPenny7784.mat');
load('edgeNetnoP6108.mat')

addpath('matlab');
vl_setupnn();

[cl1, scores1] = classifyWithCNN(img);
[cl2, scores2] = classifyWithHist(img);
[cl3, scores3] = classifyWithEdge(img);
con = max([scores1; scores2; scores3]);
if con < .80
    classNum = -1;
elseif cl1 == cl2
    classNum = cl1;
elseif cl2 == cl3
    classNum = cl2;
elseif scores1(cl1) > .999
    classNum = cl1;
else
    classNum = cl2;
end


function [class, scores] = classifyWithCNN(img)
    net.layers{end}.type = 'softmax';
    ratio = net.imageSize / size(img, 1);
    img = imresize(img, ratio, 'bilinear');
    if(size(img,3) == 3)
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

