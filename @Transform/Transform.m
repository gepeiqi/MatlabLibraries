classdef Transform < handle
    %     TransForm
    %     Declaration : TransFormobj = TransForm(T,Q)
    %                   T = 3x1 Vector
    %                       origin point of Transformed coordinate when
    %                       viewed from original corrdinate
    %                   Q = Quaternion object
    %                       Attitude of transformed coordinate when viewed
    %                       from original coordinate
    %                       'attitude' means rotation vectorA to vectorB in same frame
    %                       Make sure it is different 'attitude' and
    %                       'transformation frameA to B'
    %                       if vectorA,B in frameA is basis vector of frameA,B and Q
    %                       discribes rotation A to B in frameA, then ~Q discribes
    %                       transformation A to B
    %
    %
    %     Methods :
    %     With TransForm
    %           .TF(points)    : points=3xN vectors
    %           .TFinv(points)
    %     End With
    %
    %     Over load methods :
    %           TFobj1 * TFobj2 : returns new TFobj (TF2 after TF1 )
    %                           TFobj.TF(points) = TFobj2.TF(TFobj1.TF(points))
    %           TFobj1 * points : equal to TFobj1.TF(points)
    %
    %           ~TFobj          : retruns new TFobj (inverse transform)
    %                             ~TFobj.TF(points) = TFobj.TFinv(points)
    
    properties (Access = private)
        type;
        T,Q;
        P,Pinv;
    end
    
    methods (Access = public)
        function obj = Transform(T,Q)
            obj.type=Typeof();
            if(~obj.type.isVector3(T));obj.ERROR(1);end
            if(~isa(Q,'Quaternion'));obj.ERROR(1);end
            obj.T=T;
            obj.Q=Q;
            obj.P=[(obj.Q.R)',-(obj.Q.R'*obj.T) ; [0 0 0 1]];
            obj.Pinv=[obj.Q.R,obj.T;[0 0 0 1]];
            
        end
        
        % interface
        function [t,q]=getParam(obj)
            t=obj.T;
            q=obj.Q;
        end
        
        %overload
        function output=mtimes(a,b)%overload of [*]
            if(isa(a,'Transform') && isa(b,'Transform'))
                [~,q1]=a.getParam;
                [t2,q2]=b.getParam;
                output=Transform(~a*(t2),q2*q1);
            elseif(isa(a,'Transform') && size(b,1)==3)
                X=a.P*[b;sizefit(1,b,2)];
                output=X(1:3,:);
            else
                error('Unsupported Calclation');
            end
        end
        
        function output=not(a)
            [t,q]=a.getParam();
            output=Transform(q.R'*(-t),~q);
        end
        
        
        %help
        function h(~)
            doc Transform
        end
    end
    
    methods (Access =private)
        function ERROR(~,code,varargin)
            switch(code)
                case 1
                    error('invalid input \n');
                otherwise
            end
        end
    end
end

