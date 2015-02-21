function [ features ] = extractBillFeatures( img, cc, index )
%EXTRACTBILLFEATURES Summary of this function goes here
%   Detailed explanation goes here
% reduce size
mask = (cc == index);
% find centroid of rectangle
measurements = regionprops(mask, 'Centroid');

% Put a cross at the centroid.
xCentroid = measurements.Centroid(1);
yCentroid = measurements.Centroid(2);

% find corners of the region
t = findCorners2(mask);
[xCorners, yCorners] = fixerUpper(t(:,1)', t(:,2)');

%find the long edge of the rectangle
edge1 = [xCorners(1), yCorners(1); xCorners(2), yCorners(2)];
edge2 = [xCorners(1), yCorners(1); xCorners(3), yCorners(3)];

if(pdist(edge1,'euclidean')>pdist(edge2,'euclidean'))
    longEdge = edge1;
else
    longEdge = edge2;
end
% calculate angle between edge and x-axis
deltaY = (longEdge(1, 2) - longEdge(2, 2));
deltaX = (longEdge(1, 1) - longEdge(2, 1));
angleInDegrees = 180 - (atan2(-deltaY, deltaX) * 180 / pi);

%rotate image
mask = imrotate(mask,angleInDegrees,'bilinear');
img = imrotate(img, angleInDegrees,'bilinear');

% find new centroid of rectangle
measurements = regionprops(mask, 'Centroid');

% Put a cross at the centroid.
xCentroid = measurements.Centroid(1);
yCentroid = measurements.Centroid(2);

%find new corners which represent bounding box
[newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
dx = newXCorners(2) - newXCorners(1);
dy = newYCorners(3) - newYCorners(1);

%grab corner with denomination
if(newYCorners(1) == 0)
    newYCorners(1) = 1;
end
if(newXCorners(1) == 0)
    newXCorners(1) = 1;
end
mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
features = imresize(I, [28,28]);

end

