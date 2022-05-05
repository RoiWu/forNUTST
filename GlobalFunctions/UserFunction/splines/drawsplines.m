function hs = drawsplines(uds)

hs = [];
for j = 1:length(uds)
  hs = [hs drawspline(uds(j))];
end
orderlayers
