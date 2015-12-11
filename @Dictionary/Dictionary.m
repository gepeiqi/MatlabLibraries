classdef Dictionary < handle    
%     Pairing 2 vectors key and value
%     Declaration : Dictionaryobj = Dictionary(key,value)
%     Input must be : Size of key,value = Nx1
% 
%     Methods :
%     With Dictionary.
%       Mode_OneToOne  : mode setting :if obj has No matching key/value , return NaN
%       Mode_Complete  : mode setting :if obj has No matching key/value , return
%                        interped value/key
%       toValue/Key(key/value) : key <-> value;input size =Mx1 , returns Mx1
%       Key/Value(i)   : returns ith key/value , i=Mx1 , 
%                        you can omit input "i" , then i=size of key
%       HasUniqueKey/Value(value/key):  check availablity of key <-> value transrate 
%     End With


    %% Private properties
    properties (Access = public)
        Keymin;Keymax;Valuemin;Valuemax;
        KeyToValue_griddable;ValueToKey_griddable;
    end
    properties (Access = private)
        Data,N,MODE;
        SData;
        Griddable;
        F;
    end
    
    
    %% Public methods
    methods (Access = public)
        %constractor
        function obj = Dictionary(key,value)
            % obj = Dictionary(key,value)
            if(size(key,1)==size(value,1) && size(key,2)==1 && size(value,2)==1 )
                obj.Data=[key value];
                obj.N=size(key,1);
                obj.MODE=OneToOne();
                for i=[ikey ivalue]
                    obj.SData{i}=matsort(obj.Data,i);
                    obj.Griddable(i)=isGriddable(obj.SData{i},i);                
                    if(obj.Griddable(i))
                        obj.F{i}=griddedInterpolant(obj.SData{i}(:,i),obj.SData{i}(:,opp(i)));
                    end
                end
            else
                obj.ERROR(1);
            end
            obj.Keymin=min(key);
            obj.Keymax=max(key);
            obj.Valuemin=min(value);
            obj.Valuemax=max(value);
            obj.KeyToValue_griddable=obj.Griddable(ikey);
            obj.ValueToKey_griddable=obj.Griddable(ikey);
        end
        % mode edit
        function Mode_OneToOne(obj)
            obj.MODE=OneToOne;
        end
%         function setMode_Nearest(obj)
%             obj.MODE=Nearest;
%         end
        function Mode_Complete(obj)
            obj.MODE=Complete;
        end
        
        function Mode_Extrap(obj)
            obj.MODE=Extrap;
        end
        
        % key <-> value
        function value = toValue(obj,key)
            value=obj.hash(ikey,key);
        end
        function key = toKey(obj,value)
            key=obj.hash(ivalue,value);
        end
        function key = Key(obj,i)
            if(nargin==1)
                key=obj.Data(:,ikey);
            elseif(nargin==2)
                key=obj.Data(i,ikey);
            end
        end
        function value = Value(obj,i)
            if(nargin==1)
                value=obj.Data(:,ivalue);
            elseif(nargin==2)
                value=obj.Data(i,ivalue);
            end
        end
        
        % check available of key <-> value transrate 
        function TorF = HasUniqueKey(obj,key)
            TorF=obj.HasUnique(ikey,key);
        end
        function TorF = hasUniqueValue(obj,value)
            TorF=obj.HasUnique(ivalue,value);
        end
        %%%
        
        %help
        function h(~)
            doc Dictionary
        end
        
    end
    
    %% Private methods
    methods(Access = private)
        
        function rtn=HasUnique(obj,col,target)%
            if(size(target,2)~=1); obj.ERROR(1); end
            Ni=size(target,1);
            rtn=NaN(Ni,1);
            for i=1:Ni
                rtn(i,1)=sum(obj.Data(:,col)==target(i))==1;
            end
        end
        
        function rtn=hash(obj,col,target)
            TorF=obj.HasUnique(col,target);
            Ni=size(target,1);
            rtn=NaN(Ni,1);
            for i=1:Ni
                switch obj.MODE
                    case OneToOne
                        if(TorF(i)==1)
                            rtn(i)=obj.Data(obj.Data(:,col)==target(i),opp(col));
                        end
                    case Complete
                        if(obj.Griddable(col))
                            rtn(i)=obj.F{col}(target(i));
                        end
                    case Extrap
                        rtn(i)=extrap1(obj.Data(:,col),obj.Data(:,opp(col)),target(i));
                end
            end
        end
        
        function ERROR(code)
            if(code==1); error('input must be Nx1 vector \n')
            end
        end
    end
    
     
end

%% define
function col = ikey()
    col=1;
end

function col = ivalue()
    col=2;
end

function col = opp(co)%opposite
    if(co==1); col=2; end;
    if(co==2); col=1; end;
end

function mode = OneToOne()
    mode=1;
end

function mode = Nearest()
    mode=2;
end

function mode = Complete()
    mode=3;
end

function mode = Extrap()
    mode=4;
end
%%local func
function SA=matsort(A,col)
    [~,idx]=sort(A(:,col));
    for i=1:size(A,2)
        SA(:,i)=A(idx,i);
    end
end

function TorF = isGriddable(A,col)
    try
        interp1(A(:,col),A(:,opp(col)),A(col,1));
        TorF=1;
    catch
        TorF=0;
    end
end








