function enu = llh2enu(llh,orgllh)
% transform geodetic position to local tangental coordinate
% Inputs: 
%    llh    : 3xn llh vector [lat;lon;h] (degree,m)
%    orgllh : 3x1 enu origin in geodetic coordinate [lat;lon;h] (degree,m)
% Outputs: 
%    enu    : 3xn local enu vector [east;north;up] (m)
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

xyz = llh2xyz(llh);
orgxyz = llh2xyz(orgllh);
enu = xyz2enu(xyz,orgxyz);
end

function xyz = llh2xyz(llh)
% transform geodetic position to ecef position
% Inputs: 
%    llh : 3xn llh vector [lat;lon;h] (degree,m)
% Outputs: 
%    xyz : 3xn ecef vector [x;y;z] (m)
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

a = 6378137.0000;	% earth radius in meters	(WGS84)
b = 6356752.3142;	% earth semiminor in meters	(WGS84)
e = sqrt(1-(b/a)^2);

sinphi = sin(llh(1,:)/180*pi);
cosphi = cos(llh(1,:)/180*pi);
coslam = cos(llh(2,:)/180*pi);
sinlam = sin(llh(2,:)/180*pi);
tan2phi = (tan(llh(1,:)/180*pi)).^2;
tmp = 1-e*e;
tmpden = sqrt(1+tmp*tan2phi);

xyz(1,:) = (a*coslam)./tmpden+llh(3,:).*coslam.*cosphi;
xyz(2,:) = (a*sinlam)./tmpden+llh(3,:).*sinlam.*cosphi;
xyz(3,:) = (a*tmp.*sinphi)./sqrt(1-e*e.*sinphi.*sinphi)+llh(3,:).*sinphi;

end

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
end