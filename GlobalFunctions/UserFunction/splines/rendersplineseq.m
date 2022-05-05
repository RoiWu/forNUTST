% varargin is of the form
% examplespline1 splinedata1 examplespline2 splinedata2 ...
function rendersplineseq(path, nums, video, varargin )
renderseq(@displayer, video, path, nums,varargin{:});


function h = displayer(i, path, nums, varargin)

if i>=length(nums)
  h  = [];
  return
end

if ~isempty(path)
  im = readimages(path,nums(i));
  imagesc(im);
end

h = [];

for j=1:2:length(varargin)
  examplespline = varargin{j};
  seq = reshape(varargin{j+1}(:,i),2,[]);

  bi = 1;
  for k=1:length(examplespline)
    sz = size(examplespline(k).X,2);
    examplespline(k).X(:,1:sz) = seq(:,bi:bi+sz-1);
    bi = bi+sz;
  end
  h = [h drawsplines(examplespline)];
end
