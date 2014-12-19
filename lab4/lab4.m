im = imread('shapes.png');

[L, num] = bwlabel(im);
imtool(label2rgb(L));

[row, col] = find(L == 1);
meanX = mean(col);
meanY = mean(row);
coxx = (col - meanX) * (col - meanX)
    