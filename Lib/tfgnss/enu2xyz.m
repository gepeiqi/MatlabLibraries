function xyz = enu2xyz(enu,orgxyz)
% transform local tangental coordinate vector to ecef
% Inputs: 
%    enu    : 3xn local enu vector [east;north;up] (m)
%    orgxyz : 3x1 enu origin in ecef coordinate [x;y;z] (m)
% Outputs: 
%    xyz    : 3xn ecef vector [x;y;z] (m)
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

n = size(enu,2);

orgllh = xyz2llh(orgxyz);
phi = orgllh(1)/180*pi;
lam = orgllh(2)/180*pi;
sinphi = sin(phi);
cosphi = cos(phi);
sinlam = sin(lam);
coslam = cos(lam);
R = [ -sinlam          coslam         0     ;
      -sinphi*coslam  -sinphi*sinlam  cosphi;
       cosphi*coslam   cosphi*sinlam  sinphi];
difxyz = R\enu;
xyz = difxyz+repmat(orgxyz,1,n);
