function bw = binarize_frame(img)
%BINARIZE_FRAME Binary image with the characters and markers in white.
%   The frame is converted to grey and thresholded with Otsu. Characters
%   are black on white paper, so the result is complemented (MATLAB expects
%   the objects to be 1). Objects touching the border are removed and an
%   order filter (minimum in a 3x3 window) removes isolated noise pixels.

    gray = rgb2gray(img);
    bw = imcomplement(imbinarize(gray, graythresh(gray)));
    bw = imclearborder(bw);
    bw = ordfilt2(bw, 1, ones(3));
end
