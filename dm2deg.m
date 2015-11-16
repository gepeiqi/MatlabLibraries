function deg = dm2deg(dm)
% convert degrees-minutes to decimal degrees
% Inputs: 
%    dms : nx1 [ddmm.m] vector or nx2 [dd mm.m] array
%       d : nx1 vector of degrees (degree)
%       m : nx1 vector of minutes (minute)
% Outputs:
%    deg : nx1 vector of angles in decimal degrees (degree)
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

if size(dm,2)==2
    d = dm(:,1);
    m = dm(:,2);
else
    d = fix(dm/100);
    m = dm-100*d;
end
deg = d+m/60;