%%init
clear 
close all
clc

Q=Qfactory();
q0=Q.Param2Quat([0;0;1],deg2rad(40));

base=[1;0;0];
quiv =@(A,s) quiver3(0,0,0,A(1),A(2),A(3),s);

%% rotation around ax
ax=[0;0;1];
figure(1)
quiv(base,'b')
hold on
quiv(ax,'c')
for i=1:5:360
    q=Q.Param2Quat(ax,deg2rad(i));
    figure(1)
    quiv(q.R*base,'r')
    drawnow
    
    figure(2)
    subplot(3,1,1)
    plot(i,rad2deg(q.roll),'.')
    hold on
    subplot(3,1,2)
    plot(i,rad2deg(q.pitch),'.')
    hold on
    subplot(3,1,3)
    plot(i,rad2deg(q.yaw),'.')
    hold on
    
end
