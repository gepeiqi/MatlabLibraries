classdef MultiDictionary < handle
%     Pairing more than 2 vectors key and value
%     Declaration : MultiDictionaryobj = MultiDictionary(key,values)
%     Input must be : Size of key = Nx1 , values =NxM
% 
%     Methods :
%     With MultiDictionary.
%       Mode_OneToOne  : mode setting :if obj has No matching key, return NaN
%       Mode_Complete  : mode setting :if obj has No matching key , return
%       interped value
%       toValue(key) : key -> value;input size =Mx1 , returns Mx1
%       Key/Value(i)   : returns ith key/value , i=Mx1 , 
%                        you can omit input "i" , then i=size of key
%     End With
    properties (Access = private)
        dictionaries;
        s;
        Keymin;Keymax;
        key;
    end
    
    methods (Access = public)
        %constractor
        function obj = MultiDictionary(key,values)
            obj.s=size(values,2);
            for i=1:obj.s
                obj.dictionaries{i}=Dictionary(key,values(:,i));
            end
            obj.Keymin=min(key);
            obj.Keymax=max(key);
            obj.key=key;
        end
        
        %mode edit
        function Mode_OneToOne(obj)
            for i=1:obj.s
                obj.dictionaries{i}.Mode_OneToOne;
            end
        end
        function Mode_Complete(obj)
            for i=1:obj.s
                obj.dictionaries{i}.Mode_Complete;
            end
        end
        
        %value return
        function values = toValue(obj,key)
            values = NaN(size(key));
            for i=1:obj.s
                values(:,i)=obj.dictionaries{i}.toValue(key);
            end
        end
        
        function key = Key(obj,i)
            if(nargin==1)
                key=obj.key;
            elseif(nargin==2)
                key=obj.key(i);
            end
        end
        
        function values = Value(obj,i)
            if(nargin==1)
                values = NaN(size(obj.key,1),obj.s);
                for i=1:obj.s
                    values(:,i)=obj.dictionaries{i}.Value();
                end
            elseif(nargin==2)
                values = NaN(size(obj.key(i),1),obj.s);
                for i=1:obj.s
                    values(:,i)=obj.dictionaries{i}.Value(i);
                end
            end
        end
        %help
        function h(~)
            doc MultiDictionary
        end
        
    end
end
