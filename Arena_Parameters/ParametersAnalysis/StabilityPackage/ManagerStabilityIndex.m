

function ManagerStabilityIndex(DataToUse,filename)
%Calculate stability index-Idea an index which describes the changes in the
%rank during the time
%% Reset and define variables
clear SubsetEloeDay;
clear RankDif;
clear Spermouse
clear RankPrevious;
clear RankActual;
clear I1;
clear I2;
clear S;
clear PartialCalc;
clear Weight;
clear raw
global h
%% Parameters and data to use
 EloeDayTotalOrder=DataToUse.EloeDayTotalOrder %elorating perday
 MouseOrder=DataToUse.rawR;%mouse order according internal ranking
 EloMatrixOrder=DataToUse.EloMatrixOrder;
 RankPrevious=zeros(length(MouseOrder),1);
 RankActual=zeros(length(MouseOrder),1);
%% take subset 
SubsetEloeDay=cell2mat(EloeDayTotalOrder(2:size(EloeDayTotalOrder(:,1)),2:length(MouseOrder)+1));
%% 
hwait = waitbar(0,'Please wait Calculating Stability index...');
%%Go over the days 
for i=3:size(SubsetEloeDay(:,1)) %begin with second day
      clear RankPrevious;
      clear RankActual;
      clear I1;
      clear I2;
    %% get ranking for actual and previous data
    [B1 I1]=sort(SubsetEloeDay(i-1,:),'descend');
   
    [B2 I2]=sort(SubsetEloeDay(i,:),'descend');
   
    RankPrevious(I1,1)=[1:length(MouseOrder)]';%dont move mouse from place only assign rank 1 to the one with elorating high
    RankActual(I2,1)=[1:length(MouseOrder)]';
    %do difference and save in a matrix per day from second day
    RankDif(i-2,:)=(abs(RankActual-RankPrevious))';
    %% Standarize elo rating from the previous day
    Weight(i-2,:)=SubsetEloeDay(i-1,:)./max(SubsetEloeDay(i-1,:));
    
    PartialCalc(i-2,:)=(RankDif(i-2,:).*Weight(i-2,:));
    %% Calculate stability index define as 1-S (S of Neumann et.al animal behaviour 2011 1-11 , formula on page 5 with a change N-1 number of mice)-If is 1 the rank is not changed
    S(i-2,:)=1-(RankDif(i-2,:).*Weight(i-2,:))/(length(MouseOrder)-1);
  waitbar(0.5)  

end
waitbar(1)
%Calculate overall index for each mouse through all the days
Spermouse=1-sum(PartialCalc,1)./((length(MouseOrder)-1)*(size(SubsetEloeDay,1)-2)); %sum all day
S;
%% 

%%Save data
if  (get(h.Checkbox3,'Value') == 1) & (get(h.Checkbox2,'Value') == 1) & (get(h.Checkbox5,'Value') == 1)%only if for one day was calculated
raw(1,1)={'Days'};
A=DataToUse.rawR;
raw(1,2:size(A,1)+1)=A';
raw(2:size(EloeDayTotalOrder,1)-2,1)=num2cell([2:size(EloeDayTotalOrder,1)-2]');
raw(2:size(S,1)+1,2:size(S,2)+1)=num2cell(S);
raw(size(EloeDayTotalOrder,1),1)={'Overall Stability index'};
raw(size(EloeDayTotalOrder,1),2:length(MouseOrder)+1)=num2cell(Spermouse);

sheet1=['Stability index'];
  try
  xlswrite(filename,raw,sheet1)
  catch
     msgbox('CLOSE YOUR EXCEL FILE') 
  end

end
identMouse=raw(1,:);
 
 %% Calculate stability for each event
 [Stab,Stabtotal]=StabilityCalculationForAllEvents(EloMatrixOrder,MouseOrder);
 
 %% 
 %%Save data
if  (get(h.Checkbox3,'Value') == 1) & (get(h.Checkbox2,'Value') == 1) & (get(h.Checkbox5,'Value') == 1)%only if for one day was calculated
clear raw
A=DataToUse.rawR;
raw(1,1:size(A,1))=A';
raw(2:size(Stab,1)+1,1:size(Stab,2))=num2cell(Stab);
% raw(1,size(A,1)+2)={'Overall Stability index'};
% raw(2:length(MouseOrder)+1,size(A,1)+2)=num2cell(Stabtotal);%check if it
% is right

sheet1=['StabilityIndexAllEvents'];
%   try
  xlswrite(filename,raw,sheet1)
%   catch
%      msgbox('CLOSE YOUR EXCEL FILE') 
%   end
% 
% end
%% %% plot and save S for each day
daysStab=[2:size(EloeDayTotalOrder,1)-2]';
 PlotStability(daysStab,S,filename,identMouse,Stab);

 close(hwait)
 msgbox('Finish stabitity calculation')
 
 
end
%% 


