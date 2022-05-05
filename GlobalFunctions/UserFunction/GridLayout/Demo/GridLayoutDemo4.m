% Merging and removing cells
function GridLayoutDemo4()

clc;
Parent = figure( ...
    'MenuBar', 'none', ...
    'NumberTitle', 'off', ...
    'Name', 'GridLayout: merging and removing cells');

Layout = GridLayout(Parent, ...
    'NumRows', 4, ...
    'NumCols', 4, ...
    'CellMargin', 5, ...
    'CellColor', 'y');

% Merging cells
% Arguments:
%   1: Row range
%   2: Column range
% The range can be one of:
%   Integer, e.g. 2
%   Range, e.g. [2 4]
%   Empty, in which case the merging is performed over all rows/columns
% In the merged range only the upper left cell survives. All others are
% removed.
MergeCells(Layout, [1 2], [1 2]);
MergeCells(Layout, 3, [1 3]);
MergeCells(Layout, 4, []);

% Removing cells
% Arguments are identical to MergeCells.
% Removing cells is not strictly necessary but is saves some calls to the
% cell-resize callback.
RemoveCells(Layout, 1, [3 4]);

% Adding children
UIArgs = {'Style','text', 'String','Click'};
for RIdx = 1:Layout.NumRows
    for CIdx = 1:Layout.NumCols
        Parent = Layout.Cell(RIdx,CIdx);
        if ~ishghandle(Parent)
            continue; % Skip removed cells!
        end
        uicontrol(Parent, UIArgs{:});
    end
end

Update(Layout);
