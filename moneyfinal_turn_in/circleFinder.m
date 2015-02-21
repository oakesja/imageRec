function [ circles, allCircles] = circleFinder( gray_img )
%CIRCLEFINDER Finds all circles of arbritrary length in a given gray scale image
%   Returns circles which is a matrix containing the centers and radius for
%   all circles
%   circles = [x1 y1 r1; x2 y2 r2; .... ; xn yn rn]

[Gmag, Gdir] = imgradient(gray_img);
[row, col] = find(Gdir~=0);
[height, width] = size(gray_img);
maxRad = round(min(width, height)/2);
votes = zeros(width, height, maxRad);
radPerDegree = pi/180;
deltaTheta = 3;

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

% finds the local maxes
v = votes(:);
v(v==0) = [];
meanVotes = mean(v);
maxVotes = max(v);

localMaxes = zeros(width*height*maxRad, 4);
threshold = ((maxVotes - meanVotes) / 2) + meanVotes;
localMaxIndexes = imregionalmax(votes, 26);
votes = votes .* localMaxIndexes;
index = 1;
for x=1:width
    for y=1:height
        for r=1:maxRad
            if votes(x,y,r) > threshold
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
allCircles = localMaxes;
localMaxes = flip(sortrows(localMaxes, 3), 1);
[maxes, temp] = size(localMaxes);

circles = zeros(maxes, 3);
newMaxesIndex = 1;

threshold = min(height, width)/10;

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
            dist = sqrt((x1 -x2)^2 + (y1-y2)^2);
            if dist < threshold
                xs(index) = x2;
                ys(index) = y2;
                zs(index) = z2;
                index = index + 1;
                localMaxes(j, :) = 0;
            end
            % one of the circle is inside the other but should not count
            if dist + z2 < z1
                localMaxes(j, :) = 0;
            end
        end
        xs(xs==0) = [];
        ys(ys==0) = [];
        zs(zs==0) = [];
        circles(newMaxesIndex, 1) = round(mean(xs));
        circles(newMaxesIndex, 2) = round(mean(ys));
        circles(newMaxesIndex, 3) = max(zs);
        newMaxesIndex = newMaxesIndex + 1;
    end
end
circles(all(circles==0,2),:)=[];
end

