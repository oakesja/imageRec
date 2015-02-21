function isPenny = circleFinder( img )
% classifies a coin as a penny or not based on RGB color

red = img(:,:,1);
blue = img(:,:,2);
green = img(:,:,3);

rMean = median(red(:));
gMean = median(blue(:));
bMean = median(green(:));

isPenny = false;

if rMean>gMean*1.2 & rMean>bMean*1.3  & rMean > 45
        isPenny = true;
end