function bw = segment_pieces(img)
%SEGMENT_PIECES Binary mask of everything lying on the blue background.
%   bw = segment_pieces(img) returns a logical mask where the pieces (and
%   the coin) are 1 and the background is 0.
%
%   The photos are taken on a uniform blue background, so the blue plane is
%   the natural starting point: after complementing it, the background is
%   dark and the objects are bright. White pieces, however, also have a lot
%   of blue and can disappear with some lighting, so the red plane (where the
%   background is dark and white is bright) is thresholded too and both
%   masks are combined with a logical OR. Each plane is thresholded with
%   Otsu, so no fixed threshold is needed.

    blue = imcomplement(img(:, :, 3));     % background dark, objects bright
    red  = img(:, :, 1);

    bw_blue = imbinarize(blue, graythresh(blue));
    bw_red  = imbinarize(red,  graythresh(red));

    % Remove objects touching the image border (reflections in the corners)
    % and fill holes inside the pieces
    bw_blue = imfill(imclearborder(bw_blue), 'holes');
    bw_red  = imfill(imclearborder(bw_red),  'holes');

    % Combine both masks and close small gaps
    bw = imclose(bw_blue | bw_red, strel('square', 5));
end
