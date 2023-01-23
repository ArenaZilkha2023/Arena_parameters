function [Gender miceIDsNew]=setMiceGenderGV(Params,miceIDs)

for i=1:length(miceIDs)
    
    [indI indJ] = find(strcmpi(Params.mice_3_chips,miceIDs{i}));
    if ~isempty(indI)
        miceIDsNew{i}=Params.mice_3_chips{indI,1};
    else
        miceIDsNew{i}=miceIDs{i};
    end
    
    if ~isempty(find(strcmpi(Params.malesList,miceIDsNew{i})))
        Gender(i)=1;
    else
        Gender(i)=-1;
    end
end
end