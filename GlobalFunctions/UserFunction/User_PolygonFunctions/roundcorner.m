function pos = roundcorner( pos, varargin )

%%  input parameters and default values
for i = 1 : 2 : length( varargin )
  switch varargin{ i }
    case 'rad' 
      rad = varargin{ i + 1 };
    case 'nrad'
      nrad = varargin{ i + 1 };
    case 'edge'
      edge = varargin{ i + 1 };
  end
end

if ~exist(  'rad', 'var' );  rad = 0.1 * max( abs( pos( : ) ) );  end
if ~exist( 'nrad', 'var' );  nrad = 5;                            end
if ~exist( 'edge', 'var' );  edge = 1 : size( pos, 1 );           end

%%  find centers of circles (for rounding)
norm = @( v ) ( v ./ repmat( sqrt( sum( v .^ 2, 2 )  ), 1, 2 ) );

dist = circshift(pos, [-1, 0])-pos;
vec = norm(dist);
dir = norm(vec-circshift(vec, [1, 0]));

% >> remove multiple point on the line edges
index_dir = any(isnan(dir),2);
dir(index_dir,:) = [];
vec(index_dir,:) = [];
pos(index_dir,:) = [];

dist = circshift( pos, [ - 1, 0 ] ) - pos;
L_dist = sqrt(sum(dist.^2,2));
min_dist = (min(L_dist,circshift( L_dist, [1, 0 ] )))/2;

new_rad = repmat(min(min_dist,rad),1,2);
beta = acos( sum( circshift( vec, [ 1, 0 ] ) .* vec, 2 ) ) / 2;
zero = pos + new_rad.* dir ./ cos( [ beta, beta ] );

xv = [ pos( :, 1 )', pos( 1, 1 ) ];
yv = [ pos( :, 2 )', pos( 1, 2 ) ];

sgn = fix( inpolygon( zero( :, 1 )', zero( :, 2 )', xv, yv ) );
sgn( sgn == 0 ) = - 1;

%%  put together positions
sav = pos;
pos = [];
rot = @( phi ) ( [ cos( phi ), sin( phi ); - sin( phi ), cos( phi ) ] );

for i = 1 : size( zero, 1 )
  if isempty( find( i == edge, 1 ) )
    pos = [ pos; sav( i, : ) ];
  else
    if abs( beta( i ) ) < 1e-3
      angle = 0;
    else
      angle = beta( i ) * linspace( - 1, 1, nrad ) * sgn( i );
    end
    for phi = angle
      pos = [ pos; zero( i, : ) - new_rad(i,:).* dir( i, : ) * rot( phi ) ];
    end
  end
end


