function bw = remove_small_objects(bw)
%REMOVE_SMALL_OBJECTS Removes the noise without a fixed minimum area.
%   The object areas are sorted and the largest jump between consecutive
%   areas is found. If it is larger than 5, everything below it is noise.
%   A fixed minimum area would depend on how far the camera is.

    stats = regionprops(bw, 'Area', 'PixelIdxList');
    if numel(stats) < 2
        return;
    end
    [areas, order] = sort([stats.Area]);
    [max_jump, k] = max(areas(2:end) ./ areas(1:end-1));
    if max_jump > 5
        for i = 1:k
            bw(stats(order(i)).PixelIdxList) = 0;
        end
    end
end
