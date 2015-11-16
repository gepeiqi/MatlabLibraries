function savefig(varargin)
if isempty(varargin)
    c=clock;
    file=[num2str(c(1)) num2str(c(2),'%2.2d') num2str(c(3)) num2str(c(4)) num2str(c(5)) num2str(c(6)*1000)];
else
    file=[varargin{1}];
end
saveas(gcf,[file '.fig'])
hgexport(gcf,[file '.eps']);
end