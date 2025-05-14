%% plotAllChannelsWithFits.m
% This script loads automated fit results and visualizes early and late Gaussian components
% across stimulation levels, producing a separate figure for each channel.

clc;
clear;
close all;

%% Load required data
load(fullfile('..','Data','VA_21_04_20-Trial017.mat'));  % Contains HistPeriod and details
load('autoFitResults.mat');                              % Contains autoFitResults

rangeIn = 1:length(details.inLevels);
HistPeriodtoPlot = squeeze(mean(HistPeriod(:,:,:,1:end/2+1,:), 4));
spont = squeeze(mean(mean(HistPeriod(:,1,:,1:end/2+1, details.artLengthSamp+20:end-20), 4), 5));
for ch = 1:16
    HistPeriodtoPlot(:,ch,:) = HistPeriodtoPlot(:,ch,:) - spont(ch);
end
HistPeriodtoPlot(HistPeriodtoPlot < 0) = 0;
t = PeriodEdges4Plotting(1,:)';

outputDir = 'channel_fit_figures';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Plot early/late fits for all 16 channels
numLevels = size(HistPeriodtoPlot, 1);

for ch = 1:16
    figure('Visible', 'off'); % prevent popping up during generation
    hold on;

    cmap = parula(numLevels);
    
    for lvl = 1:numLevels
        psth = squeeze(HistPeriodtoPlot(lvl, ch, :));
        fit = autoFitResults{lvl, ch};

        % Early and late curves
        early = fit.g1.amp * exp(-((t - fit.g1.center).^2) / (2 * fit.g1.sigma^2));
        late  = fit.g2.amp * exp(-((t - fit.g2.center).^2) / (2 * fit.g2.sigma^2));

        plot(t, early, '-', 'Color', cmap(lvl,:), 'LineWidth', 1.5);
        plot(t, late, '--', 'Color', cmap(lvl,:), 'LineWidth', 1.5);
    end

    xlabel('Time [ms]');
    ylabel('Spike Count');
    title(sprintf('Early (solid) and Late (dashed) Gaussians - Channel %d', ch));
    xlim([0 25]);
    legend(arrayfun(@(x) sprintf('Level %d', x), 1:numLevels, 'UniformOutput', false), ...
           'Location', 'northeastoutside');
    set(gca, 'FontSize', 10);
    
    % Save the figure
    saveas(gcf, fullfile(outputDir, sprintf('Channel_%02d_Fits.png', ch)));
    close;
end

disp('✅ All channel figures saved to channel_fit_figures/');
