function llh = xyz2llh(xyz)
% transform ecef position to geodetic position
% Inputs: 
%    xyz : 3xn ecef vector [x;y;z] (m)
% Outputs: 
%    llh : 3xn llh vector [lat;lon;h] (degree,m)
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

a = 6378137.0000;	% earth radius in meters	(WGS84)
b = 6356752.3142;	% earth semiminor in meters	(WGS84)

x2 = xyz(1,:).^2;
y2 = xyz(2,:).^2;
z2 = xyz(3,:).^2;

e = sqrt(1-(b/a)^2);
b2 = b*b;
e2 = e^2;
ep = e*(a/b);
r = sqrt(x2+y2);
r2 = r.*r;
E2 = a^2-b^2;
F = 54*b2*z2;
G = r2+(1-e2)*z2-e2*E2;
c = (e2*e2*F.*r2)./(G.*G.*G);
s = (1+c+sqrt(c.*c+2*c)).^(1/3);
P = F./(3*(s+1./s+1).^2.*G.*G);
Q = sqrt(1+2*e2*e2*P);
ro = -(P.*e2.*r)./(1+Q)+sqrt((a.*a/2).*(1+1./Q)-(P.*(1-e2).*z2)./(Q.*(1+Q))-P.*r2/2);
tmp = (r-e2*ro).^2;
U = sqrt(tmp+z2);
V = sqrt(tmp+(1-e2).*z2);
zo = (b2*xyz(3,:))./(a*V);

llh(3,:) = U.*(1-b2./(a*V)); % ellipsoidal height
llh(1,:) = atan((xyz(3,:)+ep*ep*zo)./r)/pi*180; % latitude [degree]

% longitude [degree]
llh(2,:) = atan(xyz(2,:)./xyz(1,:))/pi*180;
ind = xyz(1,:)<0 & xyz(2,:)>=0;
llh(2,ind) = llh(2,ind)+180;
ind = xyz(1,:)<0 & xyz(2,:)<0;
llh(2,ind) = llh(2,ind)-180;