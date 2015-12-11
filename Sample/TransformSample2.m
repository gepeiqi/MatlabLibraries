% enu body positioin calclation
% using...  1."Geometric constraints between antenna and body"
%           2."Body attitude in enu frame"
%           3."Antenna position in enu frame"

clear; close all; clc;

Q=Qfactory();
q_body2enu=Q.Param2Quat([0;0;1],deg2rad(45));%"Body attitude in enu frame"
base=[[1;0;0] [-1;-0.5;0] [-0.5;0;0] [-1;0.5;0] [1;0;0]];
quiv =@(A,s) quiver3(0,0,0,A(1),A(2),A(3),0,s);
pl3 =@(A,s)  plot3(A(1,:),A(2,:),A(3,:),s);


antpos=[[1;1;0] [0;0;0]];%"Geometric constraints between antenna and body"

figure
pl3(base,'k')
hold on
pl3(antpos,'b')
grid on
xlabel('x'); ylabel('y');zlabel('z');axis square
title('body fixed frame')%bf
axis equal

figure
bf2bcenu=Transform([0;0;0],q_body2enu);
pl3(bf2bcenu.TF(base),'k')
hold on
pl3(bf2bcenu.TF(antpos),'b')
grid on
xlabel('x'); ylabel('y');zlabel('z');axis square
title('body centered enu frame')%bcenu

antobs=[10;5;0];%"Antenna position in enu frame"
tmp=bf2bcenu.TF(antpos);
bcenu2enu=Transform(tmp(:,1)-antobs,Q.Empty);
bf2enu=bf2bcenu*bcenu2enu;

figure
pl3(antobs,'or')
hold on
pl3([0;0;0],'b')
pl3(bf2enu.TF(base) ,'k')
pl3(bf2enu.TF(antpos) ,'b')
xlabel('x'); ylabel('y');zlabel('z');axis square
grid on
axis equal
title('enu frame')%enu

bodyposition = bf2enu.TF([0;0;0])

















