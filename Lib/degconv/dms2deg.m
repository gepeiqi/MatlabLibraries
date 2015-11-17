function deg = dms2deg(dms)
% convert degrees-minutes-seconds to decimal degrees
% Inputs: 
%    dms : nx3 [d m s] array of angles
%       d : nx1 vector of degrees (degree)
%       m : nx1 vector of minutes (minute)
%       s : nx1 vector of seconds (second)
% Outputs:
%    deg : nx1 vector of angles in decimal degrees (degree)
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

d = dms(:,1);
m = dms(:,2);
s = dms(:,3);
deg = abs(d)+abs(m)./60+abs(s)./3600;
ind = (d<0 | m<0 | s<0);
deg(ind) = -deg(ind);
