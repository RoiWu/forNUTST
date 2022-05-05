function [xdata, ydata, zdata] = ...
    removeExtraNanSeparators(xdata, ydata, zdata)

  if nargin < 3
    if ~isequal(isnan(xdata), isnan(ydata))
        error(['map:' mfilename ':inconsistentXY'], ...
            'XDATA and YDATA mismatch in size or NaN locations.')
    end
else
    if ~isequal(isnan(xdata), isnan(ydata), isnan(zdata))
        error(['map:' mfilename ':inconsistentXYZ'], ...
            'XDATA, YDATA (or ZDATA) mismatch in size or NaN locations.')
    end
end

if ~isempty(xdata) && ~isvector(xdata)
    error(['map:' mfilename ':nonVectorInput'], ...
        'XDATA, YDATA (and ZDATA) must be vectors.')
end

% Locate extra NaNs.
n = isnan(xdata(:));
firstOrPrecededByNaN = [true; n(1:end-1)];
extraNaN = n & firstOrPrecededByNaN;

% Remove extra NaNs.
xdata(extraNaN) = [];
ydata(extraNaN) = [];
if nargin >= 3
    zdata(extraNaN) = [];
end
