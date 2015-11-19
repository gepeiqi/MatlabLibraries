function fitA = sizefit(A,B,dim)
% output : resized A 
sa=size(A);
sb=size(B);
sf=ones(size(sa));
sf(dim)=sb(dim);
fitA=repmat(A,sf);
end