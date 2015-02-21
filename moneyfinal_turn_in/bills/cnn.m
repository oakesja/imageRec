%{
load('/home/joakes/imageRec/final/BILL$/data/bills-baseline/imdb.mat')

for i=1:size(images.data, 4)
    imtool(uint8(images.data(:,:,:,i)));
end
%}

testDir = {...
         '/testing/ones', ...
        '/testing/twos',... 
        '/testing/fives', ...
        '/testing/tens', ...
        '/testing/twenties'...
        '/testing/fifties'} ;
trainDir = {...
         '/training/1', ...
        '/training/2',... 
        '/training/5', ...
        '/training/10', ...
        '/training/20'...
        '/training/50'} ;
     
imageSize = 28;

F = [];
index = 1;

for j=1:size(trainDir, 2);
    path = ['pictures/', char(trainDir(j))];
    fileList = dir(path);
    for i = 3:size(fileList)
        ang = 0;
        img = imread([path  '/'  fileList(i).name]);
        [height, width, bands] = size(img);
        ratio = 300 / min(height, width);
        img = imresize(img, ratio, 'bilinear');
        while ang < 360
            im = imrotate(img, ang, 'nearest');
            cc = getRectangles(im);
            f = extractBillFeatures(im, cc, 1);
            if size(f) > 0
                imtool(f);
            end
            ang = ang + 30;
        end
    end
end
