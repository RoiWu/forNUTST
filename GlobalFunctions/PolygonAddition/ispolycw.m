function tf = ispolycw(x, y)
if isempty(x)
   tf = true;
elseif iscell(x)
    tf = false(size(x));
    for k = 1:numel(x)
        tf(k) = isContourClockwise(x{k}, y{k});
    end
else
    checkxy(x, y, mfilename, 'X', 'Y', 1, 2)
    [first, last] = findFirstLastNonNan(x);
    numParts = numel(first);
    if isrow(x)
        tf = false(1,numParts);
    else
        tf = false(numParts,1);
    end
    for k = 1:numParts
        s = first(k);
        e = last(k);
        tf(k) = isContourClockwise(x(s:e), y(s:e));
    end
end

%----------------------------------------------------------------------
function tf = isContourClockwise(x, y)
[x, y] = removeDuplicates(x, y);
if numel(x) > 2
    tf = (signedArea(x, y) <= 0);    
else
    tf = true;
end

%----------------------------------------------------------------------
function [x, y] = removeDuplicates(x, y)
is_closed = (x(1) == x(end)) && (y(1) == y(end));
if is_closed
    x(end) = [];
    y(end) = [];
end

dups = [false; (diff(x(:)) == 0) & (diff(y(:)) == 0)];
x(dups) = [];
y(dups) = [];

%----------------------------------------------------------------------
function a = signedArea(x, y)
x = x - mean(x);
n = numel(x);
if n <= 2
    a = 0;
else
    i = [2:n 1];
    j = [3:n 1 2];
    k = (1:n);
    a = sum(x(i) .* (y(j) - y(k)));
end
