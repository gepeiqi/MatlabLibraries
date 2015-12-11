%%init
clear 
close all
clc

Q=Qfactory();
q0=Q.Param2Quat([0;0;1],deg2rad(40));
base=[0;1;0];
quiv =@(A,s) quiver3(0,0,0,A(1),A(2),A(3),0,s);

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
    grid on
    subplot(3,1,2)
    plot(i,rad2deg(q.pitch),'.')
    hold on
    grid on
    subplot(3,1,3)
    plot(i,rad2deg(q.yaw),'.')
    hold on
    grid on
end

%% rotation using angler rate
q0=Q.Param2Quat([0;0;1],deg2rad(0));

figure
quiv(base,'b')
hold on
xlabel('x')
ylabel('y')
zlabel('z')
xlim([-1 1])
ylim([-1 1])
zlim([-1 1])
axis square
dt=1;
quiv([0,0,1],'c')
for i=1:90
    dQ=q0.dot([0;0;deg2rad(1)]);
    dQ=dQ*dt;
    q0=q0+dQ;
    q0.normalize;
    quiv(q0.R*base,'r')
    drawnow
end
quiv([1,0,0],'c')
for i=1:90
    dQ=q0.dot([deg2rad(1);0;0]);
    dQ=dQ*dt;
    q0=q0+dQ;
    q0.normalize;
    quiv(q0.R*base,'r')
    drawnow
end
quiv([0,1,0],'c')
for i=1:90
    dQ=q0.dot([0;deg2rad(1);0]);
    dQ=dQ*dt;
    q0=q0+dQ;
    q0.normalize;
    quiv(q0.R*base,'r')
    drawnow
end

%% rotation using gyroscope (body frame angler rate)
q0=Q.Param2Quat([0;0;1],deg2rad(0));
base=[[1;0;0] [-1;-0.5;0] [-0.5;0;0] [-1;0.5;0] [1;0;0]];
quiv =@(A,s) quiver3(0,0,0,A(1),A(2),A(3),0,s);
pl3 =@(A,s)  plot3(A(1,:),A(2,:),A(3,:),s);

Omega=deg2rad([ repmat([0;0;1],[1,90]) repmat([1;0;0],[1,90]) repmat([0;1;0],[1,90]) ]);

figure(1)
hold on
dt=1;
quiv([0,0,1],'c')
for i=1:size(Omega,2)
    omegab=Omega(:,i);%body frame
    omega=q0.R*omegab;%grobal frame
    dQ=q0.dot(omega);
    dQ=dQ*dt;
    q0=q0+dQ;
    q0.normalize;
    pl3(q0.R*base,'r')
    hold on
    pl3(base,'b')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    xlim([-1 1])
    ylim([-1 1])
    zlim([-1 1])
    axis square
    grid on
    
    drawnow
    hold off
end


