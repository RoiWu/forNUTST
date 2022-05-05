function [x3, y3] = polybool(operation, x1, y1, x2, y2, varargin)
if (nargin >= 6)
    % Check for obsolete 'cutvector', 'cell', and 'vector' options.
    errorOnObsoleteSyntax(varargin{1})
end

operation = validateSetOperationName(operation);

cellInput = iscell(x1) || iscell(y1) || iscell(x2) || iscell(y2);
if ~any(cellInput)
    [x3, y3] = polygonSetOperation(operation, x1, y1, x2, y2);
else
    [x3, y3] = polygonSetOperationCells(operation, x1, y1, x2, y2);
end

%-----------------------------------------------------------------

function [x3, y3] = polygonSetOperation(operation, x1, y1, x2, y2)
operation = validatestring(operation, {'int','union','xor','diff'});

checkxy(x1, y1, mfilename, 'X1', 'Y1', 2, 3)
checkxy(x2, y2, mfilename, 'X2', 'Y2', 2, 3)

[x3, y3, emptyInput] = handleEmptyInputs(operation, x1, y1, x2, y2);
if ~emptyInput
    p1 = vectorsToGPC(x1, y1, mfilename, 'X1', 'Y1');
    p2 = vectorsToGPC(x2, y2, mfilename, 'X2', 'Y2');
    
    p3 = gpcmex(operation, p1, p2);
    
    [x3, y3] = vectorsFromGPC(p3);
    
    rowVectorInput = (size(x1,2) > 1);
    if ~isempty(x3) && rowVectorInput
        x3 = x3';
        y3 = y3';
    end
end

%-----------------------------------------------------------------

function [x3, y3] = polygonSetOperationCells(operation, x1, y1, x2, y2)   
if iscell(x1)
    rowVectors = ~isempty(x1) && (ndims(x1{1}) == 2) && (size(x1{1}, 1) == 1);
    rowCellVectors = (ndims(x1) == 2) && (size(x1, 1) == 1);
    
    assertNonNan(x1)
    assertNonNan(y1)
    [x1, y1] = polyjoin(x1, y1);
else
    rowVectors = (ndims(x1) == 2) && (size(x1, 1) == 1);
    rowCellVectors = false;
    x1 = x1(:);
    y1 = y1(:);
end

if iscell(x2)
    assertNonNan(x2)
    assertNonNan(y2)
    [x2, y2] = polyjoin(x2, y2);
end

[x3, y3] = polygonSetOperation(operation, x1, y1, x2, y2);

if rowVectors
    x3 = x3';
    y3 = y3';
end

[x3, y3] = polysplit(x3,y3);

if rowCellVectors
    x3 = x3';
    y3 = y3';
end

%-----------------------------------------------------------------------

function operation = validateSetOperationName(operation)
% If possible, convert the string OPERATION to a standard set operation
% string accepted by gpcmex: 'int', 'union', 'xor', or 'diff'. The result
% is case-insensitive with respect to the input string.

if ~ischar(operation)
    error(['map:' mfilename ':invalidOpFlag'], ...
        ['Function %s expected its first argument to be a string', ...
        ' specifying a polygon set operation.'], mfilename)
end

valid    = 1; % Put valid strings in column 1 of cell array "strings"
standard = 2; % Put standard strings in column 2

strings = {...
    'intersection', 'int'; ...
    'and',          'int'; ...
    '&',            'int'; ...
    'union',        'union'; ...
    'or',           'union'; ...
    '|',            'union'; ...
    '+',            'union'; ...
    'plus',         'union'; ...
    'exclusiveor',  'xor'; ...
    'xor',          'xor'; ...
    'subtraction',  'diff'; ...
    'minus',        'diff'; ...
    '-',            'diff'};

% Try to find a match in column 1.
match = strcmpi(operation, strings(:,valid));
if ~any(match)
   error(['map:' mfilename ':unrecognizedOp'], ...
         'Unrecognized set operation: ''%s''.', operation)
end

% If a match is found, return the value in column 2.
operation = strings{match, standard};

%-----------------------------------------------------------------------

function assertNonNan(c)
% Error if any element of the cell array C contains a NaN

assert(~any(cellfun(@(v) any(isnan(v(:))), c)), ...
    ['map:' mfilename ':cellNaNCombo'], ...
    ['%s no longer supports combining the cell array', ...
    ' and NaN-separated vector format.  Use %s if', ...
    ' necessary to create a cell array in which each cell', ...
    ' contains the coordinates for a single polygonal contour.'], ...            
    'POLYBOOL', 'POLYSPLIT')

%-----------------------------------------------------------------------

function [x3, y3, emptyInput] = handleEmptyInputs(operation, x1, y1, x2, y2)
% Assuming that x1 and y1, and x2 and y2, are pairs of inputs having
% consistent sizes, return the appropriate values for x3 and y3 in the
% event that x1 and/or x2 are empty (or contain only NaN), and set
% emptyInput to true. Otherwise, set x3 and y3 to empty and set
% emptyInput to false. Operation has been validated and equals one of
% the following strings: 'int','union','xor','diff'.

% NaN-only arrays should behave the same way as empty arrays, so filter
% them up-front. Be careful, because all(isnan([])) evaluates to true.
% Also, be careful to preserve shape: return 1-by-0 given a row
% vector of NaN and a 0-by-1 given a column vector of NaN.
if  all(isnan(x1)) && ~isempty(x1)
    x1(1:end) = [];
    y1(1:end) = [];
end

if all(isnan(x2)) && ~isempty(x2)
    x2(1:end) = [];
    y2(1:end) = [];
end

if isempty(x2)
    if strcmp(operation,'int')
        % Intersection is empty, but preserve shape
        % by using x2 and y2 rather than [].
        x3 = x2;
        y3 = y2;
    else
        % Union, exclusive or, or difference with
        % empty leaves x1 and y1 unaltered.
        x3 = x1;
        y3 = y1;
    end
    emptyInput = true;
elseif isempty(x1)
    if any(strcmp(operation,{'int','diff'}))
        % Intersection or difference is empty, but preserve
        % shape by using x1 and y1 rather than [].
        x3 = x1;
        y3 = y1;        
    else
        % Union or exclusive or with empty leaves x2 and y2 unaltered.
        x3 = x2;
        y3 = y2;
    end
    emptyInput = true;
else
    x3 = [];
    y3 = [];
    emptyInput = false;
end

%-----------------------------------------------------------------------

function errorOnObsoleteSyntax(arg6)

if isequal(arg6, 'cutvector')
    error(['map:' mfilename ':cutVectorSyntax'], ...
        ['Because the ''%s'' option does not handle some types of polygonal', ...
        ' regions well, it is no longer supported.  See the %s documentation', ...
        ' for examples illustrating how to use %s and %s to plot polygonal', ...
        ' regions with holes and disjoint regions.'], ...
        'cutvector', 'POLYBOOL', 'POLY2FV', 'PATCH')
elseif (isequal(arg6, 'cell') || isequal(arg6, 'vector'))
    error(['map:' mfilename ':oldSyntax'], ...
        ['%s no longer supports the ''%s'' or ''%s'' options.', ...
        ' Instead, %s returns the outputs in the same format as the', ...
        ' inputs.  Use %s and %s to convert between cell and', ...
        ' vector format for polygons.'], ...
        'POLYBOOL', 'cell', 'vector', 'POLYBOOL', 'POLYSPLIT', 'POLYSPLIT')
else
    error(['map:' mfilename ':wrongNumArgs'], ...
        'Incorrect number of input arguments.')
end
