clear all;

img = imread('yellow-roses.png');
figure(1)
imshow(img);

% half bands
halved = img/2;
figure(2);
imshow(halved);

% double bands
doubled = img * 2;
figure(3);
imshow(doubled);

% switch blue and green bands
blue = img(:,:,3);
green = img(:,:,2);
switched = img;
switched(:,:,2) = blue;
switched(:,:,3) = green;
figure(4);
imshow(switched);

% double blue values
doubleBlue = img;
doubleBlue(:,:,3) = blue * 2;
figure(5);
imshow(doubleBlue);

% double blue values under 64
[row, col] = size(blue);
mask = ones(row, col);
mask(blue < 64) = 2;
newBlue = double(blue) .* mask;

doubleSomeBlue = img;
doubleSomeBlue(:,:,3) = uint8(newBlue);
figure(6);
imshow(doubleSomeBlue);

