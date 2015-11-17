function skyline=sk_sim(Fu,simpos,dth)
%% hard coded constants
outlook=10*10^3;% ‰½mæ‚Ü‚ÅŒ©‚¦‚éH
lookres=20;% ‹üã‚É‘¶İ‚·‚é’n•¨‚É‘Î‚µ‚Ä‰½mŠÔŠu‚Å‚‚³‚ğ’²‚×‚éH
% R = 6356.752*1000; % ’n‹…‚Ì”¼Œa[m] (‹É”¼Œa)
R = 6378.137*1000; % ’n‹…‚Ì”¼Œa (Ô“¹”¼Œa)
Thresh_Huge=100;

%% pre processing
% prepare pararel processing 
Lsims=size(simpos,1);
HugeProcess=false;
if(Thresh_Huge  < Lsims)
    HugeProcess=1;
end
if( HugeProcess)
    try
        matlabpool close
    catch
    end
    matlabpool open local 3
end

% prepare process values
theta=linspace(dth,360,360/dth);%Œ©‚¦‚éŒÀŠE“_‚Ì‘Š‘ÎÀ•W‚ğZo()
evalr=linspace(0,outlook,outlook/lookres);%evaluation_radius
evalr(1)=[];
devalx=sind(theta)'*evalr;%row:•ûˆÊŠp@col r=evalr(col)
devaly=cosd(theta)'*evalr;

% prepare return values
skel=NaN(Lsims,360/dth);
skposx=NaN(Lsims,360/dth);
skposy=NaN(Lsims,360/dth);
skradius=NaN(Lsims,360/dth);
repevalr=repmat(evalr,[360/dth,1]);
tic
%% processing
parfor i=1:Lsims;
    simx=simpos(i,1);
    simy=simpos(i,2);    
    evalx=simx+devalx;
    evaly=simy+devaly;
    
    evalel=rad2deg(atan2( Fu(evalx,evaly)- (Fu(simx,simy)+simpos(i,3)) , repmat(evalr,[360/dth 1]) ));
    [C,idx]=max(evalel,[],2);
    
    ind=sub2ind(size(evalel),1:360/dth,idx');
%     idx_tf=false(size(evalel));
%     idx_tf(ind)=true;    

    skel(i,:)=C';
    skposx(i,:)=evalx(ind)';
    skposy(i,:)=evaly(ind)';
    skradius(i,:)=repevalr(ind)';
    fprintf('%d / %d  done\n',i,Lsims);
end
toc

skyline.rel.az=theta;
skyline.rel.el=skel;
skyline.rel.radius=skradius;
skyline.rel.origin=simpos;
skyline.abs.x=skposx;
skyline.abs.y=skposy;
skyline.abs.z=Fu(skposx,skposy);

if HugeProcess
    matlabpool close
end


end
