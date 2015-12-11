classdef BinarySearch < handle
%     Making Quaternion
%     Declaration : BinarySearchobj=BinarySearch()
% 
%     Methods :
%     With BinarySearch
%     End With

    properties (Access = private)
        type;
        src;
    end
    
    methods (Access = public)
        function obj = BinarySearch(src,varargin)
            obj.type=Typeof();
            if(obj.type.isVectorNx1);obj.ERROR(1);end
            obj.src=sort(src);
            
            for i=1:2:length(varargin)
                
            end
        end
        
        %help
        function h(~)
            doc BinarySearch
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

