function [pixel_mask] = convertmasktopixel(pixel_polygondata, flag_plotpixelmask)
polygondata = pixel_polygondata.polygondata;
box_simulregion = pixel_polygondata.box_simulregion;

L_simulregion = box_simulregion(1);
R_simulregion = box_simulregion(2);
B_simulregion = box_simulregion(3);
T_simulregion = box_simulregion(4);

grid_size = pixel_polygondata.grid_size;
npointcorner = pixel_polygondata.npointcorner;
corner_radius = pixel_polygondata.corner_radius;
flag_transparancy = pixel_polygondata.flag_transparancy;
  
Xvec = L_simulregion:grid_size(1):R_simulregion;
Yvec = B_simulregion:grid_size(2):T_simulregion;

phi = zeros(length(Yvec),length(Xvec));
[X_grid,Y_grid] = meshgrid(Xvec,Yvec);
X_grid = reshape(X_grid,size(X_grid,1)*size(X_grid,2),1);
Y_grid = reshape(Y_grid,size(Y_grid,1)*size(Y_grid,2),1);
    
for ipoly = 1:length(polygondata)
  poly_xy = polygondata{ipoly};
  
  if ~(sum(poly_xy(end, :) == poly_xy(1,:)) ~= 2)
    poly_xy = poly_xy(1:end-1,:);
  end
  
  poly_xy = roundcorner(poly_xy, 'rad', corner_radius, 'nrad', npointcorner);
  [in,~] = inpolygon(X_grid,Y_grid,poly_xy(:,1),poly_xy(:,2));
  phi(in) = 1;
%   index_boundary = find(X_grid(index_on)==L_simulregion|X_grid(index_on)==R_simulregion);
%   on(index_on(index_boundary)) = 0;
%   index_boundary = find(Y_grid(index_on)==T_simulregion|Y_grid(index_on)==B_simulregion);
%   on(index_on(index_boundary)) = 0;
%   phi(on) = 0;
end

pixel_mask = phi;

if ~flag_transparancy
  pixel_mask = not(pixel_mask);
end

if flag_plotpixelmask
  figure1 = figure('Name','Pixelated Mask');
  movegui(figure1,'center');
  axes1 = axes('Parent',figure1);
  hold(axes1,'on');
  imagesc(Xvec,Yvec,pixel_mask);
  colormap('gray');
  axis equal;
  xlim(axes1,[L_simulregion R_simulregion]);
  ylim(axes1,[B_simulregion T_simulregion]);

  box(axes1,'on');
  set(axes1,'Layer','top');
end

end

