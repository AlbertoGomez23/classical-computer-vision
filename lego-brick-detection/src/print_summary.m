function print_summary(res)
%PRINT_SUMMARY Prints the counts by geometry, by colour and by combination.
    geometries = res.catalog.geometries;
    colors = res.colors;
    g_idx = [res.pieces.geometry];
    c_idx = [res.pieces.color];

    fprintf('\n========== SUMMARY ==========\n');
    fprintf('Total pieces: %d   (scale: %.2f px/mm)\n', numel(res.pieces), res.scale);

    fprintf('\nBy geometry:\n');
    for g = 1:numel(geometries)
        fprintf('  %-4s %d\n', geometries{g}, sum(g_idx == g));
    end

    fprintf('\nBy colour:\n');
    for c = 1:numel(colors)
        fprintf('  %-13s %d\n', colors{c}, sum(c_idx == c));
    end

    fprintf('\nGeometry - colour combinations:\n');
    for g = 1:numel(geometries)
        for c = 1:numel(colors)
            k = sum(g_idx == g & c_idx == c);
            if k > 0
                fprintf('  %s %s: %d\n', geometries{g}, colors{c}, k);
            end
        end
    end

    fprintf('\nPieces:\n');
    for i = 1:numel(res.pieces)
        fprintf('  %2d: %-40s %5.1f x %5.1f mm\n', i, piece_label(res, i), res.pieces(i).size_mm);
    end
end
