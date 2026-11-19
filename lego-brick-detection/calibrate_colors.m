%% Colour calibration
% Adds the colours of a new calibration photo to data/color_references.csv,
% the table of reference colours used to classify the pieces.
%
% The table already contains the references measured on four photos (in
% data/color_calibration/) taken under three lighting conditions: two
% classroom sessions and a laboratory. Adding photos under new lighting
% conditions makes the colour classification more robust.
%
% How to use it:
%   1. Set CALIB_IMAGE to the new photo and run the script with PIECES = {}.
%      It shows the photo with the number of each detected component.
%   2. Fill PIECES with the component numbers of each colour (same order as
%      COLORS; [] if the colour does not appear) and set CONDITION.
%   3. Run it again: it computes the descriptor [r g b gray] of each colour
%      (see color_features) and appends one row per colour to the table.
%
% This is the only manual step of the method. It is done once, and then the
% same references are used for any new photo.

clear; close all; clc;
folder = fileparts(mfilename('fullpath'));
addpath(fullfile(folder, 'src'));

CALIB_IMAGE = fullfile(folder, 'data', 'color_calibration', 'class_day1.jpeg');
CONDITION = 'New condition';
PIECES = {};      % e.g. {[2 12], 6, [1 5], [], 21, ...} (one entry per colour)

COLORS = {'Dark green', 'Medium green', 'Light green', 'Orange', 'Yellow', 'Beige', ...
          'Dark brown', 'Light brown', 'Gray', 'Black', 'White'};
CSV_FILE = fullfile(folder, 'data', 'color_references.csv');

img = imread(CALIB_IMAGE);
[cc, ids] = remove_noise_components(segment_pieces(img));

if isempty(PIECES)
    % Step 1: show the number of each component
    props = regionprops(cc, 'Centroid');
    figure; imshow(img); hold on;
    title('Component numbers: fill PIECES with them and run again');
    for id = ids
        text(props(id).Centroid(1), props(id).Centroid(2), num2str(id), ...
            'BackgroundColor', 'w', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    end
    hold off;
    return;
end

% Step 3: compute the descriptor of each colour and append it to the table
assert(numel(PIECES) == numel(COLORS), 'PIECES needs one entry per colour');
[~, name, ext] = fileparts(CALIB_IMAGE);
T = readtable(CSV_FILE, 'TextType', 'string');
for c = 1:numel(COLORS)
    if isempty(PIECES{c}), continue; end
    f = zeros(numel(PIECES{c}), 4);
    for p = 1:numel(PIECES{c})
        f(p, :) = color_features(img, cc.PixelIdxList{PIECES{c}(p)});
    end
    f = mean(f, 1);
    T = [T; {string(COLORS{c}), string(CONDITION), string([name ext]), f(1), f(2), f(3), f(4)}]; %#ok<AGROW>
end
writetable(T, CSV_FILE);

[names, refs] = load_color_references(CSV_FILE);
disp(array2table(refs, 'RowNames', names, 'VariableNames', {'r', 'g', 'b', 'gray'}));
