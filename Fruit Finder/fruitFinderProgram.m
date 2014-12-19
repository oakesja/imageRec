clear all
mf = imread('fruit/.tiff');

[r, c, a] = size(mf);

mask = zeros(r,c);
maskO = zeros(r,c);
maskB = zeros(r,c);
maskA = zeros(r,c);

% rgb try 1
%mask(find(mf1(:,:,1)<235 & mf1(:,:,1)>170 & mf1(:,:,2)<150 & mf1(:,:,2)>60 & mf1(:,:,3)<65))=1;
    
mf1 = rgb2hsv(mf);

% hsv try 1 erode by 4 square dilate by 6 disk
%maskO(find(mf1(:,:,1)<40/360 & mf1(:,:,1)>0/360 & mf1(:,:,2)>.75 & mf1(:,:,3)>.5))=1;
%maskB(find(mf1(:,:,1)<100/360 & mf1(:,:,1)>43/360 & mf1(:,:,2)>.57 & mf1(:,:,3)>.5))=1;
%maskA(find((mf1(:,:,1)<20/360 | mf1(:,:,1)>120/360) & mf1(:,:,2)>.4 & mf1(:,:,3)>.1))=1;

% hsv try 2 increase erosion to 5, increase dilation to 8 to fill in more holes, and decreased v to
% include more blacks
%maskO(find(mf1(:,:,1)<40/360 & mf1(:,:,1)>0/360 & mf1(:,:,2)>.75 & mf1(:,:,3)>.5))=1;
%maskB(find(mf1(:,:,1)<100/360 & mf1(:,:,1)>43/360 & mf1(:,:,2)>.57 & mf1(:,:,3)>.5))=1;
%maskA(find((mf1(:,:,1)<20/360 | mf1(:,:,1)>120/360) & mf1(:,:,2)>.4 & mf1(:,:,3)>.05))=1;

% hsv try 3 increase orange range to 43 to include more green areas and
% incread dilation and then erod to fill in the one orange that is split
maskO(find(mf1(:,:,1)<43/360 & mf1(:,:,1)>0/360 & mf1(:,:,2)>.75 & mf1(:,:,3)>.5))=1;
maskB(find(mf1(:,:,1)<100/360 & mf1(:,:,1)>43/360 & mf1(:,:,2)>.57 & mf1(:,:,3)>.5))=1;
maskA(find((mf1(:,:,1)<20/360 | mf1(:,:,1)>120/360) & mf1(:,:,2)>.4 & mf1(:,:,3)>.05))=1;
maskO = imerode(maskO, strel('square', 4));
maskO = imdilate(maskO, strel('disk', 20));
maskO = imerode(maskO, strel('disk', 10));

maskA = imerode(maskA, strel('square', 5));
maskA = imdilate(maskA, strel('disk', 8));

%maskO = imerode(maskO, strel('square', 4));
%maskO = imdilate(maskO, strel('disk', 20));
%maskO = imerode(maskO, strel('disk', 10));

maskB = imerode(maskB, strel('square', 4));
maskB = imdilate(maskB, strel('disk', 6));

figure(1);
imshow(maskA)



figure(2);
imshow(maskB)

figure(3);
imshow(maskO)