im = imread('fn.jpg');
%im = imresize(im, 0.1, 'bicubic');	
%im = imresize(im, 0.5, 'bicubic');	
im = double(im)/ 255;

k = 3;
seed = 1;
rand('state', seed);
means = rand(k,3);

[rows, cols, b] = size(im);

run = 0;
while run < 10 
    labels = zeros(rows, cols);
    for r=1:rows
        for c=1:cols
            closetCluster = 0;
            closetDist = sqrt(2);
            for j=1:k
                px = im(r,c, :);
                cluster = means(j, :);
                dist = sqrt((cluster(1) - px(1))^2 + (cluster(2) - px(2))^2 + (cluster(3) - px(3))^2);
                if dist < closetDist
                    closetDist = dist;
                    closetCluster = j;
                end
            end
            labels(r,c) = closetCluster;
        end 
    end
    for j=1:k
        n = length(find(labels == j));
        cluster = im .* repmat((labels == j), [1,1,3]);
        newX = sum(sum(cluster(:,:,1)))/ n;
        newY = sum(sum(cluster(:,:,2)))/ n;
        newZ = sum(sum(cluster(:,:,3)))/ n;
        means(j,:) = [newX, newY, newZ];
    end
run = run + 1;
end

R = zeros(rows, cols);
G = zeros(rows, cols);
B = zeros(rows, cols);
for j=1:k
    color = means(j,:);
    R(find(labels == j)) = color(1);
    G(find(labels == j)) = color(2);
    B(find(labels == j)) = color(3);
end

means

im(:,:,1) = R;
im(:,:,2) = G;
im(:,:,3) = B;
im = uint8(im * 255);
imshow(im);
