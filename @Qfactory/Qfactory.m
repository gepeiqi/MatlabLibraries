classdef Qfactory < handle
%     Making Quaternion
%     Declaration : Qfactoryobj = Qfactory()
% 
%     Methods :
%     With Qfactory
%       Num2Quat(qi) : qi= 4x1 quaternion parameter 
%       Param2Quat(rotaxis,th) : rotaxis = 3x1 , th=1x1 degree of rotation  
%       Vectors2Quat(a,b) : a,b=3x1 , return quaternion a to b 
%       Slerp(q1,q2,t) : q1,q2=quaternion , t=0~1 , Spere interp
%     End With
    properties (Access = private)
        type;
    end
    
    methods (Access = public)
        function obj = Qfactory()
            obj.type=Typeof();
        end
        % Quaternion Making
        function q = Num2Quat(obj,qi)
            if(~obj.type.isVector4(qi)); obj.ERROR() ; end
            q=Quaternion(qi);
        end
        
        function q = Param2Quat(obj,rotaxis,th)
            if(~obj.type.isVector3(rotaxis) || ~obj.type.isScalar(th)); obj.ERROR(1) ; end
            if(~(-2*pi < th && th < 2*pi)) ; obj.ERROR(2); end
            n=rotaxis/norm(rotaxis);
            q=Quaternion([n*sin(th/2);cos(th/2)]);
        end
        
        function q = Vectors2Quat(obj,a,b)
            if(~obj.type.isVector3(a) || ~obj.type.isVector3(b)); obj.ERROR(1) ; end
            n=cross(a,b);
            th=acos(dot(a,b)/(norm(a)*norm(b)));
            q=obj.Param2Quat(n,th);
        end
        
        function q=Slerp(obj,q1,q2,t)
            if( ~isa(q1,'Quaternion') || ~isa(q2,'Quaternion') ); obj.ERROR(1);end
            if( ~obj.type.isScalar(t));obj.ERROR(1);end
            if( ~(0<=t && t<=1) );obj.ERROR(1);end
            Om=acos(q1.toDouble'*q2.toDouble);
            Ps=sin((1-t)*Om)/sin(Om);
            Pe=sin(t*Om)/sin(Om);
            q=Quaternion(Ps*q1.toDouble + Pe*q2.toDouble);
        end
        %help
        function h(~)
            doc Qfactory
        end
    end
    
    methods (Access =private)
        function ERROR(~,code,varargin)
            switch(code)
                case 1
                    error('invalid input \n');
                case 2
                    warning('rotate angle th must be "Rad". your input might be "Deg" (out of -2pi to 2pi)' );
                otherwise
            end
        end
    end
end

