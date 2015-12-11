%%init
clear
close all
clc

Q=Qfactory();
q0=Q.Param2Quat([0;0;1],0);
f1.ex1=[1;0;0];% basis vector of frame1 when viewed in frame1
f1.ey1=[0;1;0];
f1.ex2=[1;0;0];% basis vector of frame2 when viewed in frame1
f1.ey2=[0;1;0];
f1.point=[1;1;0];
quiv =@(A,s) quiver3(0,0,0,A(1),A(2),A(3),0,s);
pl3 =@(A,s)  plot3(A(1),A(2),A(3),s);

%% rotation around ax and transformation
ax=[0;0;1];

for i=1:360
    q=Q.Param2Quat(ax,deg2rad(i));
    figure(1)
    quiv(f1.ex1,'b')
    hold on
    grid on
    title('frame 1')
    quiv(f1.ey1,'r')
    pl3(f1.point,'o')
    f1.ex2=q.R*f1.ex1;
    f1.ey2=q.R*f1.ey1;
    quiv(f1.ex2,'c')
    quiv(f1.ey2,'m')
    xlim([-1 1]); ylim([-1 1]); zlim([-1 1])
    hold off
    %     drawnow
    
    q_1to2=~q;
    f2.ex1=q_1to2.R*f1.ex1;
    f2.ey1=q_1to2.R*f1.ey1;
    f2.ex2=q_1to2.R*f1.ex2;
    f2.ey2=q_1to2.R*f1.ey2;
    f2.point=q_1to2.R*f1.point;
    
    figure(2)
    quiv(f2.ex1,'b')
    hold on
    grid on
    title('frame 2')
    quiv(f2.ey1,'r')
    pl3(f2.point,'o')
    quiv(f2.ex2,'c')
    quiv(f2.ey2,'m')
    xlim([-1 1]); ylim([-1 1]); zlim([-1 1])
    hold off
    %     drawnow
    
    
end

%% using vectors 2 quat
f1.ex1=[1;0;0];
f1.ey1=[0;1;0];
f1.ex2=[0;1;0];
f1.ey2=[0;0;1];
f1.point=[1;1;0];
ax=[0;0;1];
a=cross(f1.ex1,f1.ey1);
b=cross(f1.ex2,f1.ey2);
q1=Q.Vectors2Quat(a,b);
q2=Q.Vectors2Quat(q1.R*f1.ex1,f1.ex2);
q=q2*q1;

figure(3)
quiv(f1.ex1,'r')
hold on
grid on
title('frame 1')
quiv(f1.ey1,'g')
quiv(cross(f1.ex1,f1.ey1),'b')
quiv(f1.ex2,'m')
quiv(f1.ey2,'y')
quiv(cross(f1.ex2,f1.ey2),'c')
% 
% quiv(q.R*f1.ex1,'r--')
% quiv(q.R*f1.ey1,'g--')
% quiv(q.R*cross(f1.ex1,f1.ey1),'b--')

pl3(f1.point,'ok')

q_1to2=~q;
f2.ex1=q_1to2.R*f1.ex1;
f2.ey1=q_1to2.R*f1.ey1;
f2.ex2=q_1to2.R*f1.ex2;
f2.ey2=q_1to2.R*f1.ey2;
f2.point=q_1to2.R*f1.point;
axis equal
xlabel('x');ylabel('y');zlabel('z')

figure(4)
quiv(f2.ex1,'r')
hold on
grid on
title('frame 2')
quiv(f2.ey1,'g')
quiv(cross(f2.ex1,f2.ey1),'b')
quiv(f2.ex2,'m')
quiv(f2.ey2,'y')
quiv(cross(f2.ex2,f2.ey2),'c')

% quiv(q.R*f2.ex1,'r--')
% quiv(q.R*f2.ey1,'g--')
% quiv(q.R*cross(f1.ex1,f1.ey1),'b--')

pl3(f2.point,'ok')
axis equal

xlabel('x');ylabel('y');zlabel('z')
