function [crop, origin] = crop_expression_area(bw, c, margin)
%CROP_EXPRESSION_AREA Crops the area between the three markers.
%   [crop, origin] = crop_expression_area(bw, c, margin) returns the crop
%   and its top-left corner [xmin ymin]. The margin keeps the markers out of
%   the crop and is measured on the marker itself, so it adapts to the
%   distance of the camera.

    xmin = c(1, 1) + margin;
    ymin = c(1, 2) + margin;
    width = (c(3, 1) - margin) - xmin;
    height = (c(2, 2) - margin) - ymin;
    crop = imcrop(bw, [xmin ymin width height]);
    origin = [xmin ymin];
end
