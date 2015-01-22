
path = 'sunsetDetectorImages/TestNonsunsets/';
fileList = dir(path);
names = []
for i = 3:size(fileList)
    if i == 216
        fileList(i).name
    end
end

% fp easy  208   210   214   225   235

%{
load('newNeuralBest.mat')

figure;
hold on;
scatter(allAccs(:, 2), allAccs(:,1))

title('Neural Net Accuracies', 'fontSize', 18); % CHANGE this generic title!
xlabel('Hidden Layer Size', 'fontWeight', 'bold');
ylabel('Accuracy', 'fontWeight', 'bold');
%}