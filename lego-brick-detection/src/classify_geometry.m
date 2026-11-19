function [geometry, pose, dist_mm] = classify_geometry(size_mm, catalog)
%CLASSIFY_GEOMETRY Geometry and pose of a piece from its measured size.
%   [geometry, pose, dist_mm] = classify_geometry(size_mm, catalog) compares
%   the measured [short long] with the 21 candidate views of the catalog
%   (7 geometries x 3 poses) and keeps the nearest one. dist_mm is how far
%   the measurement is from that view.

    d = sqrt(sum((catalog.views - size_mm) .^ 2, 2));
    [dist_mm, k] = min(d);
    geometry = catalog.view_geometry(k);
    pose = catalog.view_pose(k);
end
