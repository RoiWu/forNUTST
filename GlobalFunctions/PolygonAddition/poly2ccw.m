function [x2, y2] = poly2ccw(x1, y1)
input_is_cell = iscell(x1);
if ~input_is_cell
   checkxy(x1, y1, mfilename, 'X1', 'Y1', 1, 2)
   input_is_row = (size(x1, 1) == 1);
   [x1, y1] = polysplit(x1, y1);
end

x2 = x1;
y2 = y1;

for k = 1:numel(x1)
   if ispolycw(x2{k}, y2{k})
      x2{k} = x2{k}(end:-1:1);
      y2{k} = y2{k}(end:-1:1);
   end
end

if ~input_is_cell
   [x2, y2] = polyjoin(x2, y2);
   if input_is_row
      x2 = x2';
      y2 = y2';
   end
end
