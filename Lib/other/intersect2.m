function [C,varargout]=intersect2(varargin)
%   multi input intesect
%   input : nx1 vector
%   usage : C=intersect2(a,b,c,....)
%         : [C,I]=intersect2(a,b,c,....)

    n=length(varargin);
    
    C=varargin{1};
    for i=2:n
        C=intersect(C,varargin{i});
    end
    I=cell(n,1);
    for i=1:n
        [C,I{i},~]=intersect(varargin{i},C);
    end
    varargout{1}=I;
end