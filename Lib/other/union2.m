function C=union2(varargin)
%   multi input union
%   input : nx1 vector
%   usage : C=union2(a,b,c,....)

    n=length(varargin);
    
    C=varargin{1};
    for i=2:n
        C=union(C,varargin{i});
    end

end