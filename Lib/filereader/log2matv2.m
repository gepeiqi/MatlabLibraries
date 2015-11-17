%path : txtファイル
%format : 抜き出したいデータの書式(%f %d:%d:%d,%f)みたいな感じ
%ignor : 最初の[ignor]行は無視する
% function data = log2matv2(path,format,ignor);

function data = log2matv2(path,format,ignor);
datasize=length(strfind(format,'%'));

fp1=fopen(path);
data=NaN(10000,datasize);
cnt=1;
while(1)
    while(1)
        if(ignor)==0; break;end;
        aaa=fgetl(fp1);
        ignor=ignor-1;
    end
    aaa=fgetl(fp1);
    if(~isstr(aaa));break;end
    temp = sscanf(aaa, format);
    if length(temp)~=datasize ; fprintf('error!!') ; break ;end
    data(cnt,:)=temp';
    cnt=cnt+1;
    if(mod(cnt,10000)==0);data=[data;NaN(10000,datasize)];end
end
fclose(fp1);
data(cnt:size(data,1),:)=[];
