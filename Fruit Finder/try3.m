clear all
mf = imread('fruit/mixed_fruit3.tiff');

[r, c, a] = size(mf);

mask = zeros(r,c);
maskO = zeros(r,c);
maskB = zeros(r,c);
maskA = zeros(r,c);
mf1 = rgb2hsv(mf);

% hsv try 3 better bananas decreased v and changed morphology
maskO(find(mf1(:,:,1)<40/360 & mf1(:,:,1)>0/360 & mf1(:,:,2)>.75 & mf1(:,:,3)>.5))=1;
maskB(find(mf1(:,:,1)<100/360 & mf1(:,:,1)>38/360 & mf1(:,:,2)>.57 & mf1(:,:,3)>.3))=1;
maskA(find((mf1(:,:,1)<20/360 | mf1(:,:,1)>120/360) & mf1(:,:,2)>.4))=1;

im1 = double(mf);
im1(:,:,1) = maskA * 255;
im1(:,:,2) = maskB * 255;
im1(:,:,3) = maskO * 255;
figure(4);
imshow(uint8(im1));

maskA = imerode(maskA, strel('square', 7));
maskA = imdilate(maskA, strel('disk', 10));

maskO = imerode(maskO, strel('square', 4));
maskO = imdilate(maskO, strel('disk', 6));

maskB = imerode(maskB, strel('square', 4));
maskB = imdilate(maskB, strel('square', 4));
maskB = imdilate(maskB, strel('disk', 4));

figure(1);
imshow(maskA)

figure(2);
imshow(maskB)

figure(3);
imshow(maskO)

im2 = double(mf);
im2(:,:,1) = maskA * 255;
im2(:,:,2) = maskB * 255;
im2(:,:,3) = maskO * 255;
figure(5);
imshow(uint8(im2));


