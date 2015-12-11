%%init
clear
close all
clc

Q=Qfactory();
q0=Q.Param2Quat([0;0;1],0);
quiv =@(A,s) quiver3(0,0,0,A(1),A(2),A(3),0,s);
pl3 =@(A,s)  plot3(A(1),A(2),A(3),s);
toNormal = @(x) x/norm(x);

f1.ex1=[1;0;0];% vector of frame 1 viewed in frame1
f1.ey1=[0;1;0];
f2.ex1=toNormal([1.4;1.4;0]);% vector of frame 1 viewed in frame2
f2.ey1=toNormal([-1.4;1.4;0]);
f1.point=[1;1;0];

%% same vector in different frame to frame transform
q1=Q.Vectors2Quat(cross(f1.ex1,f1.ey1),cross(f2.ex1,f2.ey1));
q2=Q.Vectors2Quat(q1.R*f1.ex1,f2.ex1);
q_1to2=q2*q1;


figure(1)
quiv(f1.ex1,'r')
hold on
grid on
title('frame 1')
quiv(f1.ey1,'g')
quiv(cross(f1.ex1,f1.ey1),'b')
pl3(f1.point,'ok')
xlabel('x');ylabel('y');zlabel('z')

figure(4)
quiv(f2.ex1,'r')
hold on
grid on
title('frame 2')
quiv(f2.ey1,'g')
quiv(cross(f2.ex1,f2.ey1),'b')
pl3(q_1to2.R*f1.point,'ok')
axis equal
xlabel('x');ylabel('y');zlabel('z')




