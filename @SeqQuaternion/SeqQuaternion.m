classdef SeqQuaternion < handle
%     Time Sequential Quaternion InterPoloant
%     Declaration : SeqQuaternionobj = SeqQuaternion(t,Q)
%                       t=nx1 time vector
%                       Q=nx1 cell object conatins 'Quaternion' object 
% 
%     Methods :
%           .Interp(t) : Inter Polant
%           .Extrap(t) : Extra Polant
%     With SeqQuaternion.
%     End With
    properties (Access = private)
        type;
        Q;
        t,Qlist;
        TimeNormalize;
    end
    
    methods (Access = public)
        function obj = SeqQuaternion(t,Q)
            obj.type=Typeof();
            if(~(obj.type.isVectorNx1(t) && obj.type.isVectorNx1(Q)));obj.ERROR(1);end
            if(~obj.type.isSameSize(t,Q));obj.ERROR(1);end
            if(~iscell(Q));obj.ERROR(1);end
            for i=1:length(Q)
                if(~isa(Q{i},'Quaternion'));obj.ERROR(1);end
            end
            obj.Q=Qfactory();
            obj.t=t;
            obj.Qlist=Q;
        end
        
        function [q,varargout] = Interp(obj,t)
            [tf,tc,if_,ic]=obj.BothSide(obj.t,t);
            [ti,varargout{1}]=obj.CompParam(t,tf,tc);
            q=obj.Q.Slerp(obj.Qlist{if_},obj.Qlist{ic},ti); 
        end
        
        function [q,varargout] = Extrap(obj,t)
            [tf,tc,if_,ic]=obj.Backward2(obj.t,t);
            [ti,varargout{1}]=obj.CompParam(t,tf,tc);
            q=obj.Q.Slerp(obj.Qlist{if_},obj.Qlist{ic},ti);
        end
        
        function t = ExtrapStartTime(obj)
            t=obj.t(2);
        end
        
        function t=GetTime(obj)
            t=obj.t;
        end
        
        %help
        function h(~)
            doc SeqQuaternion
        end
    end
    
    methods (Access =private)
        function ERROR(~,code,varargin)
            switch(code)
                case 1
                    error('invalid input \n');
                case 2
                    error('out range interpoloant' );
                case 3
                    error('at least 2 data needed before input time to Extra Polant')
                otherwise
            end
        end
        
        function [floor,ceil,ifloor,iceil]=BothSide(obj,X,x)
            dif=X-x;
            if(sum(dif==0)==1);
                floor=x; ifloor=find(dif==0); 
                try
                    iceil=ifloor+1; ceil=X(iceil);
                catch
                    iceil=ifloor-1; ceil=X(iceil);
                end
                return;
            end
            if(  (isempty(find(dif>0))) || (isempty(find(dif<0)))  );obj.ERROR(2);end
            [ceil,~]=obj.Nearest(X(dif>0),x);
            [floor,~]=obj.Nearest(X(dif<0),x);
            iceil=find(X==ceil);
            ifloor=find(X==floor);
        end
        
        function [tf,tn,if_,in]=Backward2(obj,X,x)
            dif=X-x;
            if(sum(dif<=0) < 2);obj.ERROR(3);end
            [tn,~]=obj.Nearest(X(dif<=0),x);%1st Nearest
            in=find(X==tn);
            X(in)=inf;
            [tf,~]=obj.Nearest(X(dif<=0),x);%2nd Nearest
            if_=find(X==tf);
        end
        
        function [C,i]=Nearest(~,X,x)
            [~,i]=min(abs(X-x));
            C=X(i);
        end
        
        function [ti,infoobj]=CompParam(~,t,tf,tc)
            ti=(t-tf)/(tc-tf);
            infoobj.CurrentTime=t;
            infoobj.Time1=tf;
            infoobj.Time2=tc;
            if ti<=0.5
                infoobj.NearestTime=tf;
            else
                infoobj.NearestTime=tc;
            end
            infoobj.Coef=ti;
            infoobj.TimeFromUpdate=abs(t-infoobj.NearestTime);
        end
        
        
    end
end














