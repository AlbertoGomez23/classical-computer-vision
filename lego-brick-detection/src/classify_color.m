function c = classify_color(features, refs)
%CLASSIFY_COLOR Index of the nearest reference colour (Euclidean distance).
    d = sqrt(sum((refs - features) .^ 2, 2));
    [~, c] = min(d);
end
