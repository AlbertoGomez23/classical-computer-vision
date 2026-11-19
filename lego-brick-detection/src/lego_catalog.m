function catalog = lego_catalog()
%LEGO_CATALOG Real dimensions of the LEGO pieces and of what is seen from above.
%   catalog = lego_catalog() returns a struct with the geometries, their real
%   sizes and the table of candidate views used to classify each piece.
%
%   From above only two of the three dimensions of a piece are visible, so
%   each geometry can appear in three poses:
%     1) lying flat (studs up or down) -> width  x length
%     2) brick on its side             -> height x length
%     3) plate on its side             -> height x length
%   The heights include the studs, because on its side the studs stick out
%   and are part of the mask. Each pair is sorted as [short long].

    catalog.geometries = {'1x1', '1x2', '1x3', '2x2', '2x3', '2x4', '2x6'};
    catalog.studs      = [1 2 3 4 6 8 12];          % studs of each geometry
    %               width  length (mm)
    catalog.sizes = [   7.8    7.8;
                    7.8   15.8;
                    7.8   23.8;
                   15.8   15.8;
                   15.8   23.8;
                   15.8   31.8;
                   15.8   47.8];
    catalog.brick_height = 11.3;                    % with studs
    catalog.plate_height = 4.9;                     % with studs
    catalog.stud_radius  = 2.4;
    catalog.stud_spacing = 8;                       % distance between stud centres

    catalog.poses = {'Lying flat', 'Brick on its side', 'Plate on its side'};
    catalog.faces = {'Studs up', 'Studs down'};

    n = numel(catalog.geometries);
    catalog.views = zeros(3 * n, 2);                % [short long] of each candidate view
    catalog.view_geometry = zeros(3 * n, 1);
    catalog.view_pose = zeros(3 * n, 1);
    row = 0;
    for g = 1:n
        len = catalog.sizes(g, 2);
        seen = [catalog.sizes(g, 1)  len;            % lying flat
                catalog.brick_height len;            % brick on its side
                catalog.plate_height len];           % plate on its side
        for p = 1:3
            row = row + 1;
            catalog.views(row, :) = sort(seen(p, :));
            catalog.view_geometry(row) = g;
            catalog.view_pose(row) = p;
        end
    end
end
