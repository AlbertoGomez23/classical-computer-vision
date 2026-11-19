function [names, refs] = load_color_references(csv_file)
%LOAD_COLOR_REFERENCES Reference descriptor of each colour.
%   [names, refs] = load_color_references(csv_file) reads the calibration
%   table built by calibrate_colors.m and returns the colour names and one
%   reference [r g b gray] per colour.
%
%   The proportions remove the effect of the amount of light but not of its
%   type, so the calibration photos were taken under three lighting
%   conditions. Each colour is first averaged within each condition and then
%   across conditions, so that a condition with more photos does not weigh
%   more than the others.

    T = readtable(csv_file, 'TextType', 'string');
    names = unique(T.color, 'stable');
    features = [T.r T.g T.b T.gray];

    refs = zeros(numel(names), 4);
    for c = 1:numel(names)
        is_c = T.color == names(c);
        conditions = unique(T.condition(is_c), 'stable');
        per_condition = zeros(numel(conditions), 4);
        for k = 1:numel(conditions)
            per_condition(k, :) = mean(features(is_c & T.condition == conditions(k), :), 1);
        end
        refs(c, :) = mean(per_condition, 1);
    end
    names = cellstr(names);
end
