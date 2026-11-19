function [fig1, fig2] = show_results(img, res)
%SHOW_RESULTS Figures with the classified pieces and the detected studs.
%   [fig1, fig2] = show_results(img, res) draws:
%     fig1 - the photo with each piece numbered and labelled with its
%            colour, geometry and pose
%     fig2 - the photo with the outline of each piece and the studs found
%            on the pieces lying flat

    fig1 = figure('Color', 'w', 'Position', [50 50 1400 1050]);
    imshow(img); hold on;
    title(sprintf('%d pieces classified by colour, geometry and pose', numel(res.pieces)));
    for i = 1:numel(res.pieces)
        c = res.pieces(i).centroid;
        text(c(1), c(2), sprintf('%d: %s', i, piece_label(res, i)), ...
            'Color', 'k', 'FontSize', 9, 'FontWeight', 'bold', 'BackgroundColor', 'w', ...
            'EdgeColor', 'k', 'HorizontalAlignment', 'center');
    end
    hold off;

    fig2 = figure('Color', 'w', 'Position', [50 50 1400 1050]);
    imshow(img); hold on;
    title('Detected pieces and studs');
    visboundaries(res.mask, 'Color', 'g');
    for i = 1:numel(res.pieces)
        c = res.pieces(i).centroid;
        text(c(1), c(2), sprintf('%d', i), 'Color', 'k', 'FontSize', 10, ...
            'FontWeight', 'bold', 'BackgroundColor', 'w');
    end
    if ~isempty(res.studs.radii)
        viscircles(res.studs.centers, res.studs.radii, 'Color', 'r', 'LineWidth', 1);
    end
    hold off;

    % Light theme, so the titles are readable whatever the MATLAB theme is
    if exist('theme', 'file'), theme(fig1, 'light'); theme(fig2, 'light'); end
end
