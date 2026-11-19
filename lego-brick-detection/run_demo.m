%% LEGO piece detection and classification
% Detects, counts and classifies the LEGO pieces of a photo by colour,
% geometry and pose.
%
% To use your own photo, change IMAGE_FILE. The photo must be taken roughly
% from above on a uniform blue background, with the pieces separated and a
% 2-euro coin fully visible and not touching any piece (it gives the scale).

clear; close all; clc;
folder = fileparts(mfilename('fullpath'));
addpath(fullfile(folder, 'src'));

IMAGE_FILE = fullfile(folder, 'images', 'lego_09.jpeg');
SAVE_FIGURES = false;     % true: save the figures to results/

[color_names, color_refs] = load_color_references(fullfile(folder, 'data', 'color_references.csv'));

img = imread(IMAGE_FILE);
res = detect_lego_bricks(img, color_names, color_refs);
print_summary(res);
[fig1, fig2] = show_results(img, res);

if SAVE_FIGURES
    [~, name] = fileparts(IMAGE_FILE);
    exportgraphics(fig1, fullfile(folder, 'results', [name '_classified.jpg']), 'Resolution', 100);
    exportgraphics(fig2, fullfile(folder, 'results', [name '_studs.jpg']), 'Resolution', 100);
end
