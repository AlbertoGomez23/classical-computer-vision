function [templates, names] = load_templates(folder)
%LOAD_TEMPLATES Character templates taken from webcam captures.
%   [templates, names] = load_templates(folder) processes the three
%   template sheets (digits 0-4, digits 5-9 and operators) with the same
%   pipeline used for the video and returns one binary template per
%   character and its name. The templates come from webcam captures, not
%   from the printed file, so they have the same blur, lighting and stroke
%   width as what the program sees live.
%
%   x and / are named '*' and '/' so that the recognised text is directly
%   an expression MATLAB can evaluate.

    files = {'digits_0_4.png', 'digits_5_9.png', 'operators.png'};
    templates = {};
    for k = 1:numel(files)
        bw = logical(rgb2gray(imread(fullfile(folder, files{k}))));
        sheet = extract_characters(bw);
        templates = [templates, crop_objects(sheet.crop, regionprops(sheet.labels, 'BoundingBox'))]; %#ok<AGROW>
    end
    names = {'0','1','2','3','4','5','6','7','8','9','+','-','*','/'};
end
