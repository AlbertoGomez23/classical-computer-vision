function [out, txt, value, valid] = process_frame(img, templates, names)
%PROCESS_FRAME Reads the expression of a frame and draws the result on it.
%   [out, txt, value, valid] = process_frame(img, templates, names) returns
%   the frame with "= result" written next to the expression (green if the
%   expression is valid, red '= ?' if not) and the recognised text on the
%   top left. txt is empty if no sheet was found.

    out = img;
    txt = '';
    value = NaN;
    valid = false;

    sheet = extract_characters(binarize_frame(img));
    if ~sheet.found
        out = insertText(out, [25 25], 'Looking for the sheet...', 'FontSize', 20, 'TextColor', 'black');
        return;
    end

    expr = recognize_characters(sheet, templates, names);
    [txt, value, valid] = evaluate_expression(expr, names);
    if valid
        message = sprintf('= %g', value);
        color = [0 255 0];
    else
        message = '= ?';
        color = [255 0 0];
    end

    % The result is written on a black canvas the size of the straightened
    % image, one character step after the last character, with the height
    % of the characters. Then the canvas is rotated back to the frame and
    % its white pixels are painted, so the result follows the sheet.
    position = sheet.last + sheet.step + sheet.origin;
    boxes = regionprops(sheet.labels, 'BoundingBox');
    font_size = min(200, max(8, round(boxes(1).BoundingBox(4))));   % insertText limits
    canvas = insertText(zeros(size(sheet.rotated), 'uint8'), position, message, ...
        'FontSize', font_size, 'TextColor', 'white', 'BoxOpacity', 0, 'AnchorPoint', 'LeftCenter');
    mask = imrotate(rgb2gray(canvas) > 128, -sheet.angle, 'crop');
    for k = 1:3
        channel = out(:, :, k);
        channel(mask) = color(k);
        out(:, :, k) = channel;
    end

    if valid
        info = sprintf('Detected: %s = %g', txt, value);
    else
        info = sprintf('Detected: %s (not valid)', txt);
    end
    out = insertText(out, [25 25], info, 'FontSize', 20, 'TextColor', 'black');
end
