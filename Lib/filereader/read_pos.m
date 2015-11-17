function pos = read_pos01(varargin)

% filename = 'rov101.pos';
interval = 0;
filename = varargin{1};
if size(varargin,2) == 2
    interval = varargin{2};
end

fp = fopen(filename, 'r');
n = 23;
lcn = 0;
while(1)
    line = fgetl(fp);
    lcn = lcn+1;
    if strfind(line,'ratio')
        break;
    elseif strfind(line, 'obs start')
        wind = strfind(line, 'week');
        sind = strfind(line, 's');
        sind = sind(end);
        ssec = str2num(line(wind+9:sind-1));
    elseif strfind(line, 'obs end')
        wind = strfind(line, 'week');
        sind = strfind(line, 's');
        sind = sind(end);
        esec = str2num(line(wind+9:sind-1));
    end
end

data_cell = textscan(fp,'%f/%f/%f %f:%f:%f %f %f %f %f %f %f %f %f %f %f %f %f %f');

% T“ª‚©‚ç‚Ì“ú”‚ðŽZo -> wd
date = [data_cell{1} data_cell{2} data_cell{3} data_cell{4} data_cell{5} data_cell{6}];
date_sir = datenum(date);
wd = weekday(date_sir);

% ‘ªˆÊ—¦‚ÌŒvŽZ
if interval
    Rmax = length(data_cell{1})/((esec - ssec)*(1/interval));
end
% store data
pos.date = date;
pos.sec = (wd-1)*24*60*60 + date(:,4)*60*60 + date(:,5)*60 + date(:,6);
pos.time = date(:,4)*60*60 + date(:,5)*60 + date(:,6);
pos.lat = data_cell{7};
pos.lon = data_cell{8};
pos.height = data_cell{9};
pos.Q = data_cell{10};
pos.ns = data_cell{11};
pos.hline = lcn;
if interval
    pos.Rmax = Rmax;
end
fclose(fp);

