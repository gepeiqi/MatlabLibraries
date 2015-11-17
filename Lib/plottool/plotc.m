function plotc(x,y,c)

patch([NaN;x],[NaN;y],[1;c],'EdgeColor','interp','CDataMapping','direct')

end