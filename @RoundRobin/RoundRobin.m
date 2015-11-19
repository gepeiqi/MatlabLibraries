classdef RoundRobin < handle
    %     Round Robin Mat Modifiy
    %     Declaration : RoundRobinobj = RoundRobin(params) //variable argin
    %     input must be : params = 1xM vector (RoundRobinParams)
    %
    %     Methods :
    %     With RoundRobinobj
    %                 .Each           : returns accessor of each parameter
    %                 .GetModParam(i) : get ith paramter
    %                 .GetAllParams   : get all parameter
    %                 .Modify(A,F,i)  : modify A with F(param(i))
    %                    A=any matrix
    %                    F = @(A,PARAMETER) (function hundle (use "@"))
    %                    PARAMETER =Nx1 vector, = same size "param"
    %                    output = Modified matrix
    %     End With
    
    % ex)
    
    properties (Access = private)
        type;
        Params;
        Decoder=1;
        N;
    end
    
    
    methods (Access = public)
        %constractor
        function obj = RoundRobin(varargin)
            obj.type=Typeof();
            obj.N=length(varargin);
            for i=1:obj.N
                if(~obj.type.isVectorNx1(varargin{i}'));obj.ERROR(1);end
                obj.Decoder(i+1)=obj.Decoder(i)*length(varargin{i});
            end
            obj.Params=varargin(:);
            obj.Decoder(obj.N+1)=obj.Decoder(obj.N+1);
        end
        
        %interface
        function i = Each(obj)
            i=1:obj.n+1;
        end
        function i = n(obj)
            i=obj.Decoder(obj.N+1)-1;
        end

        function [param , iparam] = GetModParam(obj,i)
            i=i-1;
            if(i>obj.n);obj.ERROR(2);end
            if(i<0);obj.ERROR(2);end
            it=i;
            param=NaN(obj.N,1);
            iparam=NaN(obj.N,1);
            cnt=obj.N;
            while true
                iparam(cnt)=floor(it/obj.Decoder(cnt))+1;
                param(cnt)=obj.Params{cnt}(iparam(cnt));
                it=mod(it,obj.Decoder(cnt));
                cnt=cnt-1;
                if(cnt==0); break; end;
            end
        end
        
        function ModA = Modify(obj,A,F,i)
            if(~isa(F,'function_handle'));obj.ERROR(2);end
            param=obj.GetModParam(i);
            ModA=F(A,param);
        end
        function params=GetAllParams(obj)
            I=obj.Each;
            params=NaN(max(I),obj.N);
            for i=I
                params(i,:)=obj.GetModParam(i)';
            end
        end
        %help
        function h(~)
            doc RoundRobin
        end
    end
    
    
    methods (Access =private)
        function ERROR(obj,code)
            if(code ==1); error('input must be 1xN'); end;
            if(code ==2); error('invalide input'); end;
            if(code ==3); error('unexpected error'); end;
        end
    end
    
end

%%















