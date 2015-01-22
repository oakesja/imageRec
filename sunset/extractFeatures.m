function [ features ] = extractFeatures( image )
%EXTRACTFEATURES Summary of this function goes here
%   Detailed explanation goes here
[width, height, bands] = size(image);
gridPixelWidth = floor(width/7);
gridPixelHeight = floor(height/7);

features = [];
for i=0:6
    for j=0:6
        grid = image(i * gridPixelWidth + 1:(i+1)*gridPixelWidth, j * gridPixelHeight + 1:(j+1)*gridPixelHeight, :);
        grid = double(grid);
        L = grid(:,:,1) + grid(:,:,2)+ grid(:,:,3);
        S = grid(:,:,1) - grid(:,:,3);
        T = grid(:,:,1) - (grid(:,:,2)*2) + grid(:,:,3);
        features = [features, mean2(L), std(L(:)), mean2(S), std(S(:)), mean2(T), std(T(:), 1)];
    end
end

end

