% Visualize Az El data
% Declaration : VisAzElobj=VisAzEl(az,el)
% Input must be : Size of az,el = Nx1
% Methods :
% With VisAzElobj.
% End With
classdef VisAzEl < handle
    properties (Access = private)
        type;
        AZ,EL,Radius;
        HasRadiusData;
    end
  
    
    methods (Access = public)
        %constractor
        function obj = VisAzEl(az,el,radius)
            obj.type=Typeof();
            if(~obj.type.isVectorNx1(az)  || ~obj.type.isVectorNx1(el)); obj.ERROR(1);end
            if(~obj.type.isSameSize(az,el));obj.ERROR(1);end
            obj.AZ=az;
            obj.EL=el;
            switch nargin
                case 2
                    obj.Radius=[];
                case 3
                    obj.Radius=radius;
                otherwise
                    obj.ERROR(1)
            end
            obj.HasRadiusData=~isempty(obj.Radius);
        end
        
        %plot
        function plot(obj)
            plot(obj.AZ,obj.EL,'.-');
        end
        
        function colorplot(obj)
            if(~obj.HasRadiusData);obj.ERROR(2);end
            plotc(obj.AZ,obj.EL,1+round(63*obj.Radius/max(obj.Radius)));
        end
        
    end
    
    
    methods (Access =private)
        function ERROR(~,code)
            if(code ==1); error('invalid input'); end;
            if(code ==2); error('no radius data'); end;
        end
    end
    
end

