classdef Typeof < handle
    properties (Access = private)
    end
    
    methods (Access = public)
        function obj = Typeof()
        end
        
        %type
        function tf = isScalar(~,A)
            tf = (size(A,1)==1) && (size(A,2)==1);
        end
        
        function tf = isVector3(~,A)
            tf = (size(A,1)==3) && (size(A,2)==1);
        end
        
        function tf = isVectors3(~,A)
            tf = (size(A,1)==3);
        end
        
        function tf = isVector4(~,A)
            tf = (size(A,1)==4) && (size(A,2)==1);
        end
        
        function TF=isVectorNx1(~,X)
            TF=size(X,2)==1;
        end
        
        function TF=isVectorNx3(~,X)
            TF=size(X,2)==3;
        end
        
        
        function TF=isSameSize(obj,varargin)
            if(isempty(varargin));error('invalid input');end
            if(obj.isScalar(varargin));TF=true; warning('No inputs to compare');return; end
            
            for i=1:length(varargin)
                try
                    S(i,:)=size(varargin{i});
                catch
                    TF=0;return;
                end
            end
            for i=1:size(S,2)
                S2(i,:)=length(unique(S(:,i)));
            end
            if(sum(S2)==length(S2));TF=true;return;end
            if(sum(S2)~=length(S2));TF=false;return;end
            error('‚È‚ñ‚©‚ÌƒGƒ‰[');
        end
        
        
    end
    
end
