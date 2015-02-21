
extractedData = [];
targetMatrix = [];

subdir = 'ones';
fileList = dir(subdir);

for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    cc = getRectangles(img);
    img = rgb2gray(img);
    for j = 1:max(max(cc))
        % reduce size
        mask = (cc == j);
        %I = repmat( uint8(mask), [1,1,1]) .* img;
        % find centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        % find corners of the region
        [xCorners, yCorners] = findCorners(mask, xCentroid, yCentroid);
        
        %find the long edge of the rectangle
        edge1 = [xCorners(1), yCorners(1); xCorners(2), yCorners(2)];
        edge2 = [xCorners(1), yCorners(1); xCorners(3), yCorners(3)];
        if(pdist(edge1,'euclidean')>pdist(edge2,'euclidean'))
            longEdge = edge1;
        else
            longEdge = edge2;
        end
        
        % calculate angle between edge and x-axis
        deltaY = (longEdge(1, 2) - longEdge(2, 2));
        deltaX = (longEdge(1, 1) - longEdge(2, 1));
        angleInDegrees = 180 - (atan2(deltaY, deltaX) * 180 / pi);
        
        %rotate image
        mask = imrotate(mask,angleInDegrees,'bilinear','crop');
        
        % find new centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        %find new corners which represent bounding box
        [newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
        dx = newXCorners(2) - newXCorners(1);
        dy = newYCorners(3) - newYCorners(1);
        
        %grab corner with denomination
        mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        
        %resize corner to 20x20
        I = imresize(I, [20, 20]);
        %imtool(I);
        
        % vectorize edge mask
        imgVector = I(:);
        classVector = [1;0;0;0;0;0;0];
        
        extractedData = [extractedData, imgVector];
        targetMatrix = [targetMatrix, classVector];
        % train on corner, portrait, whole bill
        % rotate to be horizontally, check to fill bounding box
        % look for parallel and perp lines for distracting backgrounds
        % pattennet, number of layers (1-15)
    end
end

subdir = 'twos';
fileList = dir(subdir);

for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    fileList(i).name
    cc = getRectangles(img);
    img = rgb2gray(img);
    for j = 1:max(max(cc))
        % reduce size
        mask = (cc == j);
        %I = repmat( uint8(mask), [1,1,1]) .* img;
        % find centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        % find corners of the region
        [xCorners, yCorners] = findCorners(mask, xCentroid, yCentroid);
        
        %find the long edge of the rectangle
        edge1 = [xCorners(1), yCorners(1); xCorners(2), yCorners(2)];
        edge2 = [xCorners(1), yCorners(1); xCorners(3), yCorners(3)];
        if(pdist(edge1,'euclidean')>pdist(edge2,'euclidean'))
            longEdge = edge1;
        else
            longEdge = edge2;
        end
        
        % calculate angle between edge and x-axis
        deltaY = (longEdge(1, 2) - longEdge(2, 2));
        deltaX = (longEdge(1, 1) - longEdge(2, 1));
        angleInDegrees = 180 - (atan2(deltaY, deltaX) * 180 / pi);
        
        %rotate image
        mask = imrotate(mask,angleInDegrees,'bilinear','crop');
        
        %find new corners which represent bounding box
        [newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
        dx = newXCorners(2) - newXCorners(1);
        dy = newYCorners(3) - newYCorners(1);
        
        %grab corner with denomination
        mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        
        %resize corner to 20x20
        I = imresize(I, [20, 20]);
        imtool(I);
        
        % vectorize edge mask
        imgVector = I(:);
        classVector = [0;1;0;0;0;0;0];
        
        extractedData = [extractedData, imgVector];
        targetMatrix = [targetMatrix, classVector];
        % train on corner, portrait, whole bill
        % rotate to be horizontally, check to fill bounding box
        % look for parallel and perp lines for distracting backgrounds
        % pattennet, number of layers (1-15)
    end
end

subdir = 'fives';
fileList = dir(subdir);

for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    fileList(i).name
    cc = getRectangles(img);
    img = rgb2gray(img);
    for j = 1:max(max(cc))
        % reduce size
        mask = (cc == j);
        %I = repmat( uint8(mask), [1,1,1]) .* img;
        % find centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        % find corners of the region
        [xCorners, yCorners] = findCorners(mask, xCentroid, yCentroid);
        
        %find the long edge of the rectangle
        edge1 = [xCorners(1), yCorners(1); xCorners(2), yCorners(2)];
        edge2 = [xCorners(1), yCorners(1); xCorners(3), yCorners(3)];
        if(pdist(edge1,'euclidean')>pdist(edge2,'euclidean'))
            longEdge = edge1;
        else
            longEdge = edge2;
        end
        
        % calculate angle between edge and x-axis
        deltaY = (longEdge(1, 2) - longEdge(2, 2));
        deltaX = (longEdge(1, 1) - longEdge(2, 1));
        angleInDegrees = 180 - (atan2(deltaY, deltaX) * 180 / pi);
        
        %rotate image
        mask = imrotate(mask,angleInDegrees,'bilinear','crop');

        %find new corners which represent bounding box
        [newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
        dx = newXCorners(2) - newXCorners(1);
        dy = newYCorners(3) - newYCorners(1);
        
        %grab corner with denomination
        mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        
        %resize corner to 20x20
        I = imresize(I, [20, 20]);
        %imtool(I);
        
        % vectorize edge mask
        imgVector = I(:);
        classVector = [0;0;1;0;0;0;0];
        
        extractedData = [extractedData, imgVector];
        targetMatrix = [targetMatrix, classVector];
        % train on corner, portrait, whole bill
        % rotate to be horizontally, check to fill bounding box
        % look for parallel and perp lines for distracting backgrounds
        % pattennet, number of layers (1-15)
    end
end

subdir = 'tens';
fileList = dir(subdir);

for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    fileList(i).name
    cc = getRectangles(img);
    img = rgb2gray(img);
    for j = 1:max(max(cc))
        % reduce size
        mask = (cc == j);
        %I = repmat( uint8(mask), [1,1,1]) .* img;
        % find centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        %corners = regionprops(mask, 'BoundingBox');
        
        %ul_corner = [corners(1), 
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        % find corners of the region
        [xCorners, yCorners] = findCorners(mask, xCentroid, yCentroid);
        width = [(xCorners(2) - xCorners(1)), (yCorners(3) - xCorners(1))];
        
        %find the long edge of the rectangle
        xWidth = width(1);
        yWidth = width(2);
        if(xWidth>yWidth)
            longEdge = edge1;
        else
            longEdge = edge2;
        end
        
        % calculate angle between edge and x-axis
        deltaY = (longEdge(1, 2) - longEdge(2, 2));
        deltaX = (longEdge(1, 1) - longEdge(2, 1));
        angleInDegrees = 180 - (atan2(deltaY, deltaX) * 180 / pi);
        
        %rotate image
        mask = imrotate(mask,angleInDegrees,'bilinear','crop');

        %find new corners which represent bounding box
        [newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
        dx = newXCorners(2) - newXCorners(1);
        dy = newYCorners(3) - newYCorners(1);
        
        %grab corner with denomination
        mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        
        %resize corner to 20x20
        I = imresize(I, [20, 20]);
        %imtool(I);
        
        % vectorize edge mask
        imgVector = I(:);
        classVector = [0;0;0;1;0;0;0];
        
        extractedData = [extractedData, imgVector];
        targetMatrix = [targetMatrix, classVector];
        % train on corner, portrait, whole bill
        % rotate to be horizontally, check to fill bounding box
        % look for parallel and perp lines for distracting backgrounds
        % pattennet, number of layers (1-15)
    end
end

subdir = 'twenties';
fileList = dir(subdir);

for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    fileList(i).name
    cc = getRectangles(img);
    img = rgb2gray(img);
    for j = 1:max(max(cc))
        % reduce size
        mask = (cc == j);
        %I = repmat( uint8(mask), [1,1,1]) .* img;
        % find centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        % find corners of the region
        [xCorners, yCorners] = findCorners(mask, xCentroid, yCentroid);
        
        %find the long edge of the rectangle
        edge1 = [xCorners(1), yCorners(1); xCorners(2), yCorners(2)];
        edge2 = [xCorners(1), yCorners(1); xCorners(3), yCorners(3)];
        if(pdist(edge1,'euclidean')>pdist(edge2,'euclidean'))
            longEdge = edge1;
        else
            longEdge = edge2;
        end
        
        % calculate angle between edge and x-axis
        deltaY = (longEdge(1, 2) - longEdge(2, 2));
        deltaX = (longEdge(1, 1) - longEdge(2, 1));
        angleInDegrees = 180 - (atan2(deltaY, deltaX) * 180 / pi);
        
        %rotate image
        mask = imrotate(mask,angleInDegrees,'bilinear','crop');

        %find new corners which represent bounding box
        [newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
        dx = newXCorners(2) - newXCorners(1);
        dy = newYCorners(3) - newYCorners(1);
        
        %grab corner with denomination
        mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        
        %resize corner to 20x20
        I = imresize(I, [20, 20]);
        %imtool(I);
        
        % vectorize edge mask
        imgVector = I(:);
        classVector = [0;0;0;0;1;0;0];
        
        extractedData = [extractedData, imgVector];
        targetMatrix = [targetMatrix, classVector];
        % train on corner, portrait, whole bill
        % rotate to be horizontally, check to fill bounding box
        % look for parallel and perp lines for distracting backgrounds
        % pattennet, number of layers (1-15)
    end
end

subdir = 'fifties';
fileList = dir(subdir);

for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    fileList(i).name
    cc = getRectangles(img);
    img = rgb2gray(img);
    for j = 1:max(max(cc))
        % reduce size
        mask = (cc == j);
        %I = repmat( uint8(mask), [1,1,1]) .* img;
        % find centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        % find corners of the region
        [xCorners, yCorners] = findCorners(mask, xCentroid, yCentroid);
        
        %find the long edge of the rectangle
        edge1 = [xCorners(1), yCorners(1); xCorners(2), yCorners(2)];
        edge2 = [xCorners(1), yCorners(1); xCorners(3), yCorners(3)];
        if(pdist(edge1,'euclidean')>pdist(edge2,'euclidean'))
            longEdge = edge1;
        else
            longEdge = edge2;
        end
        
        % calculate angle between edge and x-axis
        deltaY = (longEdge(1, 2) - longEdge(2, 2));
        deltaX = (longEdge(1, 1) - longEdge(2, 1));
        angleInDegrees = 180 - (atan2(deltaY, deltaX) * 180 / pi);
        
        %rotate image
        mask = imrotate(mask,angleInDegrees,'bilinear','crop');

        %find new corners which represent bounding box
        [newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
        dx = newXCorners(2) - newXCorners(1);
        dy = newYCorners(3) - newYCorners(1);
        
        %grab corner with denomination
        mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        
        %resize corner to 20x20
        I = imresize(I, [20, 20]);
        %imtool(I);
        
        % vectorize edge mask
        imgVector = I(:);
        classVector = [0;0;0;0;0;1;0];
        
        extractedData = [extractedData, imgVector];
        targetMatrix = [targetMatrix, classVector];
        % train on corner, portrait, whole bill
        % rotate to be horizontally, check to fill bounding box
        % look for parallel and perp lines for distracting backgrounds
        % pattennet, number of layers (1-15)
    end
end

subdir = 'hundos';
fileList = dir(subdir);

for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    fileList(i).name
    cc = getRectangles(img);
    img = rgb2gray(img);
    for j = 1:max(max(cc))
        % reduce size
        mask = (cc == j);
        %I = repmat( uint8(mask), [1,1,1]) .* img;
        % find centroid of rectangle
        measurements = regionprops(mask, 'Centroid');
        
        % Put a cross at the centroid.
        xCentroid = measurements.Centroid(1);
        yCentroid = measurements.Centroid(2);
        
        % find corners of the region
        [xCorners, yCorners] = findCorners(mask, xCentroid, yCentroid);
        
        %find the long edge of the rectangle
        edge1 = [xCorners(1), yCorners(1); xCorners(2), yCorners(2)];
        edge2 = [xCorners(1), yCorners(1); xCorners(3), yCorners(3)];
        if(pdist(edge1,'euclidean')>pdist(edge2,'euclidean'))
            longEdge = edge1;
        else
            longEdge = edge2;
        end
        
        % calculate angle between edge and x-axis
        deltaY = (longEdge(1, 2) - longEdge(2, 2));
        deltaX = (longEdge(1, 1) - longEdge(2, 1));
        angleInDegrees = 180 - (atan2(deltaY, deltaX) * 180 / pi);
        
        %rotate image
        mask = imrotate(mask,angleInDegrees,'bilinear','crop');

        %find new corners which represent bounding box
        [newXCorners, newYCorners] = findCorners(mask, xCentroid, yCentroid);
        dx = newXCorners(2) - newXCorners(1);
        dy = newYCorners(3) - newYCorners(1);
        
        %grab corner with denomination
        mask = mask(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        I = repmat( uint8(mask), [1,1,1]) .* img(newYCorners(1):(newYCorners(1) + floor(dy/2)), newXCorners(1):(newXCorners(1) + floor(dx/6)));
        
        %resize corner to 20x20
        I = imresize(I, [20, 20]);
        %imtool(I);
        
        % vectorize edge mask
        imgVector = I(:);
        classVector = [0;0;0;0;0;0;1];
        
        extractedData = [extractedData, imgVector];
        targetMatrix = [targetMatrix, classVector];
        % train on corner, portrait, whole bill
        % rotate to be horizontally, check to fill bounding box
        % look for parallel and perp lines for distracting backgrounds
        % pattennet, number of layers (1-15)
    end
end

save('features.mat', 'extractedData', 'targetMatrix');
