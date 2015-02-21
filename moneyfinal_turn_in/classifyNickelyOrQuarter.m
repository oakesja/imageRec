function [ classNum ] = classifyNickelyOrQuarter( img )
%CLASSIFYNICKELYORQUARTER 
%   Given the assumption that it is either a nickel or a quarter
%   classifies a given coin image as such
load('nickQuartHistNet9453.mat');
f = extractCoinFeatures2(img, 140);
score = bestNet(transpose(f));
class = vec2ind(score);
classNum = class + 1; %offset for dimes
end

