function [ classes ] = classifyCoin( coins )
%CLASSIFYCOIN  given the set of coin images alread extracted
% returns the corresponding classes
s = size(coins, 2);
classes = zeros(1, s);
penniesSizes = [];
for i=1:s
    coin = coins{1,i};
    if isPenny(coin) == true
        classes(i) = 4;
        penniesSizes = [penniesSizes size(coin, 1)];
    %{
    elseif isNotGrey(coin) == true
        classes(i) = -1;
    %}
    else
        classes(i) = classifyWithNets(coin);
    end
end

if(size(penniesSizes, 1) ~= 0)
    t = size(penniesSizes, 2);
    sum = 0;
    for i=1:t
        sum = sum + penniesSizes(i);
    end

    sum = sum/t;

    for i=1:s
        coin = coins{1,i};
        if ~isPenny(coin)
            if (size(coin, 1)<sum)
                classes(i)=1;
            elseif classes(i) ==1
                % reclassify instead
                %{
                if size(coin, 1)<sum*.835/.75*1.03
                    classes(i)=2;
                else
                    classes(i)=3;
                end
                %}
                classes(i) = classifyNickelyOrQuarter(coin);
            end
        end
    end
end
