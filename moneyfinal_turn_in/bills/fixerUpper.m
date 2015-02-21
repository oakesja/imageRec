function [xCorners, yCorners] = fixerUpper(xCorners, yCorners)

greatest = 0;
index=0;
for i=2:4
    distBetween = (xCorners(i) - xCorners(1))^2 + (yCorners(i) - yCorners(1))^2;
    if distBetween>greatest
        greatest = distBetween;
        index = i;
    end
end

if index<4
    xCorners(index) = xCorners(4);
    yCorners(index) = yCorners(4);
end