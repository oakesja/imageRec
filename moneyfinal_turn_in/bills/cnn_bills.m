function [net, info] = cnn_coins(varargin)
% used 

addpath('../matlab');
vl_setupnn();

opts.dataDir = fullfile('pictures') ;
opts.expDir = fullfile('data','bills-baseline') ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.train.batchSize = 100 ;
opts.train.numEpochs = 100 ;
opts.train.continue = true ;
opts.train.useGpu = false ;
opts.train.learningRate = 0.001 ;
opts.train.expDir = opts.expDir ;
opts = vl_argparse(opts, varargin) ;

% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------

%if exist(opts.imdbPath, 'file')
%  imdb = load(opts.imdbPath) ;
%else
  [imdb, imageSize] = getMnistImdb(opts) ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
%end

% Define a network similar to LeNet
f=1/100 ;
net.imageSize = imageSize;
net.layers = {};
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(5,5,1,20, 'single'), ...
                           'biases', zeros(1, 20, 'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(5,5,20,50, 'single'),...
                           'biases', zeros(1,50,'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(4,4,50,500, 'single'),...
                           'biases', zeros(1,500,'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', f*randn(1,1,500,10, 'single'),...
                           'biases', zeros(1,10,'single'), ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'softmaxloss') ;


% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

% Take the mean out and make GPU if needed

[net, info] = cnn_train(net, imdb, @getBatch) ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(batch) ;

% --------------------------------------------------------------------
function [imdb, imageSize] = getMnistImdb(opts)
% --------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
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

if ~exist(opts.dataDir, 'dir')
  mkdir(opts.dataDir) ;
end

pics = {};
y1 = [];
index = 1;

for j=1:size(trainDir, 2);
    path = [opts.dataDir, char(trainDir(j))];
    fileList = dir(path);
    for i = 3:size(fileList)
        ang = 0;
        [path  '/'  fileList(i).name]
        img = imread([path  '/'  fileList(i).name]);
        [height, width, bands] = size(img);
        ratio = 300 / min(height, width);
        img = imresize(img, ratio, 'bilinear');
        while ang < 360
            im = img;
            im = imrotate(img, ang, 'nearest');
            cc = getRectangles(im);
            f = extractBillFeatures(im, cc, 1);
            if size(f) > 0
                pics{1, index} = f;
                y1 = [y1, j];
                index = index + 1;
            end
            ang = ang + 30;
        end
    end
end

y2 = [];
for j=1:size(testDir, 2);
    path = [opts.dataDir, char(testDir(j))];
    fileList = dir(path);
    for i = 3:size(fileList)
        ang = 0;
        [path  '/'  fileList(i).name]
        img = imread([path  '/'  fileList(i).name]);
        [height, width, bands] = size(img);
        ratio = 300 / min(height, width);
        img = imresize(img, ratio, 'bilinear');
        while ang < 360
            im = imrotate(img, ang, 'nearest');
            cc = getRectangles(im);
            f = extractBillFeatures(im, cc, 1);
            if size(f) > 0
                pics{1, index} = f;
                y2 = [y2, j];
                index = index + 1;
            end
            ang = ang + 30;
        end 
    end
end


data = zeros(imageSize,imageSize,1,size(pics, 2));
for i=1:size(pics, 2)
    im = pics{1, i};
    for x=1:imageSize
        for y=1:imageSize
            val = single(im(x,y));
            data(x, y, 1, i) = val;
        end
    end
end
size(y1)
size(y2)
labels = single(cat(2, y1, y2));
imtool(uint8(data(:,:,:,2)))

data = single(data);
set = [ones(1,numel(y1)) 2*ones(1,numel(y2))];
%data = single(reshape(cat(3, x1, x2),28,28,1,[]));
dataMean = mean(data(:,:,:,set == 1), 4);
%data = bsxfun(@minus, data, dataMean) ;

imdb.images.data = data ;
imdb.images.data_mean = dataMean;
imdb.images.labels =  single(cat(2, y1, y2));
imdb.images.set = set ;
imdb.meta.sets = {'train', 'val', 'test'} ;
%imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),0:9,'uniformoutput',false) ;
