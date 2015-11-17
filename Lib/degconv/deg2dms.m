function dms=deg2dms(deg)
% convert decimal degrees to degrees-minutes-seconds
% Inputs: 
%    deg : nx1/1xn vector of angles in decimal degrees (degree)
% Outputs: 
%    dms : nx3 [d m s] array of angles
%       d : nx1 vector of degrees (degree)
%       m : nx1 vector of minutes (minute)
%       s : nx1 vector of seconds (second)
% Author: 
%    Taro Suzuki (gnsssdrlib<at>gmail.com)

d = fix(deg);
m = fix((deg-d)*60);
s = ((deg-d)*60-m)*60;
if size(deg,1)>size(deg,2)
    dms = [d m s];
else    
    dms = [d' m' s'];
end