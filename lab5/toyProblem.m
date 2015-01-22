% toyProblem.m
% Written by Matthew Boutell, 2006.
% Feel free to distribute at will.

clear all;

% We fix the seeds so the data sets are reproducible
seedTrain = 137;
seedTest = 138;
% This tougher data set is commented out.
%[xTrain, yTrain] = GenerateGaussianDataSet(seedTrain);
%[xTest, yTest] = GenerateGaussianDataSet(seedTest);

% This one isn't too bad at all
[xTrain, yTrain] = GenerateClusteredDataSet(seedTrain);
[xTest, yTest] = GenerateClusteredDataSet(seedTest);


net = svm(size(xTrain, 2), 'rbf', [2], 25);
net = svmtrain(net, xTrain, yTrain);


% Add your code here.
% KNOWN ISSUE: the linear decision boundary doesn't work 
% for this data set at all. Don't know why...


% Run this on a trained network to see the resulting boundary 
% (as in the demo)
plotboundary(net, [0,20], [0,20]);

[detectedClasses, distances] = svmfwd(net, xTest);

actPos = length(find(yTest == 1));
actNeg = length(find(yTest == -1));
wrongPos = 0;
wrongNeg = 0;

for i = 1:length(yTest)
    fprintf('Point %d, True class: %d, detected class: %d, distance: %0.2f\n', i, yTest(i), detectedClasses(i), distances(i))
    if (yTest(i) == 1 && detectedClasses(i)==-1)
        wrongPos = wrongPos + 1;
    elseif (yTest(i) == -1 && detectedClasses(i)==1)
        wrongNeg = wrongNeg + 1;
    end
end

tp = actPos-wrongPos
wrongPos
tn = actNeg-wrongNeg

wrongNeg

tpr = tp/actPos
fpr = wrongNeg/actNeg





