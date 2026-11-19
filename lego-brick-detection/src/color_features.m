function f = color_features(img, pixel_idx)
%COLOR_FEATURES Brightness-independent colour descriptor of a region.
%   f = color_features(img, pixel_idx) returns [r g b gray] for the pixels
%   pixel_idx of the RGB image img:
%     - r, g, b: proportion of each channel, R/(R+G+B), etc. They do not
%       change if the whole piece receives more or less light.
%     - gray: mean grey level / 255. Black, grey and white have almost the
%       same RGB proportions and are only told apart by their brightness.

    img = double(img);
    plane = numel(img(:, :, 1));
    r = mean(img(pixel_idx));
    g = mean(img(pixel_idx + plane));
    b = mean(img(pixel_idx + 2 * plane));
    gray = 0.2989 * r + 0.5870 * g + 0.1140 * b;   % same weights as rgb2gray

    f = [r g b] / (r + g + b);
    f(4) = gray / 255;
end
