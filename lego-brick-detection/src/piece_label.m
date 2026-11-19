function txt = piece_label(res, i)
%PIECE_LABEL Text describing piece i: colour, geometry and pose.
    p = res.pieces(i);
    if p.pose == 1
        pose = res.catalog.faces{p.face};      % lying flat: studs up / down
    else
        pose = res.catalog.poses{p.pose};      % on its side: brick / plate
    end
    txt = sprintf('%s | %s | %s', res.colors{p.color}, ...
        res.catalog.geometries{p.geometry}, pose);
end
