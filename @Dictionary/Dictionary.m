classdef Dictionary < handle

    
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
        
        % key <-> value
        function value = toValue(obj,key)
            value=obj.hash(ikey,key);
        end
        function key = toKey(obj,value)
            key=obj.hash(ivalue,value);
        end
        function key = Key(obj)
            key=obj.Data(:,ikey);
        end
        function value = Value(obj)
            value=obj.Data(:,ivalue);
        end
        
        % check available of key <-> value transrate 
        function TorF = HasUniqueKey(obj,key)
            TorF=obj.HasUnique(ikey,key);
        end
        function TorF = hasUniqueValue(obj,value)
            TorF=obj.HasUnique(ivalue,value);
        end
        %%%
        
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








