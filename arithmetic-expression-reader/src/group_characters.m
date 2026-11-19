function L = group_characters(crop)
%GROUP_CHARACTERS Label matrix with one label per character, left to right.
%   Most characters are a single object, but the division sign is three
%   (the bar and the two dots). Objects whose horizontal extents overlap
%   belong to the same character: the objects are sorted by where they
%   start in x and, going from left to right, an object that starts before
%   the current character ends is merged into it. Labels come out in reading
%   order, so multi-digit numbers stay together.

    objects = regionprops(crop, 'BoundingBox', 'PixelIdxList');
    L = zeros(size(crop));
    if isempty(objects)
        return;
    end
    boxes = cat(1, objects.BoundingBox);
    x_start = boxes(:, 1);
    x_end = x_start + boxes(:, 3);

    [~, order] = sort(x_start);
    character = zeros(numel(objects), 1);
    num = 0;
    current_end = -inf;
    for i = order'
        if x_start(i) > current_end         % new character
            num = num + 1;
            current_end = x_end(i);
        else                                % another piece of the same one
            current_end = max(current_end, x_end(i));
        end
        character(i) = num;
    end

    for i = 1:numel(objects)
        L(objects(i).PixelIdxList) = character(i);
    end
end
