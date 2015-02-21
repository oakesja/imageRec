function [classifiedImg, resizedImage] = classify_picture(img)
% given an image finds and classifies bils and coins in it

addpath('bills');

[height, width] = size(img);
ratio = 250 / min(width, height);
img = imresize(img, ratio, 'bilinear');
resizedImage = img;
img_gray = rgb2gray(img);

% hough transform to find circles
[circles, all] = circleFinder(img_gray);

%{
im2 = img;
for i=1:size(all, 1)
    x = all(i, 1);
    y = all(i, 2);
    r = all(i, 3);
    im2 = insertShape(im2, 'circle', [x,y,r], 'lineWidth', 2);
end
imtool(im2);
%}

%extract circles from the images
coins = extractCircles(circles, img);
for i=1:size(coins, 2)
    coin = coins{1, i};
    %figure(i);
    %imshow(coin);
end

%classify coins
classes = classifyCoins(coins);

[maxes, temp] = size(circles);
classifiedImg = img;
for i=1:maxes
    x = circles(i, 1);
    y = circles(i, 2);
    r = circles(i, 3);
    if classes(i) == 1 %dime
       color = [0, 0, 255];
    elseif classes(i) == 2 %nickel
       color = [255, 0, 0];
    elseif classes(i) == 4 %penny
        color = [255, 102, 0];
    else 
        color = [0, 255, 0]; %quarter
    end
    if classes(i) > 0
        classifiedImg = insertShape(classifiedImg, 'circle', [x,y,r], 'lineWidth', 2, 'color', color);
    end
end

% bills
possibleBills = getRectangles(img);
%obtain binary image of connected components found to be bills
for i = 1:double(max(possibleBills(:)))
    extractedFeatures = extractBillFeatures(img, possibleBills, i);
    % run through the net and get class returned
    classReturned = classifyBills(extractedFeatures);
    rectangleArea = (possibleBills == i);
    rCorners = findCorners2(rectangleArea);
    formattedCorners = [rCorners(1, :), rCorners(2, :), rCorners(3, :), rCorners(4, :)];
    if classReturned == 1
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'yellow', 'LineWidth', 2);
    elseif classReturned == 2
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'blue', 'LineWidth', 2);
    elseif classReturned == 3
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'green', 'LineWidth', 2);
    elseif classReturned == 4
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'red', 'LineWidth', 2);
    elseif classReturned == 5
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'cyan', 'LineWidth', 2);
    elseif classReturned == 6
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'magenta', 'LineWidth', 2);
    elseif classReturned == 7
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'black', 'LineWidth', 2);
    elseif classReturned == 8
        classifiedImg = insertShape(classifiedImg, 'Polygon', formattedCorners, 'Color', 'white', 'LineWidth', 2);
    end
end

end
