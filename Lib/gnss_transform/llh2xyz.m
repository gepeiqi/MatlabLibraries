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

