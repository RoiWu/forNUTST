% Defining gaps and margins
function GridLayoutDemo5()

clc;
Parent = figure( ...
    'MenuBar', 'none', ...
    'NumberTitle', 'off', ...
    'Name', 'GridLayout: defining gaps and margins');

% All spacing parameters are expressed in pixels!

% GridLayout has the following spacing parameters
%   VGap   : vertical spacing between cells
%   HGap   : horizontal spacing between cells
%   LMargin: spacing between cell area and parent left   (default: VGap)
%   RMargin: spacing between cell area and parent right  (default: VGap)
%   TMargin: spacing between cell area and parent top    (default: HGap)
%   BMargin: spacing between cell area and parent bottom (default: HGap)
% Alternatively, the following parameters can be used as syntactic sugar:
%   Gap,    when HGap == VGap
%   Margin, when LMargin == RMargin == TMargin == BMargin
% Margin parameters can also be defined for the cells. The default values
% are specified as parameters of GridLayout. All cell parameters can be
% specified by prefixing them with the string 'Cell'. One example you
% already know is CellColor.
Layout = GridLayout(Parent, ...
    'NumRows', 4, ...
    'NumCols', 4, ...
    'HGap', 10, ...
    'VGap', 5, ...
    'Margin', 20, ...
    'CellMargin', 10, ...
    'CellColor', 'y');

% Customization of individual cells or ranges of cells is performed using 
% the FormatCell method, which has been already introduced.
% The following are the possible cell properties:
%   HAlign, VAlign
%   Margin, LMargin, RMargin, TMargin, BMargin
%   Color

% Adding children
UIArgs = {'Style','pushbutton', 'String','Click'};
for RIdx = 1:Layout.NumRows
    for CIdx = 1:Layout.NumCols
        Parent1 = Layout.Cell(RIdx,CIdx);
        uicontrol(Parent1, UIArgs{:});
    end
end


Update(Layout);
% hh = Layout.WrapCell(1,1);
p = Layout.findprop(Layout,'Enable');
A= 1;
% set( findall(Layout, '-property', 'Enable'), 'Enable', 'on');
