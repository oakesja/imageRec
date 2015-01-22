im = imread('sunsetDetectorImages/TrainSunset/101.jpg');
figure;
hold on;
imshow(im);
x = []
y = []
xDif = 600/7;
yDif = 480/7;
for i =2:7
    line([0, 600],[(i-1)*yDif, (i-1)*yDif], 'Color','b','LineWidth',2)
    line([(i-1)*xDif, (i-1)*xDif],[0, 480], 'Color','b','LineWidth',2)
end
hold off