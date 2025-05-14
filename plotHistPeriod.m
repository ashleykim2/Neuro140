function plotHistPeriod(details, edges, data, rangeIn, cutOff, GausNew)
    % Plot a PSTH of a single period.
    % Check if 'details' is provided and contains necessary fields
    hold on
    
    if any(size(data) == 1)
        bar(edges, data, 'faceColor', 'k', 'barWidth', 1, 'linestyle', 'none', 'FaceAlpha', 0.7)
    else
        if ~exist('rangeIn', 'var')
            rangeIn = flip(1:size(data, 1));
        end
        cmap = flip(parula(size(data, 1)));
        for inVal = rangeIn
            bar(edges, data(inVal, :), 'faceColor', cmap(inVal, :), 'barWidth', 1, 'linestyle', 'none', 'FaceAlpha', 0.7)
        end
    end
    
    xlabel('Time [ms]');
    ylabel('Rate [spikes/s]');
    set(gca, 'TickDir', 'out'); % Move ticks to outside
    
    yl = ylim;
    yl = [0 ceil(yl(2) * 1.05)];
    
    % Only use the details struct if it is provided and contains the necessary fields
    if ~isempty(details) && isfield(details, 'ABI') && contains(details.ABI, 'ABI')
        rectangle('Position', [details.Time(details.StimLocSamp(1)) + details.inGateDelay, yl(1), ...
            details.Time(details.artLengthSamp + 2), abs(yl(1) - yl(2))], 'faceColor', [.5, .5, .5, .3], 'lineStyle', 'none')
    end
    
    if exist('GausNew', 'var')
        gaussian = @(a, c, div) a * exp(-(edges - c) .^ 2 / div);
        skew = @(sslope, scenter) normcdf(edges, scenter, sslope);
        for inVal = 1:size(data, 1)
            if isfield(GausNew{inVal}, 'g2')
                x_L = gaussian(GausNew{inVal}.g2.amp, GausNew{inVal}.g2.center, GausNew{inVal}.g2.div);
                plot(edges, x_L, 'color', 'g', 'linewidth', 2);
            end
            if isfield(GausNew{inVal}, 'g1')
                x_E = gaussian(GausNew{inVal}.g1.amp, GausNew{inVal}.g1.center, GausNew{inVal}.g1.div);
                if isfield(GausNew{inVal}.g1, 'scenter')
                    xx = skew(GausNew{inVal}.g1.sslope, GausNew{inVal}.g1.scenter);
                    x_E = x_E .* xx;
                end
                plot(edges, x_E, 'color', 'c', 'linewidth', 2);
            end
        end
    end
    
    ylim(yl);
    
    % Figure out x-lim
    xl(1) = 0;
    xl(2) = edges(end);
    xlim(xl);
    
    if exist('cutOff', 'var')
        line([cutOff(1), cutOff(1)], yl, 'color', 'r', 'linestyle', '-', 'lineWidth', 2);
        line([cutOff(end), cutOff(end)], yl, 'color', 'r', 'linestyle', '-', 'lineWidth', 2);
        if length(cutOff) == 3
            line([cutOff(2), cutOff(2)], yl, 'color', 'r', 'linestyle', '--', 'lineWidth', 2);
        end
    end
end
