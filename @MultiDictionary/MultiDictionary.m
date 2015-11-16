classdef MultiDictionary < handle
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
        
        function key = Key(obj)
            key=obj.key
        end
        
        function values = Value(obj)
            values = NaN(size(obj.key,1),obj.s);
            for i=1:obj.s
                values(:,i)=obj.dictionaries{i}.Value();
            end
        end
        
    end
end
