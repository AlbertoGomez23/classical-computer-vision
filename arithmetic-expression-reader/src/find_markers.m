function [c, idx] = find_markers(bw)
%FIND_MARKERS Finds the three QR-like markers of the sheet.
%   [c, idx] = find_markers(bw) returns the centroids of the inner squares
%   of the three markers, ordered as A (top left), B (bottom left) and
%   C (top right), and their object indices in regionprops(bw). Both are
%   empty if the markers are not found.
%
%   Once binarized, each marker is two objects (the outer ring and the inner
%   square) with practically the same centroid, which no character
%   satisfies. So for each object the distance to its nearest neighbour is
%   computed: the six smallest distances are the three rings and their three
%   squares, and of those six the three smallest are the squares.
%
%   To tell them apart, the sum of distances from each marker to the other
%   two is used: A is in the corner, so it has the smallest sum, and C the
%   largest, because the expression area is wider than it is tall.

    c = [];
    idx = [];
    stats = regionprops(bw, 'Area', 'Centroid');
    centroids = cat(1, stats.Centroid);
    n = size(centroids, 1);
    if n < 6          % 3 rings + 3 squares
        return;
    end

    d = zeros(n);
    for i = 1:n
        d(:, i) = sqrt(sum((centroids - centroids(i, :)) .^ 2, 2));
    end
    d(logical(eye(n))) = inf;               % ignore the distance to itself
    [d_min, nearest] = min(d);
    [~, order] = sort(d_min);
    candidates = nearest(order(1:6));
    [~, by_area] = sort([stats(candidates).Area]);
    idx = candidates(by_area(1:3));
    c = centroids(idx, :);

    D = zeros(3);
    for i = 1:3
        D(i, :) = sqrt(sum((c - c(i, :)) .^ 2, 2));
    end
    [~, order] = sort(sum(D));
    c = c(order, :);
    idx = idx(order);
end
