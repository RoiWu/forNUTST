% Column/row sizing options
function GridLayoutDemo3()

clc;
Parent = figure( ...
    'MenuBar', 'none', ...
    'NumberTitle', 'off', ...
    'Name', 'GridLayout: column/row sizing options');

% The cell sizes can be specified as absolute or proportional.
% RowHeight and ColWidth can be one of the following:
% - numeric: absolute value in pixels
% - 'X*':    proportional, where X = weight; '*' means '1*'
% The absolute sizes are allocated first and the remaining space is
% allocated among the proportional sizes. The default size is '*'.
% If RowHeight is specified as a cell vector NumRows is not needed
% If ColWidth  is specified as a cell vector NumCols is not needed
Layout = GridLayout(Parent, ...
    'RowHeight', {40,40,40,'*'}, ... First 3 rows of fixed height!
    'ColWidth', {'*','*','*','4*'}, ... Last column wider!
    'CellMargin', 5, ...
    'CellColor', 'y');

% Adding children
UIArgs = {'Style','pushbutton', 'String','Click'};
for RIdx = 1:Layout.NumRows
    for CIdx = 1:Layout.NumCols
        Parent = Layout.Cell(RIdx,CIdx);
        uicontrol(Parent, UIArgs{:});
    end
end

Update(Layout);
