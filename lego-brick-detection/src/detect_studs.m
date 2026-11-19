function [centers, radii] = detect_studs(gray, bbox, scale, catalog)
%DETECT_STUDS Studs visible on a piece, found with the circular Hough transform.
%   [centers, radii] = detect_studs(gray, bbox, scale, catalog) searches the
%   grey image inside the bounding box of a piece and returns the centres
%   (in full-image coordinates) and radii of the studs found.
%
%   The expected stud radius in pixels comes from the scale (2.4 mm, +-15 %),
%   so the radius range adapts to the zoom of each photo. The search runs on
%   the Canny edges of the crop, which works better than the grey crop on
%   dark pieces, where the studs have very little contrast. Circles closer
%   than 0.75 times the distance between studs are the same stud detected
%   twice and only the first one is kept.

    radius_px = round(catalog.stud_radius * scale);
    radius_range = round([0.85 1.15] * radius_px);
    min_dist_px = 0.75 * catalog.stud_spacing * scale;

    crop = imcrop(gray, bbox);
    edges = edge(crop, 'canny');
    [centers, radii] = imfindcircles(edges, radius_range, ...
        'Sensitivity', 0.95, 'EdgeThreshold', 0.1);

    keep = true(numel(radii), 1);
    for a = 1:numel(radii)
        if keep(a)
            for b = a+1:numel(radii)
                if keep(b) && norm(centers(a, :) - centers(b, :)) < min_dist_px
                    keep(b) = false;
                end
            end
        end
    end
    centers = centers(keep, :);
    radii = radii(keep);

    if ~isempty(radii)
        centers = centers + bbox(1:2);       % crop -> full image coordinates
    end
end
