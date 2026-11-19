function size_mm = measure_piece(mask, scale)
%MEASURE_PIECE Short and long side of a piece seen from above, in mm.
%   size_mm = measure_piece(mask, scale) takes the mask of a single piece
%   and returns [short long] in millimetres.
%
%   The piece can have any rotation in the image plane, so it is first
%   straightened: Orientation (angle between the x axis and the major axis
%   of the region) gives the rotation, and rotating the mask back by that
%   angle leaves the long side horizontal. Then the bounding box is the real
%   size of the piece.

    [rows, cols] = find(mask);
    mask = mask(min(rows):max(rows), min(cols):max(cols));

    props = regionprops(mask, 'Orientation');
    straight = imrotate(mask, -props(1).Orientation);

    [rows, cols] = find(straight);
    height_px = max(rows) - min(rows) + 1;
    width_px  = max(cols) - min(cols) + 1;

    size_mm = sort([height_px width_px]) / scale;
end
