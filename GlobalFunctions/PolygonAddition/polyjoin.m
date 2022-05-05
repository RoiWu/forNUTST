function [lat,lon] = polyjoin(latcells,loncells)
if isempty(latcells) && isempty(loncells)
    lat = reshape([], [0 1]);
    lon = lat;
else
    validateattributes(latcells,{'cell'},{'vector'},mfilename,'LATCELLS',1)
    validateattributes(loncells,{'cell'},{'vector'},mfilename,'LONCELLS',2)
    
    assert(isequal(size(latcells),size(loncells)), ...
        'map:polyjoin:cellvectorSizeMismatch', ...
        '%s and %s must match in size.', ...
        'LATCELLS', 'LONCELLS')
    
    latSizes = cellfun(@size, latcells, 'UniformOutput', false);
    lonSizes = cellfun(@size, loncells, 'UniformOutput', false);
    
    assert(isequal(latSizes,lonSizes), ...
        'map:polyjoin:cellContentSizeMismatch', ...
        'Contents of corresponding cells in %s and %s must match in size.', ...
        'LATCELLS', 'LONCELLS')
    
    M = numel(latcells);
    N = 0;
    for k = 1:M
        N = N + numel(latcells{k});
    end
    
    lat = zeros(N + M - 1, 1);
    lon = zeros(N + M - 1, 1);
    p = 1;
    for k = 1:(M-1)
        q = p + numel(latcells{k});
        lat(p:(q-1)) = latcells{k};
        lon(p:(q-1)) = loncells{k};
        lat(q) = NaN;
        lon(q) = NaN;
        p = q + 1;
    end
    if M > 0
        lat(p:end) = latcells{M};
        lon(p:end) = loncells{M};
    end
end
