function [cc, ids] = remove_noise_components(bw)
%REMOVE_NOISE_COMPONENTS Connected components of the mask without the noise.
%   [cc, ids] = remove_noise_components(bw) returns the connected components
%   of bw (as given by bwconncomp) and the indices of the ones that are real
%   objects.
%
%   Instead of a fixed minimum area, which would depend on how far the
%   camera is, the areas are sorted and the largest jump between consecutive
%   areas is found. Between pieces the area grows by a factor of 2 or 3 at
%   most, while noise is far smaller, so if the largest jump is above 5
%   everything below it is considered noise.

    cc = bwconncomp(bw);
    ids = 1:cc.NumObjects;
    if cc.NumObjects < 2
        return;
    end

    areas = cellfun(@numel, cc.PixelIdxList);
    [sorted_areas, order] = sort(areas);
    jumps = sorted_areas(2:end) ./ sorted_areas(1:end-1);
    [max_jump, k] = max(jumps);

    if max_jump > 5
        ids = sort(order(k+1:end));
    end
end
