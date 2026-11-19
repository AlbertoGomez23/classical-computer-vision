function [bw, angle] = straighten_sheet(bw, c)
%STRAIGHTEN_SHEET Rotates the image so that the sheet is horizontal.
%   The line from marker A to marker C is horizontal on a straight sheet.
%   atan2d gives its full angle (-180 to 180 degrees), so an upside-down
%   sheet is also corrected and a 6 is never read as a 9. 'crop' keeps the
%   rotated image the same size as the frame.

    angle = atan2d(c(3, 2) - c(1, 2), c(3, 1) - c(1, 1));
    bw = imrotate(bw, angle, 'crop');
end
