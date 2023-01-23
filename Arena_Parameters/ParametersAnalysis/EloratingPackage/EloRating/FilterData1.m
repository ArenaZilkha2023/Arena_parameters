    function result=FilterData1(x)
 
        if strcmp(x(2),'Y')==1 | strcmp(x(2),'R')==1
         result=1;
        elseif strcmp(x(2),'N')==1
            result=0;
        end
end

