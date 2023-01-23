function   [Average,ErrorST,DataExtraction]=MeanStdEForParameter(data,day,parameters,RowEachParameter,MouseNumber)
%for each parameter get average and standard desviation
numberOfM=5;
for parameter=1:size(parameters,1)
% For bar plot
%% Locate the data
parameter
Aux=[];
Aux1=[];
if MouseNumber==1 %dominant average over the 2 experiments
  Aux=data(RowEachParameter(parameter):MouseNumber+RowEachParameter(parameter)-1,4:3+day-1,:);
  Average(parameter)=mean([Aux{:,:,1},Aux{:,:,2}],'omitnan');
  ErrorST(parameter)=std([Aux{:,:,1},Aux{:,:,2}],'omitnan')/sqrt(size([Aux{:,:,1},Aux{:,:,2}],2));
  DataExtraction(:,parameter)=([Aux{:,:,1},Aux{:,:,2}])';
 
else %for submissive
     Aux=data(RowEachParameter(parameter)+1:RowEachParameter(parameter)+numberOfM-1,4:3+day-1,:);
     Aux1=[Aux{:,:,1},Aux{:,:,2}];
     
      Average(parameter)=mean(mean(Aux1,'omitnan'));
     ErrorST(parameter)=std(Aux1,'omitnan')/sqrt(size(Aux1,1)*size(Aux1,2));
     DataExtraction(:,parameter)=([Aux{:,:,1},Aux{:,:,2}])';
  
end 
end


end