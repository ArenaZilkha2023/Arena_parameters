function [vectorx vectory]=buildVector(trajectoryx,trajectoryy)

vectorx=diff(trajectoryx);
vectory=diff(trajectoryy);
timeLine=1:(length(vectorx));
vectorx(isnan(vectorx))=0;
vectory(isnan(vectory))=0;
Ind=vectorx&vectory;
if sum(Ind)>1
    vectorx=interp1(timeLine(Ind),vectorx(Ind),timeLine,'nearest','extrap')';
    vectory=interp1(timeLine(Ind),vectory(Ind),timeLine,'nearest','extrap')';
    
    vector=[vectorx vectory]; 
    norm_vec=sqrt(sum(vector.^2,2));
    vectorx=vectorx./norm_vec;
    vectory=vectory./norm_vec;
end

end