function [Raw,RawStage1,RawStage2]=ReorderData(Parameters,AverageExp1,AverageExp2,labels1,AverageTotalStage1,AverageTotalStage2,StandardDesviationStageO1,StandardDesviationStageO2)
Raw(1,1)={'Experiments'};
Raw(1,2)={'Parameters'};
Raw(1,3)={'Mean first day'};
Raw(1,4)={'Mean 2-6 day'};
Raw(1,5)={'Total mean first day'};
Raw(1,6)={'Total mean 2-6 day'};
Raw(1,7)={'Total sd first day'};
Raw(1,8)={'Total sd 2-6 day'};
Raw(1,9)={'Outliers first day'};
Raw(1,10)={'Outliers 2-6 day'};

RawStage1(1,2:size(labels1,1))=(labels1(1:(size(labels1,1)-1),1))';
RawStage2(1,2:size(labels1,1))=(labels1(1:(size(labels1,1)-1),1))';
RawStage1(2:size(Parameters)+1,1)=Parameters;
RawStage2(2:size(Parameters)+1,1)=Parameters;


for p=1:(size(Parameters))
p
initial=1+(p-1)*(size(labels1,1)-1)+1;
final=1+(p-1)*(size(labels1,1)-1)+(size(labels1,1)-1)-1+1;
    
Raw(initial:final,1)=labels1(1:(size(labels1,1)-1),1);%  experiments
Raw(initial:final,2)=repmat(Parameters(p),size(labels1,1)-1,1);
Raw(initial:final,3)=num2cell((AverageExp1(p,:))'); % average stage 1 for each experiment
Raw(initial:final,4)=num2cell((AverageExp2(p,:))');% average stage 2 for each experiment
Raw(initial:final,5)=num2cell(repmat(AverageTotalStage1(p,1),size(labels1,1)-1,1)); %total average of the given parameter
Raw(initial:final,6)=num2cell(repmat(AverageTotalStage2(p,1),size(labels1,1)-1,1));
Raw(initial:final,7)=num2cell(repmat(StandardDesviationStageO1(1,p),size(labels1,1)-1,1));% standard desviation of the given parameter
Raw(initial:final,8)=num2cell(repmat(StandardDesviationStageO2(1,p),size(labels1,1)-1,1));

% create logical to find outliers- for stage 1
Istage1= (AverageExp1(p,:)> (AverageTotalStage1(p,1)+2*StandardDesviationStageO1(1,p))| AverageExp1(p,:)< (AverageTotalStage1(p,1)-2*StandardDesviationStageO1(1,p))); 
Istage1=Istage1';    
% create logical to find outliers- for stage 2
Istage2= (AverageExp2(p,:)> (AverageTotalStage2(p,1)+2*StandardDesviationStageO2(1,p))| AverageExp2(p,:)< (AverageTotalStage2(p,1)-2*StandardDesviationStageO2(1,p))); 
Istage2=Istage2';    
Raw(initial:final,9)=num2cell(Istage1); %1 indicate outlier in stage 1
Raw(initial:final,10)=num2cell(Istage2); %1 indicate outlier in stage 2

RawStage1(p+1,2:size(labels1,1))=num2cell(Istage1');
RawStage2(p+1,2:size(labels1,1))=num2cell(Istage2');
end


end