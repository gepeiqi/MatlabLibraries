function h = plot_height_map(vx,vy,vz,tri)

if nargin==3      
    tri = delaunay(vx,vy);
end

h = trimesh(tri,vx,vy,vz);
colorbar;
% set(gca,'DataAspectRatio',[1 1 1]);
% axis equal;
set(h,'linestyle','none');
set(h,'Marker','.');
set(h,'MarkerSize',5);
hidden off;
