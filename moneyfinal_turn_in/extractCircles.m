function [ imgs ] = extractCircles( circles, img )
%EXTRACTCIRCLES 
%   Given a list of circles with center and radius information and an image
%   extracts the circles out and returns them

[height, width, bands] = size(img);
imgs = {};
for i=1:size(circles,1)
    x = circles(i, 1);
    y = circles(i, 2);
    r = circles(i, 3);
    [xx,yy] = ndgrid((1:height)-y,(1:width)-x);
    mask = uint8((xx.^2 + yy.^2)<r^2);
    img2 = img.* repmat(mask, [1,1,3]);
    startY = y - r;
    if startY < 1
        startY = 1;
    end
    endY = y + r;
    if endY > height
        endY = height;
    end
    startX = x - r;
    if startX < 1
        startX = 1;
    end
    endX = x + r;
    if endX > width
        endX = width;
    end
    coin = img2(startY:endY, startX:endX, :);
    coin = validateBounds(coin);
    imgs{1,i} = coin;
end

function [im] = validateBounds(img)
    [h, w, b] = size(img);
    if h < w
        s = floor((w-h)/2);
        im = padarray(img, [s, 0], 'both');
        [h, w, b] = size(im);
        if h ~= w
            row = zeros(1, w, b);
            im = [im; row];
        end
    elseif w < h
        s = floor((h-w)/2);
        im = padarray(img, [0, s], 'both');
        [h, w, b] = size(im);
        if h ~= w
            col = zeros(h, 1, b);
            size(col)
            im = [im col];
        end
    else
        im = img;
    end
end
end

