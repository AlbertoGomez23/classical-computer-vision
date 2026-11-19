%% Arithmetic expression reader on saved frames
% Runs the same pipeline as the live version (run_webcam.m) on the frames
% saved in examples/, so it can be tried without a webcam. Each frame is
% shown with the recognised expression and its result.

clear; close all; clc;
folder = fileparts(mfilename('fullpath'));
addpath(fullfile(folder, 'src'));

[templates, names] = load_templates(fullfile(folder, 'templates'));
files = dir(fullfile(folder, 'examples', '*.jpg'));

for k = 1:numel(files)
    img = imread(fullfile(files(k).folder, files(k).name));
    [out, txt, value, valid] = process_frame(img, templates, names);
    if valid
        fprintf('%-28s %s = %g\n', files(k).name, txt, value);
    elseif isempty(txt)
        fprintf('%-28s sheet not found\n', files(k).name);
    else
        fprintf('%-28s %s (no valid result)\n', files(k).name, txt);
    end
    figure('Name', files(k).name);
    imshow(out);
end
