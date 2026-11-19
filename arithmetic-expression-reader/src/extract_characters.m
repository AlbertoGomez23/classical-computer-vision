function sheet = extract_characters(bw)
%EXTRACT_CHARACTERS Locates the sheet and separates its characters.
%   sheet = extract_characters(bw) takes a binary image and returns a
%   struct with:
%     sheet.found    - false if the three markers or at least two
%                      characters were not found
%     sheet.labels   - one label per character, in reading order
%     sheet.crop     - binary crop of the expression area
%     sheet.origin   - top-left corner of the crop in the rotated image
%     sheet.angle    - rotation applied to straighten the sheet
%     sheet.rotated  - the straightened binary image
%     sheet.step     - vector between the centroids of the first two
%                      characters (used to place the result)
%     sheet.last     - centroid of the last character
%
%   The same function is used for the template sheets and for every video
%   frame, so templates and live characters go through exactly the same
%   processing and can be compared.

    sheet = struct('found', false, 'labels', [], 'crop', [], 'origin', [0 0], ...
        'angle', 0, 'rotated', [], 'step', [0 0], 'last', []);

    bw = remove_small_objects(bw);
    c = find_markers(bw);
    if size(c, 1) ~= 3
        return;
    end

    [bw, angle] = straighten_sheet(bw, c);
    [c, idx] = find_markers(bw);             % the markers moved with the rotation
    if size(c, 1) ~= 3
        return;
    end

    % Margin: twice the width of the inner square of marker A
    stats = regionprops(bw, 'BoundingBox');
    margin = 2 * stats(idx(1)).BoundingBox(3);
    [crop, origin] = crop_expression_area(bw, c, margin);
    crop = remove_small_objects(crop);

    L = group_characters(crop);
    chars = regionprops(L, 'Centroid');
    if numel(chars) < 2
        return;
    end
    centroids = cat(1, chars.Centroid);

    sheet.found = true;
    sheet.labels = L;
    sheet.crop = crop;
    sheet.origin = origin;
    sheet.angle = angle;
    sheet.rotated = bw;
    sheet.step = centroids(2, :) - centroids(1, :);
    sheet.last = centroids(end, :);
end
