clear all;


path = 'pictures/demo';
fileList = dir(path);
for i = 3:size(fileList)
    t = [path  '/'  fileList(i).name]
    img = imread([path  '/'  fileList(i).name]);
    [cimg, rimg] = classify_picture(img);
    figure(i);
    hold on;
    imshowpair(rimg, cimg, 'montage');
    title(t);
    drawnow;
    hold off;
end
