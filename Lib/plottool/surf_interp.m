function surf_interp(X,Y,GriddedInterPolantObj,resolution)
if nargin ==3
    resolution=100;
end
xlin = linspace(min(X),max(X),resolution);
ylin = linspace(min(Y),max(Y),resolution);
[x,y] = meshgrid(xlin,ylin);
surf(x,y,GriddedInterPolantObj(x,y));
end