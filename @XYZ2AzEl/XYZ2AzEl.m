classdef XYZ2AzEl < handle
    properties (Access = private)
        type;
        X,Y,Z,Fu;
        IsSurfaceData
        OrigX,OrigY,OrigZ;
    end
  
    
    methods (Access = public)
        %constractor
        function obj = XYZ2AzEl(X,OX)
            obj.type=Typeof();
            if(~obj.type.isVectorNx3(X)); obj.ERROR(1);end
            if(nargin==1); OX=[0,0,0];end
            if(~obj.type.isVectorNx3(OX)); obj.ERROR(1);end
            x=X(:,1);y=X(:,2);z=X(:,3);
            ox=OX(:,1);oy=OX(:,2);oz=OX(:,3);
            
            try
                obj.Fu = scatteredInterpolant(x,y,z);% Z=Fu(X,Y)
                obj.Fu.ExtrapolationMethod = 'none';
                obj.IsSurfaceData=true;
            catch
                obj.IsSurfaceData=false;
            end
            obj.X=x;obj.Y=y;obj.Z=z;          
            obj.OrigX=ox;obj.OrigY=oy;obj.OrigZ=oz;
        end
        
        %interface
        function SetOriginalPoint(x,y,z)
            if(~obj.type.isVectorNx1(x) || ~obj.type.isVectorNx1(y) || ~obj.type.isVectorNx1(z)); obj.ERROR(1);end
            if(~obj.type.isSameSize(x,y,z));obj.ERROR(1);end
            obj.OrigX=x;obj.OrigY=y;obj.OrigZ=z;
        end
        
        %simulation
        function skyline=GetSkyline(obj,dth)
            x=obj.OrigX;y=obj.OrigY;h=obj.OrigZ;
            if(nargin==1);
                dth=1;
            end
            if(~obj.type.isScalar(dth));obj.ERROR(1);end
            switch obj.IsSurfaceData
                case true
                    skyline=sk_sim(obj.Fu,[x,y,h],dth);
                case false
                    skyline=NaN;%–¢ŽÀ‘•
            end
        end
        
    end
    
    
    methods (Access =private)
        function ERROR(obj,code)
            if(code ==1); error('invalid input'); end;
            if(code ==2); error('No info'); end;
            
        end
    end
    
    methods(Static)
    end
end

%%















