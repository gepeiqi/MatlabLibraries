classdef FileList < handle
    
%     get Filelist
%     Declaration : FileListobj = FileList(path)
%     Input must be : path =string, you can use "*"(regular expression)
%
%     Methods :
%     With Filelist.
%                 each()     : 1 To NumOfFiles Vector
%                 GetPath(i) : ith file path
%                 GetName(i) : ith file name include ext
%                 GetBodyName(i) : ith file name exclude ext
%                 GetFolder  : folder path which the files exist
%                 n          : Num Of Files
%                 nan(i)     : NaN object (size=Nxi ;N=NumOfFile ,i=input)
%                              you can call this func with No arguments
%                              (this means i=1)
%     End With
%     
%     ex)
%     imglist = FileList(data\img\IMG_*.jpg)
%     siz = imglist.nan(2)
%     for i=imglist.each
%         I=imread(imglist.GetPath(i))
%         siz(i,:)=size(I)
%     end
    
    properties (Access = private)
        D;
        folder;
        N;
    end
  
    
    methods (Access = public)
        %constractor
        function obj = FileList(path)
            
            if(~ischar(path));obj.ERROR(1);end
            obj.D=dir(path);
            FolderFinder=strfind(path,'\');
            switch isempty(FolderFinder)
                case true
                    obj.folder=[];
                case false
                    obj.folder=path(1:FolderFinder(end));
            end
            obj.N=length(obj.D);
        end
        
        %interface
        function i=each(obj)
            i=1:obj.n;
        end
        
        function str=GetPath(obj,i)
            if(i>obj.n);obj.ERROR(1);end
            str=[obj.folder obj.D(i).name];
        end
        
        function str=GetName(obj,i)
            if(i>obj.n);obj.ERROR(1);end
            str=obj.D(i).name;
        end
        
        function str=GetBodyName(obj,i)
            if(i>obj.n);obj.ERROR(1);end
            str0=obj.GetName(i);
            idx=strfind(str0,'.');
            str=str0(1:idx-1);
        end
        
        function str=GetFolder(obj)
            str=obj.folder;
        end
        
        function N = n(obj)
            N=obj.N;
        end

        function NaNobj = nan(obj,i)
            if(nargin==1);i=1;end
            NaNobj=NaN(obj.n,i);
        end
        
        function h(~)
            doc FileList
        end
    end
    
    
    methods (Access =private)
        function ERROR(obj,code)
            if(code ==1); error('invalid input'); end;
            
        end
    end
    
end

%%















