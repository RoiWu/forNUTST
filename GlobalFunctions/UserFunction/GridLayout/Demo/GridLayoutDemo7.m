% Support for axes and legends
function GridLayoutDemo7()

clc;
Parent = figure( ...
    'MenuBar', 'none', ...
    'NumberTitle', 'off', ...
    'Name', 'GridLayout: support for axes and legends');

% Define layout
Layout = GridLayout(Parent,'RowHeight',{'*','*'},'Gap',10,'CellColor','y');
GridLayout.FormatCell(Layout.Cell(1), ...
    'LMargin',55,'RMargin',15,'TMargin',25,'BMargin',40);

% Adding children
A(1) = axes('Parent',Layout.Cell(1),'ActivePositionProperty','Position');
A(2) = axes('Parent',Layout.Cell(2),'ActivePositionProperty','OuterPosition');

x = linspace(0,1,256);
xp = [x; x+.01; x+.02];
Args = {x,sin(xp*4*pi),'LineWidth',2,'DisplayName',{'Line 1','Line 2','Line 3'}};

plot(A(1),Args{:}); legend(A(1),'toggle'); grid(A(1)); xlabel(A(1),'X'); ylabel(A(1),'sin(X)'); title(A(1),'ActivePositionProperty = Position');
plot(A(2),Args{:}); legend(A(2),'toggle'); grid(A(2)); xlabel(A(2),'X'); ylabel(A(2),'sin(X)'); title(A(2),'ActivePositionProperty = OuterPosition');

Update(Layout);
