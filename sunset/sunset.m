clear all;

%{
trainFeatures = extractTrainFeatures();
testFeatures = extractTestFeatures();

save('trainFeatures2.mat', 'trainFeatures');
save('testFeatures2.mat', 'testFeatures');

testFeatures(:, 295) = 0;

features = [trainFeatures; testFeatures];
features = normalizeFeatures01(features);

trainFeatures = features(1:499, :)
testFeatures = features(500:1104, 1:294)

save('trainFeatures2.mat', 'trainFeatures');
save('testFeatures2.mat', 'testFeatures');
%}

load('trainFeatures2.mat');
load('testFeatures2.mat');

addpath('svm')

sunsets = testFeatures(1:222, :);
nonsunsets = testFeatures(223:463, :);
sunsetHard = testFeatures(464:555, :);
nonsunsetHard = testFeatures(556:605, :);

%{
sigDif = .001;
sig = sigDif;
bestAccuracy = 0; 
bestSig = 0;
accs = [];
sigs = [];
while sig < .05
    net = svm(294, 'rbf', [sig], 1);
    net = svmtrain(net, trainFeatures(:, 1:294), trainFeatures(:, 295));

    [detectedClassesSunsets, distancesSunsets] = svmfwd(net, sunsets);
    [detectedClassesNonSunsets, distancesNonSunsets] = svmfwd(net, nonsunsets);

    truePos = length(find(detectedClassesSunsets == 1));
    falseNeg = length(find(detectedClassesSunsets == -1));
    falsePos = length(find(detectedClassesNonSunsets == 1));
    trueNeg = length(find(detectedClassesNonSunsets == -1));

    accuracy = (truePos + trueNeg) / (truePos + falseNeg + falsePos + trueNeg);
    
    sigs = [sigs sig];
    accs = [accs accuracy];
    untitled.jpg
    if bestAccuracy < accuracy
        bestSig = sig;
        bestAccuracy = accuracy;
    end
    sig = sig + sigDif
end

plotRoc(accs, sigs, 'SVM Sigma Parameter', 'RBF Sigma Parameter', 'Accuracy');

%}

bestSig = 0.007;
threshold = -0.0500;
thresholdDif = 0.05;
thresholdMax = -0.0500 + thresholdDif;

tprs = [];
fprs = [];

goodThreshold = [];
bestAccuracy = 0; 
goodThreshold = 0;

while threshold < thresholdMax
    
    net = svm(294, 'rbf', [bestSig], 1);
    net = svmtrain(net, trainFeatures(:, 1:294), trainFeatures(:, 295));
    
    [detectedClassesSunsets, distancesSunsets] = svmfwd(net, sunsets);
    [detectedClassesNonSunsets, distancesNonSunsets] = svmfwd(net, nonsunsets);

    detectedClassesSunsets = (distancesSunsets > threshold);
    detectedClassesNonSunsets = (distancesNonSunsets > threshold);

    truePos = length(find(detectedClassesSunsets == 1));
    falseNeg = length(find(detectedClassesSunsets == 0));
    falsePos = length(find(detectedClassesNonSunsets == 1));
    trueNeg = length(find(detectedClassesNonSunsets == 0));
    
    [detectedClassesSunsetsHard, distancesSunsetsHard] = svmfwd(net, sunsetHard);
    [detectedClassesNonSunsetsHard, distancesNonSunsetsHard] = svmfwd(net, nonsunsetHard);

    
    detectedClassesSunsetsHard = (distancesSunsetsHard > threshold);
    detectedClassesNonSunsetsHard = (distancesNonSunsetsHard > threshold);
    
    truePos = truePos + length(find(detectedClassesSunsetsHard == 1));
    falseNeg = falseNeg + length(find(detectedClassesSunsetsHard == 0));
    falsePos = falsePos + length(find(detectedClassesNonSunsetsHard == 1));
    trueNeg = trueNeg + length(find(detectedClassesNonSunsetsHard == 0));
    
    accuracy = (truePos + trueNeg) / (truePos + falseNeg + falsePos + trueNeg);
    
    tpr = truePos / (truePos + falseNeg);
    fpr = falsePos/ (falsePos + trueNeg);
    
    tprs = [tprs, tpr];
    fprs = [fprs, fpr];
    
    if tpr > .9 && fpr < .1
        goodThreshold = [goodThreshold threshold]
    end
    
    if bestAccuracy < accuracy
        bestThresh = threshold;
        bestAccuracy = accuracy;
    end
    
    threshold = threshold + thresholdDif
end

% best threshold =  -0.0500 with accuracy of 0.9590 for normal
% best threshold =  0 with accuracy of 0.8860 including hard

plotRoc(tprs, fprs, 'SVM ROC Curve', 'False Positive Rate', 'True Positive Rate');
