classdef SeqTransform < handle
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
        t
        seqT,seqQ;
        TFlist;
    end
    
    methods (Access = public)
        function obj = SeqTransform(t,TFlist)
            obj.type=Typeof();
            if(~obj.type.isVectorNx1(t));obj.ERROR(1);end
            if(~iscell(TFlist) || ~obj.type.isVectorNx1(TFlist) );obj.ERROR(1);end
            for i=1:length(TFlist)
                if(~isa(TFlist{i},'Transform') );obj.ERROR(1);end
            end
            
            obj.t=t;
            Tlist=NaN(3,length(TFlist));
            Qlist=cell(length(TFlist),1);
            for i=1:length(TFlist)
                [Tlist(:,i),Qlist{i}]=TFlist{i}.getParam;
            end
            obj.seqT=MultiDictionary(t,Tlist');
            obj.seqQ=SeqQuaternion(t,Qlist);
            obj.TFlist=TFlist;
        end
        
        function [TFobj,varargout] = Interp(obj,t)
            obj.seqT.Mode_Complete;
            tmove=obj.seqT.toValue(t)';
            [q,varargout{1}]=obj.seqQ.Interp(t);
            TFobj=Transform(tmove,q);
        end
        
        function [TFobj,varargout] = Extrap(obj,t)
            obj.seqT.Mode_Extrap;
            tmove=obj.seqT.toValue(t)';
            [q,varargout{1}]=obj.seqQ.Extrap(t);
            TFobj=Transform(tmove,q);
        end
        
        function t = ExtrapStartTime(obj)
            t=obj.t(2);
        end
        
        function [t,TF]=GetParam(obj)
            t=obj.t;
            TF=obj.TFlist;
        end
        function t=Key(obj)
            t=obj.t;
        end
        function TF=Value(obj)
            TF=obj.TFlist;
        end
        %help
        function h(~)
            doc SeqTransform
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














