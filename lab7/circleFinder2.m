clear all
img = imread('c3.tiff');
img = imresize(img, 0.50, 'bilinear');

[Gmag, Gdir] = imgradient(img);

[row, col] = find(Gdir~=0);
[height, width] = size(img);
maxRad = min(width, height)/2;
votes = zeros(width, height, maxRad);
radPerDegree = pi/180;
deltaTheta = 10;

% finds the votes
for i=1:length(row)
    r = row(i);
    c = col(i);
    dir = -round(Gdir(r, c));
    first = dir - deltaTheta;
    second = dir + deltaTheta;
    for ang=min(first,second): max(first,second)
        for rad=10:maxRad
            x = round(rad*cos(ang*radPerDegree))+ c;
            y = round(rad*sin(ang*radPerDegree))+ r;
            if x > 0 && y > 0 && x < width && y < height
                votes(x, y, rad)= votes(x, y, rad)+1;
            end
        end
    end
end

v = votes(:);
v(v==0) = [];
meanVotes = mean(v);
maxVotes = max(v);

localMaxes = zeros(width*height*maxRad, 4);
index = 1;
threshold = ((maxVotes - meanVotes) / 2) + meanVotes;

% finds the local maxes
for x=1:width
    for y=1:height
        for r=1:maxRad
            neighborsMax = maxNeighbor(votes, x, y, r);
            if neighborsMax < votes(x,y,r) && votes(x,y,r) > threshold
                localMaxes(index, 1) =  x;
                localMaxes(index, 2) =  y;
                localMaxes(index, 3) =  r;
                localMaxes(index, 4) =  votes(x,y,r);
                index = index + 1;
            end
        end
    end
end

localMaxes(all(localMaxes==0,2),:)=[];
[maxes, temp] = size(localMaxes);
allCircles = img;

for i=1:maxes
    x = localMaxes(i, 1);
    y = localMaxes(i, 2);
    r = localMaxes(i, 3);
    allCircles = insertShape(allCircles, 'circle', [x,y,r], 'lineWidth', 1);
end

figure(1);
imshow(allCircles);


newMaxes = zeros(maxes, temp);
newMaxesIndex = 1;

threshold = 30;

% removes similar local maxes
for i=1:maxes
    x1 = localMaxes(i,1);
    y1 = localMaxes(i,2);
    z1 = localMaxes(i,3);
    if z1 ~= 0
        xs = zeros(1, maxes-i);
        ys = zeros(1, maxes-i);
        zs = zeros(1, maxes-i);
        xs(1) = x1;
        ys(1) = y1;
        zs(1) = z1;
        index = 2;
        for j=i:maxes
            x2 = localMaxes(j,1);
            y2 = localMaxes(j,2);
            z2 = localMaxes(j,3);
            dist = sqrt((x1 -x2)^2 + (y1-y2)^2 + (z1-z2)^2);
            if dist < threshold
                xs(index) = x2;
                ys(index) = y2;
                zs(index) = z2;
                index = index + 1;
                localMaxes(j, :) = 0;
            end
        end
        xs(xs==0) = [];
        ys(ys==0) = [];
        zs(zs==0) = [];
        newMaxes(newMaxesIndex, 1) = mean(xs);
        newMaxes(newMaxesIndex, 2) = mean(ys);
        newMaxes(newMaxesIndex, 3) = max(zs);
        newMaxesIndex = newMaxesIndex + 1;
    end
end

newMaxes(all(newMaxes==0,2),:)=[];
[maxes, temp] = size(newMaxes);

betterCircles = img;
for i=1:maxes
    x = newMaxes(i, 1);
    y = newMaxes(i, 2);
    r = newMaxes(i, 3);
    betterCircles = insertShape(betterCircles, 'circle', [x,y,r], 'lineWidth', 2);
end

figure(2);
imshow(betterCircles);

