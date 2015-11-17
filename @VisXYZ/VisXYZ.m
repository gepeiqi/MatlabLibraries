% Visualize x,y,z 3Ddata
% Declaration : VisXYZobj=VisXYZ(X)
% Input must be : X=[x,y,z] , Size of x,y,z = Nx1
% Methods :
% With VisXYZobj.
%                mesh(~) : mesh plot function. option : (int)resolution
%                surf(~) : surf plot function. option : (int)resolution
%                plot3() : plot3 function colored with height
% End With
classdef VisXYZ < handle
    properties (Access = private)
        type;
        X,Y,Z,Fu;
        IsSurfaceData;
    end
  
    
    methods (Access = public)
        %constractor
        function obj = VisXYZ(X)
            obj.type=Typeof();
            if(~obj.type.isVectorNx3(X)); obj.ERROR(1);end
            x=X(:,1);y=X(:,2);z=X(:,3);
            try
                obj.Fu = scatteredInterpolant(x,y,z);% Z=Fu(X,Y)
                obj.Fu.ExtrapolationMethod = 'none';
                obj.IsSurfaceData=true;
            catch
                obj.IsSurfaceData=false;
            end
            obj.X=x;obj.Y=y;obj.Z=z;
        end
              
        %plot
        function mesh(obj,varargin)
            gridnum=100;
            if(~isempty(varargin));gridnum=varargin{1};end
            if(~obj.IsSurfaceData);obj.ERROR(2);end
            mesh_interp(obj.X, obj.Y, obj.Fu, gridnum)
        end
        function surf(obj,varargin)
            gridnum=100;
            if(~isempty(varargin));gridnum=varargin{1};end
            if(~obj.IsSurfaceData);obj.ERROR(2);end
            surf_interp(obj.X, obj.Y, obj.Fu, gridnum)
        end
        function plot3(obj)
            plot_height_map(obj.X,obj.Y,obj.Z)
        end
    end
    
    
    methods (Access =private)
        function ERROR(~,code)
            if(code ==1); error('invalid input'); end;
            if(code ==2); error('Not surface data'); end; 
        end
    end
    
end

