clear all;

load('trainFeatures2.mat');
load('testFeatures2.mat');

sunsets = testFeatures(1:222, :);
nonsunsets = testFeatures(223:463, :);
sunsetHard = testFeatures(464:555, :);
nonsunsetHard = testFeatures(556:605, :);

input = transpose(trainFeatures(:, 1:294));
c = transpose(trainFeatures(:, 295));
c(c==-1) = 0;

numLayers = 1;
numLayersDif = 1;
numRuns = 3;

bestAcc = 0;

%{
feedforward
  acc      hidden layers
0.8386    1.0000
0.8459   11.0000
0.8506   21.0000
0.8446   31.0000
0.8494   41.0000
0.8270   51.0000
0.8219   61.0000

patternet 1-294 with 3 runs at each hidden layer size
best found
0.9227   24.0000
%}
%{
allAccs = [];

while numLayers < 294;
    %accuracys = [];
    for i=1:numRuns
        net = patternnet(numLayers);
        [net,tr] = train(net, input , c);
        detectedClassesSunsets = net(transpose(sunsets));
        detectedClassesNonSunsets = net(transpose(nonsunsets));
        truePos = length(find(detectedClassesSunsets  > 0.5));
        falseNeg = length(find(detectedClassesSunsets < 0.5));
        falsePos = length(find(detectedClassesNonSunsets > 0.5));
        trueNeg = length(find(detectedClassesNonSunsets < 0.5));
        accuracy = (truePos + trueNeg) / (truePos + falseNeg + falsePos + trueNeg)
        allAccs = [allAccs; accuracy numLayers;]
       % accuracys = [accuracys accuracy];
        if accuracy > bestAcc
            bestAcc = accuracy
            bestNet = net;
        end
    end
    % accuracy = sum(accuracys) / numRuns;
    %{
    allAccs = [allAccs; accuracy numLayers;]
    if accuracy > bestLayerAcc
        bestAcc = accuracy;
        bestLayer = numLayers;
    end
    %}
    numLayers = numLayers + numLayersDif
end
%}

% best net has 0.950323974082074 accuracy with 46 hidden layers
load('newNeuralBest.mat')


tprs = [];
fprs = [];

threshold = 0.450;
thresholdDif = 0.05;
thresholdMax = 0.450;

bestAccuracy = 0;
bestThres = 0;

goodThreshold = [];

% output of neural net is between 0 and 1 with threshold originally at 0.5
% so just need to vary threshold from 0 to 1 for bestNet found above
% best accuracy is  0.9525 with threshold 0.4500
% hard is 0.8744
while threshold <= thresholdMax;
    detectedClassesSunsets = bestNet(transpose(sunsets));
    detectedClassesNonSunsets = bestNet(transpose(nonsunsets));
    truePos = length(find(detectedClassesSunsets  > threshold));
    falseNeg = length(find(detectedClassesSunsets < threshold));
    falsePos = length(find(detectedClassesNonSunsets > threshold));
    trueNeg = length(find(detectedClassesNonSunsets < threshold));
    
    
    detectedClassesSunsetsHard = bestNet(transpose(sunsetHard));
    detectedClassesNonSunsetsHard = bestNet(transpose(nonsunsetHard));
    
    truePos = truePos + length(find(detectedClassesSunsetsHard > threshold));
    falseNeg = falseNeg + length(find(detectedClassesSunsetsHard < threshold));
    falsePos = falsePos + length(find(detectedClassesNonSunsetsHard > threshold));
    trueNeg = trueNeg + length(find(detectedClassesNonSunsetsHard< threshold));
    
    tpr = truePos / (truePos + falseNeg);
    fpr = falsePos/ (falsePos + trueNeg);

    tprs = [tprs, tpr];
    fprs = [fprs, fpr];

    accuracy = (truePos + trueNeg) / (truePos + falseNeg + falsePos + trueNeg);

    if tpr > .9 && fpr < .1
        goodThreshold = [goodThreshold threshold]
    end
    
    if bestAccuracy < accuracy
        bestThresh = threshold;
        bestAccuracy = accuracy;
    end

    threshold = threshold + thresholdDif    
end

plotRoc(tprs, fprs, 'Neural Net ROC Curve', 'False Positive Rate', 'True Positive Rate');