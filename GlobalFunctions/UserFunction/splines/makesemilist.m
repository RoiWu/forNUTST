function semilist = makesemilist(semisup)
semilist = [];
for i =1:length(semisup)
  if ~isempty(semisup{i})
    semilist(end+1).n = i;
    v = cat(2,semisup{i}.X);
    semilist(end).v = v(:);
  end
end
