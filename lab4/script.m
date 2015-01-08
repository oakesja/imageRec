original = imread('shapes.png');
[L, num] = bwlabel(original, 8);

elongVals = [];
circularity = [];
class = original;

for i=1:num
    [r, c] = find(L==i);

    meanY1 = mean(r);
    meanX1 = mean(c);

    xx = sum((c - meanX1) .^2)*1/length(c);
    yy = sum((r - meanY1) .^2)*1/length(r);
    xy = sum((c - meanX1) .* (r - meanY1))*1/length(c);

    cov = [xx xy; xy yy];

    eigVals = eig(cov);

    elong = sqrt(max(eigVals)/min(eigVals));
    elongVals = [elongVals; elong];
    
    % finding C1 circularity
    perim = bwtraceboundary(original, [r(1) c(1)], 'W', 8)
    perimLength = 0;
    for j=1:length(perim)-1
        changeX = abs(perim(j,1) - perim(j+1, 1));
        changeY = abs(perim(j,2) - perim(j+1, 2));
        if(changeX + changeY  == 2)
            perimLength = perimLength + sqrt(2);
        else 
            perimLength = perimLength + 1;
        end
    end   
    
    c1 = (perimLength^2)/length(r);
    circularity = [circularity; c1];
    
    if elong < 1.01
        if c1 < 15
            % circle
            class(find(L == i)) = 1;
        else
            % square
            class(find(L == i)) = 2;
        end
    else
        if c1 < 17
            % ellipse
            class(find(L == i)) = 3;
        else
            % rectangle
            class(find(L == i)) = 4;
        end
    end
end

imtool(label2rgb(class));
