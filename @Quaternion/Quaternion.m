classdef Quaternion < handle
    %     Quaternion calclator
    %     Declaration : Quaternionobj = Quaternion(q)
    %              or : Qfactory's method returns this class instance
    %     Input must be 4x1 vector, q(2:4)=axis element, q(1)=angle element
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
        normalized;
    end
    properties (Access = private)
        q,type,Q;
    end
    
    methods (Access = public)
        %constractor
        function obj = Quaternion(q)
            obj.type=Typeof();
            if(~obj.type.isVector4(q));obj.ERROR(2);end
            obj.Q=Qfactory();
            obj.q=q;
            theta=acos(q(1));
            obj.angle=2*theta;
            obj.axis=q(2:4)./sin(theta);
            obj.param=q;
            obj.normalized=obj.isNormalized;
        end
        
        %interface
        function Rmat = R(obj)
            [w,x,y,z]=obj.sep;
            ii = @(a,b,c,d) a^2+b^2-c^2-d^2;
            ij = @(a,b,c,d) 2*(a*b+c*d);
            Rmat=[ii(w,x,y,z)   ij(x,y,z,-w) ij(z,x,y,w); ...
                  ij(x,y,z,w)   ii(w,y,z,x)  ij(y,z,x,-w); ...
                  ij(z,x,y,-w)  ij(y,z,x,w)  ii(w,z,x,y)      ];
%             ii =@(a,b) 2*a^2 -1 + 2*b^2;
%             ij= @(a,b,c,d) 2*(a*b+c*d);
%             Rmat=[ii(w,x)       ij(x,y,+w,z)  ij(x,z,-w,y);...
%                   ij(x,y,-w,z)  ii(w,y)       ij(y,z,+w,x) ;...
%                   ij(x,z,+w,y)  ij(y,z,-w,x)  ii(w,z)];
        end
        function q = toDouble(obj)
            q=obj.q;
        end
        function deg=rpy(obj)
            deg=[obj.roll obj.pitch obj.yaw];
        end
        function deg=roll(obj)
            [w,x,y,z]=obj.sep;
            deg=atan2(2*y*z +2*w*x, -w*w +x*x +y*y -z*z);
        end
        function deg=pitch(obj)
            [w,x,y,z]=obj.sep;
            deg=asin(2*w*y -2*x*z);
        end
        function deg=yaw(obj)
            [w,x,y,z]=obj.sep;
            deg=atan2(2*x*y +2*w*z, w*w +x*x -y*y -z*z);
        end
        function normalize(obj)
            obj.q=obj.q/norm(obj.q);
            obj.normalized=obj.isNormalized;
        end
        function TF=isNormalized(obj)
            TF=norm(obj.q)-1<0.0001;
        end
        
        function Qdot= dot(obj,rate)
            if(~obj.type.isVector3(rate));obj.ERROR(2);end
            Omega=[0       -rate(1) -rate(2) -rate(3);...
                   rate(1)  0       -rate(3)  rate(2);...
                   rate(2)  rate(3)  0       -rate(1);...
                   rate(3) -rate(2)  rate(1)  0      ];
            Qdot=Quaternion(0.5*Omega*obj.q);
%             Qdot =Quaternion( 0.5 * obj.qprod(obj.q,[0;rate]));
        end
        
        %%% Quaternion Calc interface
        function q_bar = not(obj) %overload of [~]
            q_bar=Quaternion( obj.qconj(obj.q) );
        end
        
        function q=mtimes(a,b)%overload of [*]
            if(isa(a,'Quaternion') && isa(b,'Quaternion'))
                q1=a.toDouble;
                q2=b.toDouble;
                s1=q1(1); s2=q2(1);
                v1=q1(2:4); v2=q2(2:4);
                q=Quaternion([(s1*s2 -dot(v1,v2));(s1*v2+s2*v1+cross(v1,v2))]);
                q.normalize();
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
                q=Quaternion(a.toDouble+b.toDouble);%quaternion sumention
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
        function ERROR(~,code)
            if (code ==1); error('norm of quaternion(1:3) must be 1 \n ');end
            if (code ==2); error('invalid input \n ');end
            if (code ==3); error('No member \n');end
        end
        function [w,x,y,z]=sep(obj)
            x=obj.q(2); y=obj.q(3); z=obj.q(4); w=obj.q(1);
        end
        
        % double 4x1 vector calc lib
        function q_bar=qconj(~,q)
            q_bar=q;
            q_bar(2:4)=-q_bar(2:4);
        end
        function q=qprod(~,q1,q2)
            s1=q1(1); s2=q2(1);
            v1=q1(2:4); v2=q2(2:4);
            q=[(s1*s2 -dot(v1,v2));(s1*v2+s2*v1+cross(v1,v2))];%quaternion production
        end
    end
    
end