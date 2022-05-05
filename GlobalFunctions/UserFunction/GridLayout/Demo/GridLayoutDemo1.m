% Basic example
function GridLayoutDemo1()

% GUI figure
Parent = figure( ...
    'MenuBar', 'none', ...
    'NumberTitle', 'off', ...
    'Name', 'GridLayout: basic example');

% At least the number of rows and columns must be specified. By default all
% cells have the same width and height. First index is the row index.
% Second index is the column index. Index (1,1) is the upper left cell.
Layout = GridLayout(Parent, ...
    'NumRows', 4, ...
    'NumCols', 4, ...
    'CellMargin', 5, ... For debug!
    'CellColor', 'y'); ... For debug!

% The cells are uicontainer objects whose handles are exposed through the
% read-only member array 'Cell'. In order to populate a cell you need to
% pass this handle as a parent during the child control instantiation.
% No Add methods are necessary!

% By default the children are stretched horizontally and vertically to fit
% the entire cell. Other alignments are also supported. See next demos.

% Adding children
UIArgs = {'Style','pushbutton', 'String','Click'};
for RIdx = 1:Layout.NumRows
    for CIdx = 1:Layout.NumCols
        Parent = Layout.Cell(RIdx,CIdx);
        uicontrol(Parent, UIArgs{:});
    end
end

Update(Layout);
