function   [Average,ErrorST,DataExtraction]=MeanStdEForParameter(data,day,parameters,RowEachParameter,MouseNumber)
%for each parameter get average and standard desviation
for parameter=1:size(parameters,1)
% For bar plot
%% Locate the data
parameter
Aux=[];
Aux=data(RowEachParameter(parameter):MouseNumber+RowEachParameter(parameter)-1,3+day-1);
Average(parameter)=mean(cell2mat(Aux),'omitnan');
ErrorST(parameter)=std(cell2mat(Aux),'omitnan')/sqrt(size(Aux,1));
DataExtraction(:,parameter)=Aux';
end


end