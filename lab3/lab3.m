clear all;
im = imread('castle.jpg');
grayImg = rgb2gray(im);

[ horzEdges, vertEdges, allEdges, gradient, direction, strongDirection ] = sobel(grayImg);

%scaling
gradient = (gradient/ max(max(gradient))) * 255;
direction = (direction + pi) * (255/(2*pi));
strongDirection = (strongDirection + pi) * (255/(2*pi));



horzEdges = uint8(horzEdges * 8);
vertEdges = uint8(vertEdges);
allEdges = uint8(allEdges);
gradient = uint8(gradient);
direction = uint8(direction);
strongDirection = uint8(strongDirection);

imtool(horzEdges);
imtool(vertEdges);
imtool(allEdges);
imtool(gradient);
imtool(direction);
imtool(strongDirection);

imwrite(horzEdges, 'castle_horz_edges.png');
imwrite(vertEdges, 'castle_vert_edges.png');
imwrite(allEdges, 'castle_all_edges.png');
imwrite(gradient, 'castle_gradient.png');
imwrite(direction, 'castle_direction.png');
imwrite(strongDirection, 'castle_strong_direction.png');

