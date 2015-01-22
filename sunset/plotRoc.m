function [ ] = plotRoc( tprs, fprs, t, xLabel, yLabel)
%PLOTROC Summary of this function goes here
%   Detailed explanation goes here
% Create a new figure. You can also number it: figure(1)
figure;
% Hold on means all subsequent plot data will be overlaid on a single plot
hold on;
% Plots using a blue line (see 'help plot' for shape and color codes 
plot(fprs, tprs, 'b-', 'LineWidth', 2);
% Overlaid with circles at the data points
plot(fprs, tprs, 'bo', 'MarkerSize', 6, 'LineWidth', 2);

% You could repeat here with a different color/style if you made 
% an enhancement and wanted to show that it outperformed the baseline.

% Title, labels, range for axes
title(strcat('', t), 'fontSize', 18); % CHANGE this generic title!
xlabel(strcat('', xLabel), 'fontWeight', 'bold');
ylabel(strcat('', yLabel), 'fontWeight', 'bold');
% TPR and FPR range from 0 to 1. You can change these if you want to zoom in on part of the graph.
axis([0 1 0 1]);

end

