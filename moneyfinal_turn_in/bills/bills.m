function [ value ] = bills( img )
%This function will take an image as input, extract portions of the image
%which are paper money, classify their denominations, and return an integer
%value of their combined worth. This entire process will be amortized over
%several files to be developed during the time given for this project.

value = 0;

%obtain binary image of connected components of rectangles found in the
%original image
possibleBills = getRectangles(img);

%obtain binary image of connected components found to be bills
classifiedBills = classifyBills(possibleBills, img);

%loop through connected components to individually classify each bill and
%accumulate the sum to be returned

for i = 1:max(max(classifiedBills))
    %obtain value of bill and add to total
    value = value + classifySingleBill(classifiedBills == i, img);
end

end

