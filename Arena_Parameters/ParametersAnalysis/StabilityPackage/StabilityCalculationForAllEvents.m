function  [S Spermouse]=StabilityCalculationForAllEvents(EloMatrixOrder,MouseOrder)

%reset and define variables

clear SubsetEloRating;
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
%% Subset 
SubsetEloRating=cell2mat(EloMatrixOrder(2:end,4:3+length(MouseOrder)));


%Stability calculation for all events
hwait = waitbar(0,'Please wait Calculating Stability index for all the events...');
%%Go over the days 
for i=3:size(SubsetEloRating(:,1)) %begin with second day
      clear RankPrevious;
      clear RankActual;
      clear I1;
      clear I2;
      
      save('test1.mat','SubsetEloRating')
    %% get ranking for actual and previous data
    %% Check if there is repetition in the data ,if not the ranking is the same for the repeated data
    if length(unique(SubsetEloRating(i-1,:)))< length(SubsetEloRating(i-1,:))
    %first assign ranking to unique data
    [B3 I3]=unique(sort(SubsetEloRating(i-1,:),'descend'),'stable');
     for j=1:length(B3) 
         Index=find(SubsetEloRating(i-1,:)==B3(1,j));
         RankPrevious(Index,1)=j;
     end
    else
    [B1 I1]=sort(SubsetEloRating(i-1,:),'descend');
    RankPrevious(I1,1)=[1:length(MouseOrder)]';%dont move mouse from place only assign rank 1 to the one with elorating high
    end
    if length(unique(SubsetEloRating(i,:)))< length(SubsetEloRating(i,:))
      [B4 I4]=unique(sort(SubsetEloRating(i,:),'descend'),'stable');
     for j=1:length(B4) 
         Index1=find(SubsetEloRating(i,:)==B4(1,j));
         RankActual(Index1,1)=j;
     end  
    else
    [B2 I2]=sort(SubsetEloRating(i,:),'descend');
     RankActual(I2,1)=[1:length(MouseOrder)]';
    end
    %% 
   
    
   
    %do difference and save in a matrix per day from second day
    RankDif(i-2,:)=(abs(RankActual-RankPrevious))';
    %% Standarize elo rating from the previous day
    Weight(i-2,:)=SubsetEloRating(i-1,:)./max(SubsetEloRating(i-1,:));
    
    PartialCalc(i-2,:)=(RankDif(i-2,:).*Weight(i-2,:));
    %% Calculate stability index define as 1-S (S of Neumann et.al animal behaviour 2011 1-11 , formula on page 5 with a change N-1 number of mice)-If is 1 the rank is not changed
    S(i-2,:)=1-(RankDif(i-2,:).*Weight(i-2,:))/(length(MouseOrder)-1);
  waitbar(0.5)  

end
waitbar(1)
close(hwait)

msgbox('Finish stability for all the events')
%Calculate overall index for each mouse through all the days
Spermouse=1-sum(PartialCalc,1)./((length(MouseOrder)-1)*(size(SubsetEloRating,1)-2)); %sum all day
% save('test2.mat','S')
% save('test3.mat','RankDif')
% save('test1.mat','SubsetEloRating')
end

