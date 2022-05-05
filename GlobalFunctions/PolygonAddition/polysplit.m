function [latcells,loncells] = polysplit(lat,lon)
if isempty(lat) && isempty(lon)
    latcells = reshape({}, [0 1]);
    loncells = latcells;
else
    validateattributes(lat,{'numeric'},{'real','vector'},mfilename,'LAT',1)
    validateattributes(lon,{'numeric'},{'real','vector'},mfilename,'LON',2)
    
    [lat, lon] = removeExtraNanSeparators(lat, lon);
    
    % Find NaN locations.
    indx = find(isnan(lat(:)));
    
    % Simulate the trailing NaN if it's missing.
    if ~isempty(lat) && ~isnan(lat(end))
        indx(end+1,1) = numel(lat) + 1;
    end
    
    %  Extract each segment into pre-allocated N-by-1 cell arrays, where N is
    %  the number of polygon segments.  (Add a leading zero to the indx array
    %  to make indexing work for the first segment.)
    N = numel(indx);
    latcells = cell(N,1);
    loncells = cell(N,1);
    indx = [0; indx];
    for k = 1:N
        iStart = indx(k)   + 1;
        iEnd   = indx(k+1) - 1;
        latcells{k} = lat(iStart:iEnd);
        loncells{k} = lon(iStart:iEnd);
    end
end
