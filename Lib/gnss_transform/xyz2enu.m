function [enu R] = xyz2enu(xyz,orgxyz)
% transform ecef position to local tangental coordinate
% Inputs: 
%    xyz    : 3xn ecef vector [x;y;z] (m)
%    orgxyz : 3x1 enu origin in ecef coordinate [x;y;z] (m)
% Outputs: 
%    enu    : 3xn local enu vector [east;north;up] (m)
%    R      : 3x3 ecef to local enu transformation matrix
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

n = size(xyz,2);
difxyz = xyz-repmat(orgxyz,1,n);

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
enu = R*difxyz;
