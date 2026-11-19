%% Live arithmetic expression reader
% Reads a printed arithmetic expression from the webcam in real time and
% writes the result next to it. Hold one of the sheets of sheets/ in front of
% the camera, with the three square markers fully visible.
%
% Requires the MATLAB Support Package for USB Webcams. Press any key on the
% figure to stop.

clear; close all; clc;
folder = fileparts(mfilename('fullpath'));
addpath(fullfile(folder, 'src'));

MAX_SECONDS = 600;

[templates, names] = load_templates(fullfile(folder, 'templates'));
cam = webcam(1);
fig = figure('Name', 'Arithmetic expression reader');
set(fig, 'CurrentCharacter', ' ');

t = tic;
while toc(t) < MAX_SECONDS && ishandle(fig) && get(fig, 'CurrentCharacter') == ' '
    out = process_frame(snapshot(cam), templates, names);
    imshow(out);
    drawnow;
end

clear cam
if ishandle(fig), close(fig); end
