function [txt, value, valid] = evaluate_expression(expr, names)
%EVALUATE_EXPRESSION Builds the expression text and evaluates it.
%   [txt, value, valid] = evaluate_expression(expr, names) joins the
%   recognised characters into a text such as '12+4*3', checks that it has
%   the form number, operator, number, ... and evaluates it respecting the
%   operator precedence. Since the characters come in reading order, the
%   digits of a number are already together. value is NaN and valid is
%   false if the text is not a valid expression or the result is not finite
%   (division by zero).

    value = NaN;
    valid = false;
    txt = strjoin(names(expr), '');

    if isempty(regexp(txt, '^\d+([-+*/]\d+)*$', 'once'))
        return;
    end
    try
        v = str2num(txt); %#ok<ST2NM> safe: the regex only allows digits and + - * /
        if isscalar(v) && isfinite(v)
            value = v;
            valid = true;
        end
    catch
    end
end
