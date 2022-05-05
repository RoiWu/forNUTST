function [first, last] = findFirstLastNonNan(x)
n = isnan(x(:));

firstOrPrecededByNaN = [true; n(1:end-1)];
first = find(~n & firstOrPrecededByNaN);

lastOrFollowedByNaN = [n(2:end); true];
last = find(~n & lastOrFollowedByNaN);
