clear all
mf = imread('fruit/mixed_fruit3.tiff');

[r, c, a] = size(mf);

mask = zeros(r,c);
maskO = zeros(r,c);
maskB = zeros(r,c);
maskA = zeros(r,c);
mf1 = rgb2hsv(mf);

% hsv try 4 reduced saturation so include more for oranges which meant had
% to increase range to 20 to not include reds from apples 
% played with erosion and dilation to seperate bananas from parts of
% oranges
% took small bananas and made them oranges
maskO(find(mf1(:,:,1)<40/360 & mf1(:,:,1)>20/360 & mf1(:,:,2)>.57 & mf1(:,:,3)>.3))=1;
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

maskB = imerode(maskB, strel('square', 6));
maskB = imdilate(maskB, strel('square', 7));
maskB = imdilate(maskB, strel('disk', 4));

[L, num] = bwlabel(maskB, 4);
bananas = zeros(1, num);

for j = 1:num
    bananas(j) = length(find(L==j));
end

orangeLabels = find( bananas < mean(bananas) * .75 == 1);
for j = 1:length(orangeLabels)
    temp = find(L == orangeLabels(j));
    maskB(temp) = 0;
    maskO(temp) = 1;
end

maskO = imerode(maskO, strel('square', 4));
maskO = imdilate(maskO, strel('disk', 6));

% size, centroid
[cApples, sApples] = findComponentData(maskA);
labelsA = cellstr( num2str([1:length(sApples)]'));
[cBan, sBan] = findComponentData(maskB);
labelsB = cellstr( num2str([1:length(sBan)]'));
[cOrange, sOrange] = findComponentData(maskO);
labelsO = cellstr( num2str([1:length(sOrange)]'));



figure(1);
imshow(mf)

im2 = double(mf);
im2(:,:,1) = maskA * 255;
im2(:,:,2) = maskB * 255;
im2(:,:,3) = maskO * 255;
figure(5);
imshow(uint8(im2));
hold on;
plot(cApples(:,1),cApples(:, 2),'bx');
text(cApples(:,1),cApples(:, 2), labelsA, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right');
plot(cBan(:,1),cBan(:, 2),'bx');
text(cBan(:,1),cBan(:, 2), labelsB, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right');
plot(cOrange(:,1),cOrange(:, 2),'mx');
text(cOrange(:,1),cOrange(:, 2), labelsO, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right');



