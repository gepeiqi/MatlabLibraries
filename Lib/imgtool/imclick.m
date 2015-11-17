function [x,y,c]=imclick(I)
    [x,y]=getpts();
    x=round(x);
    y=round(y);
    
    if(nargin==0);
        c=NaN ;
    elseif (nargin==1) 
        c=diag(I(y,x));
    end
    
end