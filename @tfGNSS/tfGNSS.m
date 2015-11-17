classdef tfGNSS < handle
%     GNSS transformation
%     Declaration : tfGNSSobj = tfGNSS()
%
%     Methods :
%     With tfGNSS.
%                 SetENUOriginalPoint(format,origin) : format='llh' or
%                 'ecef' , origin = 3x1 vector
%                 GetENUFromLLH(llh)    : llh = 3xN vector
%                 GetLLHFromENU(enu)    : enu = 3xN vector
%     End With


    properties (Access = private)
        type;
        HasOriginalPoint;
        OriginalLLH;
        OriginalECEF;
        
    end
  
    
    methods (Access = public)
        %constractor
        function obj = tfGNSS()
            obj.type=Typeof();
            obj.HasOriginalPoint =false;
        end
        
        %interface
        function SetENUOriginalPoint(obj,format,origin)
            if(~obj.type.isVector3(origin')); obj.ERROR(1);end
            if(obj.HasOriginalPoint); obj.ERROR(2); end
            switch format
                case 'llh'
                    obj.SetOrigLLH(origin)
                case 'ecef'
                    objSetOrigECEF(origin)
                otherwise
                    obj.ERROR(1) 
            end
        end
        
        %processing
        function enu = GetENUFromLLH(obj,llh)
            if(~obj.HasOriginalPoint);obj.ERROR(4);end
            if(~obj.type.isVectorNx3(llh)); obj.ERROR(1);end
            enu=(llh2enu(llh',obj.OriginalLLH'))';
        end
        function llh = GetLLHFromENU(obj,enu)
            if(~obj.HasOriginalPoint);obj.ERROR(4);end
            if(~obj.type.isVectorNx3(enu)); obj.ERROR(1);end
            llh=(enu2llh(enu',obj.OriginalLLH'))';
        end
        
        %help
        function h(~)
            doc tfGNSS
        end
    end
    
    
    methods (Access =private)
        function ERROR(obj,code)
            if(code ==1); error('invalid input'); end;
            if(code ==2); error('cannot set original point only once'); end; 
            if(code ==3); error('unexpected error'); end; 
            if(code ==4); error('original point undefined'); end; 
            
        end
        function SetOrigLLH(obj,llh)
            obj.OriginalLLH=llh;
            obj.OriginalECEF=llh2xyz(llh');
            obj.HasOriginalPoint=true;
            
        end
        function SetOrigECEF(obj,xyz)
            obj.OriginalECEF=xyz;
            obj.OriginalLLH=xyz2llh(xyz');
            obj.HasOriginalPoint=true;
        end
    end
    
end

%%















