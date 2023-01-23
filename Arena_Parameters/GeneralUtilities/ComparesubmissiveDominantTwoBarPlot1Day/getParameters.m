function  [Parameters,RowEachParameter]=getParameters(ColumnParameters)

Aux=ones(size(ColumnParameters,1),1)

    for count=1:size(ColumnParameters,1)
    
         flag=isnan(ColumnParameters{count});
         
         if flag==1
            Aux(count,1)=0; 
             
         end
    
    
    end

RowEachParameter=find(Aux==1);
Parameters=ColumnParameters(RowEachParameter,1);



end