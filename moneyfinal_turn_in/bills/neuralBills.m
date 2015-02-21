clear all;
testDir = {...
         '/testing/ones', ...
        '/testing/twos',... 
        '/testing/fives', ...
        '/testing/twenties'} ;
trainDir = {...
         '/training/1', ...
        '/training/2',... 
        '/training/5', ...
        '/training/20'} ;
     
imageSize = 28;

F = [];
index = 1;

for j=1:size(trainDir, 2);
    path = ['pictures/', char(trainDir(j))];
    fileList = dir(path);
    for i = 3:size(fileList)
        ang = 0;
        img = imread([path  '/'  fileList(i).name]);
        [height, width, bands] = size(img);
        ratio = 300 / min(height, width);
        img = imresize(img, ratio, 'bilinear');
        while ang < 360
            im = img;
            im = imrotate(img, ang, 'nearest');
            cc = getRectangles(im);
            f = extractBillFeatures(im, cc, 1);
            if size(f) > 0
                BW = edges(double(f));
                F(index, :) = [BW(:), j];
                index = index + 1;
            end
            ang = ang + 45;
        end
    end
end

Ftest = [];
sizes = [];
for j=1:size(testDir, 2);
    path = ['pictures/', char(testDir(j))];
    fileList = dir(path);
    s = 0;
    for i = 3:size(fileList)
        ang = 0;
        img = imread([path  '/'  fileList(i).name]);
        [height, width, bands] = size(img);
        ratio = 300 / min(height, width);
        img = imresize(img, ratio, 'bilinear');
        while ang < 360
            im = imrotate(img, ang, 'nearest');
            cc = getRectangles(im);
            f = extractBillFeatures(im, cc, 1);
            if size(f) > 0
                BW = edges(f);
                Ftest(index, :) = [BW(:), j];
                index = index + 1;
                s = s + 1;
            end
            ang = ang + 45;
        end 
    end
    sizes = [sizes, s];
end

c = F(:,784);
classes = zeros(4, length(c));
for i=1:length(c)
    if c(i) == 1
        classes(:,i) = [1;0;0;0];
    elseif c(i) == 2
        classes(:,i) = [0;1;0;0];
    elseif c(i) == 3
        classes(:,i) = [0;0;1;0];
    else c(i) == 4
        classes(:,i) = [0;0;0;1];
    end
end

input = F(:, 1:785)';
 
onesTest = Ftest(1:sizes(1), :);
pos = sizes(1) + 1;
twosTest = Ftest(pos:pos + sizes(2) -1 ,:);
pos = pos + sizes(2);
fivesTest = Ftest(pos:pos + sizes(3) -1 ,:);
pos = pos + sizes(3);
twentiesTest = Ftest(pos:pos + sizes(4) -1 ,:);

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
        
        detected = net(transpose(onesTest));
        testIndices = vec2ind(detected);
        right = right + length(find(testIndices == 1));
        wrong = wrong + length(find(testIndices ~= 1));
              
        detected = net(transpose(twosTest));
        testIndices = vec2ind(detected); 
        right = right + length(find(testIndices == 2));
        wrong = wrong + length(find(testIndices ~= 2));
        
        detected = net(transpose(fivesTest));
        testIndices = vec2ind(detected);
        right = right + length(find(testIndices == 3));
        wrong = wrong + length(find(testIndices ~= 3));
        
        detected = net(transpose(twentiesTest));
        testIndices = vec2ind(detected);
        right = right + length(find(testIndices == 4));
        wrong = wrong + length(find(testIndices ~= 4));
        
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
