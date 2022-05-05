function [semilist,semisup] = annotate2(ipath, nums, semisup)

if ~exist('semisup','var')
    semisup = get(gcf,'UserData');
end
if isempty(semisup) || (length(semisup)<length(nums))
    semisup = cell(1,length(nums));
end

set(gcf,'UserData',semisup);
clf

% this sets up spltool's handlers.
spltool('init');
annotate_kph('init',[],ipath,nums);


set(gcf,'KeyPressFcn', {@annotate_kph,ipath,nums});

uiwait;
semisup = get(gcf,'UserData');
semilist = makesemilist(semisup);
end




function annotate_kph(src,ev,ipath, nums)
persistent copyspline ud i;

if isempty(i)
  i = 1;
end

istep = 0;

semisup = get(gcf,'UserData');

key = get(gcf,'CurrentCharacter');
if strcmp(src,'init')
    key = '';
    i = 1;
end
switch key
 case {'[',']'},
  % skip forward or ahead 1
  istep = 1+(key-']');
 case {'{','}'},
  % skip forward or ahead 10
  istep = 10*(1+(key-'}'));
 case '('
  % find closest keyframe backward.
  istep = istep-1;
  while i+istep>1,
    istep = istep-1;
    if ~isempty(semisup{i+istep})
      break;
    end
  end
 case ')'
  % find closest keyframe forward.
  while i+istep<length(nums),
    istep = istep+1;
    if ~isempty(semisup{i+istep}),
      break;
    end
  end
 case 'q'
  % quit.
  spltool('quit');
  istep = -inf;
 case ' ',
  % clear this frame.
  semisup{i} = [];
  spltool('modify', semisup{i});
 case 'C',
  % copy this frame.
  copyspline = semisup{i};
 case 'p',
  % paste the spline in the copy buffer to this frame.
  semisup{i} = copyspline;
  spltool('modify', semisup{i});
 case 'l',
  % paste the last edit spline to this frame.
  semisup{i} = ud;
  spltool('modify', semisup{i});
 otherwise,
  spltool('key', key);
end



if (istep~=0) || strcmp(src,'init')
  semisup{i} = spltool('save');
  if ~isempty(semisup{i})
      ud = semisup{i};
  end

  i = i+istep;
  i = max(i,1);
  i = min(length(nums),i);

  %im = readimages(ipath,nums(i));
  im = imread(sprintf(ipath,nums(i)));
  spltool('bgimg',im);
  title(sprintf('%d',i));

  spltool('modify', semisup{i});
end

set(gcf,'UserData',semisup);
end
