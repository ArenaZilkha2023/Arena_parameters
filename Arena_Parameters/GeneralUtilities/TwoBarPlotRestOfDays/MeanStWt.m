function [Average,ErrorST,DataExtraction]=MeanStWt(data,Firstday,Finalday,parameters,RowEachParameter,MouseNumber,NumWtexp)

%for each parameter get average and standard desviation
for parameter=1:size(parameters,1)
% For bar plot
%% Locate the data
parameter
Aux=[];
Aux1=[];
Aux1=data(RowEachParameter(parameter):MouseNumber+RowEachParameter(parameter)-1,3+Firstday-1:3+Finalday-1,1:NumWtexp);
%concatenate the data
Aux=reshape(Aux1,size(Aux1,1)*NumWtexp*size(Aux1,2),1);

Average(parameter,1)=mean(cell2mat(Aux),'omitnan');
ErrorST(parameter,1)=std(cell2mat(Aux),'omitnan')/sqrt(size(Aux,1));
DataExtraction(:,parameter)=Aux';
end



end