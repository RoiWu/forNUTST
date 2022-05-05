% Example from GridBagLayout
function GridLayoutDemo8()

clc;
Parent = figure( ...
    'MenuBar', 'none', ...
    'NumberTitle', 'off', ...
    'Name', 'GridLayout: example from GridBagLayout');

% Define layout
Layout = GridLayout(Parent,'ColWidth',{80,'*',80,80},'RowHeight',{20,20,20,'*'},'Gap',5);
MergeCells(Layout,[2 4],[1 3]);
% Adding children
uicontrol(Layout.Cell(1,1),'style','text','string','Item Name:');
uicontrol(Layout.Cell(2,1),'style','listbox');
uicontrol(Layout.Cell(1,2),'style','edit','BackgroundColor','w');
uicontrol(Layout.Cell(1,3),'style','pushbutton','string','Find');
uicontrol(Layout.Cell(2,4),'style','pushbutton','string','Remove');
uicontrol(Layout.Cell(3,4),'style','pushbutton','string','Add...');

Update(Layout);
