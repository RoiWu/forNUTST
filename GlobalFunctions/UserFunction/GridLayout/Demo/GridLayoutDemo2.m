% Alignment options
function GridLayoutDemo2()

Parent = figure( ...
    'MenuBar', 'none', ...
    'NumberTitle', 'off', ...
    'Name', 'GridLayout: alignment options');

Layout = GridLayout(Parent, ...
    'NumRows', 4, ...
    'NumCols', 4, ...
    'CellMargin', 5, ...
    'CellColor', 'y');

% Adding children
UIArgs = {'Style','pushbutton', 'String','Click'};
for RIdx = 1:Layout.NumRows
    for CIdx = 1:Layout.NumCols
        HAlign = {'Stretch','Left','Right','Center'};
        VAlign = {'Stretch','Top','Bottom','Center'};

        FormatCells(Layout, RIdx, CIdx, ...
            'HAlign', HAlign{RIdx}, ...
            'VAlign', VAlign{CIdx});

        Parent = Layout.Cell(RIdx,CIdx);
        uicontrol(Parent, UIArgs{:});
    end
end

Update(Layout);
