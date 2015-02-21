function [ maxNeighbor ] = maxNeighbor( votes, x, y, r )
%MAXNEIGHBOR Summary of this function goes here
%   Detailed explanation goes here
[width, height, depth] = size(votes);

maxNeighbor = 0;

if x==1
   smallX = 0;
else
    smallX = -1;
end

if y==1
   smallY = 0;
else
    smallY = -1;
end

if r==1
   smallR = 0;
else
    smallR = -1;
end

if x==width
   largeX = 0;
else
   largeX = 1;
end

if y==height
   largeY = 0;
else
   largeY = 1;
end

if r==depth
   largeR = 0;
else
   largeR = 1;
end

for i=smallX:largeX
    for j=smallY:largeY
        for z=smallR:largeR
            if (i~=0 && j~=0 && z~=0)
                maxNeighbor = max(maxNeighbor, votes(i+x,j+y,z+r));
            end
        end
    end
end
end

