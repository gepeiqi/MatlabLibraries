classdef Quaternion < handle
%     Quaternion calclator
%     Declaration : Quaternionobj = Quaternion(q)
%              or : Qfactory's method returns this class instance
%     Input must be 4x1 vector, q(1:3)=axis element, q(4)=angle element
%
% 
%     Methods :
%     With Quaternion
%       R() : returns 3x3 rotation matrix 
%       toDouble() : Quaternion -> parameter [q1,q2,q3,q4]
%       rpy() : return roll,pitch,yaw
%       roll(): return roll
%       pitch() : return pitch
%       yaw() : return yaw
%     End With
%     
%     OverLoads : (with q =Quaternion(Q))
%       ~q    : returns conjection of q
%       q1*q2 : calc Quaternion Production (q1*q2 means rotation q2 after q1)
%
%     Reference : http://users.aalto.fi/~ssarkka/pub/quat.pdf
%               : http://www.x-io.co.uk/res/doc/madgwick_internal_report.pdf
    properties (Access = public)
        angle;axis;param;
    end
    properties (Access = private)
        x,y,z,w,Rmat,theta,type;
        wx,wy,wz;
    end
    
    
    methods (Access = public)
        %constractor
        function obj = Quaternion(q)
            obj.type=Typeof();
            if(~obj.type.isVector4(q));obj.ERROR(2);end
            obj.theta=acos(q(4));
%             if( abs(norm(q(1:3)) - sin(obj.theta))>0.0001);obj.ERROR(1);end
            x=q(1);y=q(2);z=q(3);w=q(4);
            ii = @(a,b,c,d) a^2+b^2-c^2-d^2;
            ij = @(a,b,c,d) 2*(a*b+c*d);
            obj.Rmat=[ii(w,x,y,z)   ij(x,y,z,-w) ij(z,x,y,w); ...
                      ij(x,y,z,w)   ii(w,y,z,x)  ij(y,z,x,-w); ...
                      ij(z,x,y,-w)  ij(y,z,x,w)  ii(w,z,x,y)      ];
            obj.wz=atan2(2*x*y +2*w*z, w*w +x*x -y*y -z*z);
            obj.wy =asin(2*w*y -2*x*z);
            obj.wx = atan2(2*y*z +2*w*x, -w*w +x*x +y*y -z*z);
            obj.x=x;obj.y=y;obj.z=z;obj.w=w;
            obj.angle=2*obj.theta;obj.axis=q(1:3)./sin(obj.theta);obj.param=q;
        end
               
        %interface
        function Rmat = R(obj)
            Rmat=obj.Rmat;
        end
        function q = toDouble(obj)
            q=[obj.x;obj.y;obj.z;obj.w];
        end
        function deg=rpy(obj)
            deg=[obj.wx obj.wy obj.wz];
        end
        function deg=roll(obj)
            deg=obj.wx;
        end
        function deg=pitch(obj)
            deg=obj.wy;
        end
        function deg=yaw(obj)
            deg=obj.wz;
        end
        
        
        function Qdot= dot(obj,rate)
            if(~obj.type.isVector3(rate));obj.ERROR(2);end
            rx=rate(1);ry=rate(2);rz=rate(3);
            Omega=[ 0  -rz  ry  rx;
                    rz  0  -rx  ry;
                   -ry  rx  0   rz;
                   -rx -ry -rz  0];
            Q=obj.toDouble();
            Qdot=Quaternion(Omega*Q);
        end
        
        %%% Quaternion Calc
        function q_bar = not(obj) %overload of [~]
            q_bar=Quaternion([-obj.x;-obj.y;-obj.z;obj.w]);
        end
        
        function q=mtimes(a,b)%overload of [*]
            if(isa(a,'Quaternion') && isa(b,'Quaternion'))
                q1=a.toDouble;
                q2=b.toDouble;
                s1=q1(4); s2=q2(4);
                v1=q1(1:3); v2=q2(1:3);
                q=Quaternion([(s1*v2+s2*v1+cross(v1,v2));(s1*s2 -dot(v1,v2))]);%quaternion production
            elseif(isa(a,'Quaternion') && isreal(b))
                q1=a.toDouble;
                q=Quaternion(q1*b);
            elseif(isreal(a) && isa(b,'Quaternion'))
                q1=b.toDouble;
                q=Quaternion(q1*a);
            else   
                error('Unsupported Calclation');
            end
        end
        
        function q=plus(a,b)
            if(isa(a,'Quaternion') && isa(b,'Quaternion'))
                q1=a.toDouble;
                q2=b.toDouble;
                q=Quaternion(q1+q2);%quaternion production
            else   
                error('Unsupported Calclation');
            end
        end
        
        %help
        function h(~)
            doc Quaternion
        end
    end
    
    
    methods (Access =private)
        function ERROR(obj,code)
            if (code ==1); error('norm of quaternion(1:3) must be 1 \n ');end
            if (code ==2); error('invalid input \n ');end
            if (code ==3); error('No member \n');end
        end
    end
    
end
