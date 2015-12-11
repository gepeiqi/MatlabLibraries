function yq = extrap1(x,y,xq)
% liner extra polation
% yq = extrap1(x,y,xq)
% x,y = Nx1 data vector
% xq  = Mx1 query vector
% yq  = Mx1 vector extra polated by x,y
    if(size(x)~=size(y));error('invalid input');end
    if(size(x,2)~=1);error('invalid input');end
    if(size(x,1)<2);error('invalid input');end
    
    a=[NaN ; diff(y)./diff(x)];
    b=y-a.*x;
    
    idx=NaN(length(xq),1);
    for i=1:length(xq)
        if(isempty(find(x-xq(i)<=0, 1)));
            idx(i,1)=1;
        else
            idx(i,1)=find(x-xq(i)<=0, 1, 'last' );
        end
    end
    yq=a(idx).*xq+b(idx);
    
end