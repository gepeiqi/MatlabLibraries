function Ikm=imkmeans(im,clust)
s=size(im);
sx=s(1);
sy=s(2);
sz=s(3);
im = double(reshape(im, [sx*sy,sz]));
[k0,idx] = kmeans(im, clust,'emptyaction','drop');
Ikm = reshape(k0, [sx,sy]);
end