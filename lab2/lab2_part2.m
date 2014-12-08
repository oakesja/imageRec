clear all;

img = imread('yellow-roses.png');
figure(1)
imshow(img);

hsvImg = rgb2hsv(img);
h = hsvImg(:,:,1);
figure(2);
imshow(h);
s = hsvImg(:,:,2);
figure(3);
imshow(s);
v = hsvImg(:,:,3);
figure(4);
imshow(v);

min(min(h))
max(max(h))
min(min(s))
max(max(s))
min(min(v))
max(max(v))

