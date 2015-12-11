clear; close all; clc;

Q=Qfactory();
pl3=@(A,s)  plot3(A(1,:),A(2,:),A(3,:),s);
%% some points in frame 1 
Frame1.ex1=[[0;0;0] [1;0;0]];
Frame1.ey1=[[0;0;0] [0;1;0]];
Frame1.point=[2;2;0];

figure(1)
pl3(Frame1.ex1,'r')
hold on
grid on
pl3(Frame1.ey1,'b')
pl3(Frame1.point,'og')
axis equal
xlabel('x');ylabel('y')

%% transform frame1 to frame2
t=[1;1;0];
q=Q.Param2Quat([0;0;1],deg2rad(90));
TF1to2=Transform(t,q);

Frame2.ex1=TF1to2*(Frame1.ex1);
Frame2.ey1=TF1to2*(Frame1.ey1);
Frame2.point=TF1to2*(Frame1.point);

figure(2)
pl3(Frame2.ex1,'r')
hold on
grid on
pl3(Frame2.ey1,'b')
pl3(Frame2.point,'og')
axis equal
xlabel('x');ylabel('y')

Frame2.ex2=[[0;0;0] [1;0;0]];
Frame2.ey2=[[0;0;0] [0;1;0]];
pl3(Frame2.ex2,'m')
pl3(Frame2.ey2,'c')
axis equal
xlabel('x');ylabel('y')

%transform to basis vector of frame2 in frame1 from frame2
Frame1.ex2=~TF1to2*(Frame2.ex2);
Frame1.ey2=~TF1to2*(Frame2.ey2);

figure(1)
pl3(Frame1.ex2,'m')
pl3(Frame1.ey2,'c')
axis equal
xlabel('x');ylabel('y')


%% create transform 1to3 from 1to2 , 2to3
TF2to3=Transform([2;1;0],q);

Frame3.ex1=TF2to3*(Frame2.ex1);
Frame3.ey1=TF2to3*(Frame2.ey1);
Frame3.ex2=TF2to3*(Frame2.ex2);
Frame3.ey2=TF2to3*(Frame2.ey2);
Frame3.point=TF2to3*(Frame2.point);
Frame3.ex3=[[0;0;0] [1;0;0]];
Frame3.ey3=[[0;0;0] [0;1;0]];
figure(3)
pl3(Frame3.ex1,'r')
hold on
grid on
pl3(Frame3.ey1,'b')
pl3(Frame3.ex2,'m')
pl3(Frame3.ey2,'c')
pl3(Frame3.ex3,'g')
pl3(Frame3.ey3,'y')
pl3(Frame3.point,'og')
axis equal
xlabel('x');ylabel('y')

TF1to3=TF1to2 * TF2to3;

figure(4)
pl3(TF1to3*(Frame1.ex1),'r')
hold on
grid on
pl3(TF1to3*(Frame1.ey1),'b')
pl3(TF1to3*(Frame1.ex2),'m')
pl3(TF1to3*(Frame1.ey2),'c')
pl3(Frame3.ex3,'g')
pl3(Frame3.ey3,'y')
pl3(TF1to3*(Frame1.point),'og')
axis equal
xlabel('x');ylabel('y')






