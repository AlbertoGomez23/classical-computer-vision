function expr = recognize_characters(sheet, templates, names)
%RECOGNIZE_CHARACTERS Index of the template that matches each character.
%   expr = recognize_characters(sheet, templates, names) returns, for each
%   character of the sheet (left to right), the index in names of the most
%   similar template.
%
%   Each template is resized to the size of the character and compared with
%   normalized cross-correlation (normxcorr2), which subtracts the mean and
%   divides by the standard deviation, so the scores of all templates are
%   comparable and the highest one wins.
%
%   The minus sign is the exception: it fills almost its whole bounding box,
%   so after normalization there is hardly anything left to compare and any
%   template can win. What makes it special is the shape of the box: it is
%   the only character much wider than tall (height/width ~0.27, the rest
%   1 or more). So a character with height/width < 0.5 is a minus, and
%   otherwise the minus template does not take part.

    minus = find(strcmp(names, '-'));
    regions = regionprops(sheet.labels, 'BoundingBox');
    chars = crop_objects(sheet.crop, regions);
    expr = zeros(1, numel(chars));

    for i = 1:numel(chars)
        box = regions(i).BoundingBox;
        if box(4) / box(3) < 0.5
            expr(i) = minus;
            continue;
        end

        scores = -inf(1, numel(templates));
        for j = 1:numel(templates)
            if j == minus
                continue;
            end
            t = imresize(templates{j}, size(chars{i}));
            if numel(unique(t)) == 1    % normxcorr2 fails on a constant template
                continue;
            end
            cc = normxcorr2(t, chars{i});
            scores(j) = max(cc(:));
        end
        [~, expr(i)] = max(scores);
    end
end
