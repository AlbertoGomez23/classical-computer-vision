function [coin_id, scale] = find_coin_scale(bw, cc, ids)
%FIND_COIN_SCALE Finds the 2-euro coin and returns the image scale.
%   [coin_id, scale] = find_coin_scale(bw, cc, ids) returns the index of
%   the component that is the coin and the scale in pixels per millimetre.
%
%   The coin is the most circular object (circularity = 4*pi*area /
%   perimeter^2, which is 1 for a circle). Its radius is the maximum of the
%   distance transform inside it: in a filled circle the point farthest
%   from the border is the centre, at exactly one radius.

    COIN_DIAMETER_MM = 25.75;          % 2-euro coin

    props = regionprops(cc, 'Circularity');
    circularity = [props(ids).Circularity];
    [~, k] = max(circularity);
    coin_id = ids(k);

    dist = bwdist(~bw);
    radius_px = max(dist(cc.PixelIdxList{coin_id}));
    scale = 2 * radius_px / COIN_DIAMETER_MM;
end
