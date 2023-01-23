function Array =  ShufflingGetPvalue(EloeTotal,IndexOrder,TimeCalculation,MouseID,numR)

%% Create array for pvalues
Array={};
Array(2:length(MouseID)+1,1)=strcat('''',MouseID(IndexOrder),'''');
Array(1,2:length(MouseID)+1)=strcat('''',MouseID(IndexOrder),'''');

%% 

%IN THE CASE OF 5 MICE

Delta12=EloeTotal(TimeCalculation,IndexOrder(1),:)-EloeTotal(TimeCalculation,IndexOrder(2),:);
Delta12=reshape(Delta12,[size(Delta12,1)*size(Delta12,3),1,1]);  
numR(1);
numR(2);
Array(2,3)=num2cell(Zcalc(Delta12,(numR(1)-numR(2)))); %pvalue
    
Delta13=EloeTotal(TimeCalculation,IndexOrder(1),:)-EloeTotal(TimeCalculation,IndexOrder(3),:);
Delta13=reshape(Delta12,[size(Delta13,1)*size(Delta13,3),1,1]);
Array(2,4)=num2cell(Zcalc(Delta13,(numR(1)-numR(3)))); %pvalue

Delta14=EloeTotal(TimeCalculation,IndexOrder(1),:)-EloeTotal(TimeCalculation,IndexOrder(4),:);
Delta14=reshape(Delta14,[size(Delta14,1)*size(Delta14,3),1,1]);
Array(2,5)=num2cell(Zcalc(Delta14,(numR(1)-numR(4)))); %pvalue



Delta15=EloeTotal(TimeCalculation,IndexOrder(1),:)-EloeTotal(TimeCalculation,IndexOrder(5),:);
Delta15=reshape(Delta15,[size(Delta15,1)*size(Delta15,3),1,1]);
Array(2,6)=num2cell(Zcalc(Delta15,(numR(1)-numR(5)))); %pvalue



Delta23=EloeTotal(TimeCalculation,IndexOrder(2),:)-EloeTotal(TimeCalculation,IndexOrder(3),:);
Delta23=reshape(Delta23,[size(Delta23,1)*size(Delta23,3),1,1]);
Array(3,4)=num2cell(Zcalc(Delta23,(numR(2)-numR(3)))); %pvalue




Delta24=EloeTotal(TimeCalculation,IndexOrder(2),:)-EloeTotal(TimeCalculation,IndexOrder(4),:);
Delta24=reshape(Delta24,[size(Delta24,1)*size(Delta24,3),1,1]);
Array(3,5)=num2cell(Zcalc(Delta24,(numR(2)-numR(4)))); %pvalue


Delta25=EloeTotal(TimeCalculation,IndexOrder(2),:)-EloeTotal(TimeCalculation,IndexOrder(5),:);
Delta25=reshape(Delta25,[size(Delta25,1)*size(Delta25,3),1,1]);
Array(3,6)=num2cell(Zcalc(Delta25,(numR(2)-numR(5)))); %pvalue



Delta34=EloeTotal(TimeCalculation,IndexOrder(3),:)-EloeTotal(TimeCalculation,IndexOrder(4),:);
Delta34=reshape(Delta34,[size(Delta34,1)*size(Delta34,3),1,1]);
Array(4,5)=num2cell(Zcalc(Delta34,(numR(3)-numR(4)))); %pvalue


Delta35=EloeTotal(TimeCalculation,IndexOrder(3),:)-EloeTotal(TimeCalculation,IndexOrder(5),:);
Delta35=reshape(Delta35,[size(Delta35,1)*size(Delta35,3),1,1]);
Array(4,6)=num2cell(Zcalc(Delta35,(numR(3)-numR(5)))); %pvalue



Delta45=EloeTotal(TimeCalculation,IndexOrder(4),:)-EloeTotal(TimeCalculation,IndexOrder(5),:);
Delta45=reshape(Delta45,[size(Delta45,1)*size(Delta45,3),1,1]);
Array(5,6)=num2cell(Zcalc(Delta45,(numR(4)-numR(5)))); %pvalue
%% Graphical presentation

% figure
% subplot(2,5,1)
% histogram(Delta12)
% subplot(2,5,2)
% histogram(Delta13)
% subplot(2,5,3)
% histogram(Delta14)
% subplot(2,5,4)
% histogram(Delta15)
% subplot(2,5,5)
% histogram(Delta23)
% subplot(2,5,6)
% histogram(Delta24)
% subplot(2,5,7)
% histogram(Delta25)
% subplot(2,5,8)
% histogram(Delta34)
% subplot(2,5,9)
% histogram(Delta35)
% subplot(2,5,10)
% histogram(Delta45)



end
%% 
%% Auxiliary function

function pvalue=Zcalc(Delta,DeltaExp)

Zcalc=(DeltaExp-mean(Delta))/(std(Delta));
if Zcalc>=0
pvalue=2*(1-normcdf(Zcalc)); %take 2 tails
else
 pvalue=2*(normcdf(Zcalc));   
end
end


