function [ class ] = classifyBills( features )
% Takes binary image of connected components as input and returns binary
% image of connected components found to be bills
load('bills/cnn_netAll75.mat');

cnn_net.layers{end}.type = 'softmax';
img = single(features);
res = vl_simplenn(cnn_net, img) ;
scores = squeeze(gather(res(end).x));
[confidence, class] = max(scores)
if confidence < .8
    class = -1;
end
end
