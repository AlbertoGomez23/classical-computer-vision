function res = detect_lego_bricks(img, color_names, color_refs)
%DETECT_LEGO_BRICKS Detects, counts and classifies the LEGO pieces of a photo.
%   res = detect_lego_bricks(img, color_names, color_refs) processes an RGB
%   photo taken from above on a blue background, with a 2-euro coin as
%   scale reference, and returns a struct with:
%     res.scale    - pixels per millimetre
%     res.mask     - mask of the pieces (without the coin)
%     res.pieces   - one element per piece with its centroid, colour,
%                    geometry, pose, face and measured size
%     res.studs    - centres and radii of all the studs found
%     res.catalog  - catalog of geometries and poses (see lego_catalog)
%     res.colors   - colour names

    catalog = lego_catalog();
    gray = rgb2gray(img);

    % 1) Segmentation and noise removal
    bw = segment_pieces(img);
    [cc, ids] = remove_noise_components(bw);

    % 2) Scale from the coin, which is then removed from the list of pieces
    [coin_id, scale] = find_coin_scale(bw, cc, ids);
    ids(ids == coin_id) = [];

    props = regionprops(cc, 'Centroid', 'BoundingBox');
    n = numel(ids);
    pieces = repmat(struct('centroid', [], 'color', 0, 'geometry', 0, ...
        'pose', 0, 'face', 0, 'size_mm', [], 'dist_mm', 0, 'num_studs', 0), 1, n);
    all_centers = zeros(0, 2);
    all_radii = zeros(0, 1);

    for i = 1:n
        id = ids(i);
        pix = cc.PixelIdxList{id};
        mask = false(size(bw));
        mask(pix) = true;
        pieces(i).centroid = props(id).Centroid;

        % 3) Colour: nearest reference
        pieces(i).color = classify_color(color_features(img, pix), color_refs);

        % 4) Geometry and pose: nearest candidate view
        pieces(i).size_mm = measure_piece(mask, scale);
        [pieces(i).geometry, pieces(i).pose, pieces(i).dist_mm] = ...
            classify_geometry(pieces(i).size_mm, catalog);

        % 5) Pieces lying flat: studs up or down. Studs up, all the studs
        %    of the geometry are visible; studs down, far fewer. If more
        %    than half of the expected studs are found, the piece is up.
        if pieces(i).pose == 1
            [centers, radii] = detect_studs(gray, props(id).BoundingBox, scale, catalog);
            pieces(i).num_studs = numel(radii);
            expected = catalog.studs(pieces(i).geometry);
            if pieces(i).num_studs > expected / 2
                pieces(i).face = 1;
            else
                pieces(i).face = 2;
            end
            all_centers = [all_centers; centers]; %#ok<AGROW>
            all_radii = [all_radii; radii];       %#ok<AGROW>
        end
    end

    res.scale = scale;
    res.mask = ismember(labelmatrix(cc), ids);
    res.pieces = pieces;
    res.studs.centers = all_centers;
    res.studs.radii = all_radii;
    res.catalog = catalog;
    res.colors = color_names;
end
