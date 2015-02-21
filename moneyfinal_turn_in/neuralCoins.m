% used to train nueral nets

clear all;
load('featuresEdgeTest.mat');
load('featuresEdgeTrain.mat');

c = F(:,1601);
classes = zeros(4, length(c));
for i=1:length(c)
    if c(i) == 1
        classes(:,i) = [1;0;0;0];
    elseif c(i) == 2
        classes(:,i) = [0;1;0;0];
    else c(i) == 3
        classes(:,i) = [0;0;1;0];
    end
end

input = F(:, 1:1600)';
 
dimesTest = Ftest(1:sizes(1), :);
pos = sizes(1) + 1;
nickelsTest = Ftest(pos:pos + sizes(2) -1 ,:);
pos = pos + sizes(2);
quartersTest = Ftest(pos:pos + sizes(3) -1 ,:);

numLayers = 1;
numLayersDif = 1;
numRuns = 3;

bestAcc = 0;

allAccs = [];

while numLayers < 20;
    %accuracys = [];
    for i=1:numRuns
        net = patternnet(numLayers);
        [net,tr] = train(net, input , classes);
        
        right = 0;
        wrong = 0;
        
        detected = net(transpose(dimesTest));
        testIndices = vec2ind(detected);
        right = right + length(find(testIndices == 1));
        wrong = wrong + length(find(testIndices ~= 1));
              
        detected = net(transpose(nickelsTest));
        testIndices = vec2ind(detected); 
        right = right + length(find(testIndices == 2));
        wrong = wrong + length(find(testIndices ~= 2));
        
        detected = net(transpose(quartersTest));
        testIndices = vec2ind(detected);
        right = right + length(find(testIndices == 3));
        wrong = wrong + length(find(testIndices ~= 3));
        
        accuracy = right / (right + wrong)
        allAccs = [allAccs; accuracy numLayers;]
       % accuracys = [accuracys accuracy];
        if accuracy > bestAcc
            bestAcc = accuracy
            bestNet = net;
        end
    end
    numLayers = numLayers + numLayersDif
end

figure;
hold on;
scatter(allAccs(:,2), allAccs(:,1))
title('Neural Net Edge Mask Nickels', 'fontSize', 18);
xlabel('Number of hidden layers');
ylabel('Accuracy');
