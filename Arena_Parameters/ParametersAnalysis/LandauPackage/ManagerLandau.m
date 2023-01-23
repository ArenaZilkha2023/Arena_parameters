function [ DCIndexAllEvents,LandauCoefAllEvents, LandauCoefPerDay]=ManagerLandau( DataToUse,filename,RankingGlickoLastDay)
%% This script calculates
% 1-Landau h factor which evaluates the extent to which individuals in a
% hierarchy can be linearly ordered-It ranges from 0 no linearlity and 1
% completely linear- with the significance of h determined with
% randomizations
%2-Directional consistency (DC) assesses the degree to which all agonistic interactions in a group occur in the direction from the more dominant individual to the more
% subordinate individual .The index goes from 0 to 1. Zero indicates social
% reciprocity.
%3-David Score and David Score normalizated. Ds=w+w2-l-l2 Animal Behaviour
%2006 -71 585
%4-Steepness measures the unevenness (non uniform) of relative individual dominance
%within the hierarchy.It ranges from 0(difference in dominance ratings
%betweenn adjacently ranked individuals are minimal) to 1(differences in
%dominance ratings between adjacently ranked individuals are maximal)
% despotism is the proportion of all wins by the dominant male over the
% total number of aggressive interactions over the observation period. It
% is a value between 0-1, with 1 indicating that the alpha male performed
% 100% of all aggression with the group.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%for the calculation of linear landau indices
%clear variables
global h
clear SocialMatrixN;
clear SubsetData;
clear MiceID;
clear numRank;
clear rawRanking;
clear RankingMatrix;
clear LandauCoef1;
clear LandauRaw;


%% 
%load variables

SubsetData=DataToUse.SubsetData;
MouseID=DataToUse.MouseID;
IndexChasing=DataToUse.IndexChasing;
IndexBeingChasing=DataToUse.IndexBeingChasing;
IndexEvents=DataToUse.IndexEvents;
begin=DataToUse.begin;
numRank=DataToUse.numR; %related with numeric value of ranking according to last event
%rawRanking=DataToUse.rawR;  %related with the mouse ranking according to last event according to mean elorating from second day
rawRanking=RankingGlickoLastDay;  %related with the mouse ranking according to last day of glicko per day
Days=DataToUse.Days;
DaysWR=DataToUse.DaysWR; 
Int=DataToUse.Int;%index for the end of each day
%% CALCULATE FOR ALL THE EVENTS
hwait = waitbar(0,'Please wait Calculating Landau index...');
%correct the cases for reverse
%% Define which number of mouse is doing and being chasing
SubsetDataWithR=SubsetData(1:Int(length(DaysWR)),:); %without no wanted days
IR=find(strcmp(strrep( SubsetDataWithR(:,IndexEvents),'''',''),'R')==1); %find indexes is reverse
if ~isempty(IR)
%Reverse data when the user marked as R in chasing table
miceRBeingChasing=[];
miceRChasing=[];
miceRBeingChasing=SubsetDataWithR(IR,IndexBeingChasing);
miceRChasing=SubsetDataWithR(IR,IndexChasing);

SubsetDataWithR(IR,IndexChasing)=miceRBeingChasing;
SubsetDataWithR(IR,IndexBeingChasing)=miceRChasing;
end
%% 

%create social matrix frequency

SocialMatrixN=SocialMatix(SubsetDataWithR(:,IndexChasing),SubsetDataWithR(:,IndexBeingChasing),rawRanking); %Change  4 and 5 by general
%nOTE THAT THE PARAMETERS ARE ORDERED ACCORDING TO GLYCKO
%Calculate with the social matrix a ranking matrix

[RankingMatrix PairNoInteractionT]=RankingMatrixSocial(SocialMatrixN)
%% 
% save('test1.mat','SocialMatrixN')
% save('test2.mat','RankingMatrix')
%Calculate landau coefficient for all the events
%% 

%% 

% % 
%Consider modified landau if there are not known interactions
 if isempty(PairNoInteractionT)
  LandauCoefAllEvents=LandauCoef(RankingMatrix);
  
 else
     LandauCoefAllEvents=LandauCoefModified(RankingMatrix,PairNoInteractionT);
 end
 
 %% Calculate the directional consistency index (DC) 
 DCIndexAllEvents=DCIndex(SocialMatrixN);
 %% Calculate David Score index
 [Steepness,NormDS,NormDSWithoutSorting]=DavidScore(SocialMatrixN);
 Despotism1=Despotism(SocialMatrixN);
 %% Calculate Despotism by using ranking of last day 
 
  close(hwait)
  
 %% CALCULATE PER DAY

 %% Calculate landau per day
%  for i=1:length(DaysWR)
%      hwait = waitbar(i/length(DaysWR),'Please wait Calculating Landau index per day...');
%      if i==1
%      clear SocialMatrixPerDay;
%      clear RankingMatrix;
%     
%      
%      SocialMatrixPerDay=SocialMatix(SubsetDataWithR(1:Int(1),IndexChasing),SubsetDataWithR(1:Int(1),IndexBeingChasing),rawRanking);
%      RankingMatrix=RankingMatrixSocial(SocialMatrixPerDay);
%      LandauCoefPerDay(i)=LandauCoef(RankingMatrix);
%      else
%      clear SocialMatrixPerDay;
%      clear RankingMatrix;
%    
%      
%      SocialMatrixPerDay=SocialMatix(SubsetDataWithR(Int(i-1)+1:Int(i),IndexChasing),SubsetDataWithR(Int(i-1)+1:Int(i),IndexBeingChasing),rawRanking);  
%      RankingMatrix=RankingMatrixSocial(SocialMatrixPerDay);
%      LandauCoefPerDay(i)=LandauCoef(RankingMatrix); 
%       
%      end
%      
%      
%      
% close(hwait)
%  end
 %% Validation of landau index by randomization
% [LandauCoefAllEventsRandom,LandauCoefPerDayRandom]=RunShufflingForLandau(SubsetDataWithR,rawRanking,DaysWR,IndexChasing,IndexBeingChasing,Int); %consider data after days selection

 [LandauCoefAllEventsRandom]=RunShufflingForLandauAll(rawRanking); 
  %plot the distribution of randomization test and save into the excel file
 PlotLandauDistributionAll(LandauCoefAllEventsRandom,filename);
%  
%  %Calculate the pvalue for all events

  pvalueAllEvents=Zcalc(LandauCoefAllEventsRandom,LandauCoefAllEvents);
%   
%    %Calculate the pvalue for each day
%    for i=1
%     pvaluePerDay(i)=Zcalc(LandauCoefPerDayRandom(i,:),LandauCoefPerDay(i));
%    end
%  %% Create array to save the data
%   LandauRaw(1,1)={'Days'};
%   LandauRaw(1,2)={'Landau Index per day'};
%    LandauRaw(1,3)={'P- value of landau index'};
%   LandauRaw(1,5)={'Landau Index of all events'};
%    LandauRaw(1,5)={'P- value of Landau Index of all events'};
%    
%   LandauRaw(2:length(LandauCoefPerDay)+1,2)=num2cell(LandauCoefPerDay');
%   LandauRaw(2:length(LandauCoefPerDay)+1,3)=num2cell(pvaluePerDay');
%  
%   LandauRaw(2:length(DaysWR)+1,1)=num2cell([1:length(DaysWR)]');
%  
%   LandauRaw(2,5)=num2cell(LandauCoefAllEvents);
%   LandauRaw(2,6)=num2cell(pvalueAllEvents);
%% ------------plot social matrix
plotSocialMatrixN(SocialMatrixN,filename);

%% Create raw matrix %save social matrix
LandauRaw(1,1)={'chasing Mouse\chased Mouse'};
LandauRaw(1,2:length(rawRanking)+1)=rawRanking(:,1)';
LandauRaw(2:length(rawRanking)+1,2:length(rawRanking)+1)=num2cell(SocialMatrixN);
LandauRaw(1,length(rawRanking)+2)={'Number of chasing'};
LandauRaw(2:length(rawRanking)+1,length(rawRanking)+2)= num2cell(sum(SocialMatrixN,2));%to know who was losser and winner

LandauRaw(2:length(rawRanking)+1,1)=rawRanking(:,1);
LandauRaw(1,length(rawRanking)+3)={'Landau coefficient'};
LandauRaw(1,length(rawRanking)+4)={'p-value'};
LandauRaw(1,length(rawRanking)+5)={'DC-index'};
LandauRaw(2,length(rawRanking)+3)=num2cell(LandauCoefAllEvents);
LandauRaw(2,length(rawRanking)+4)=num2cell(pvalueAllEvents);
LandauRaw(2,length(rawRanking)+5)=num2cell(DCIndexAllEvents);

LandauRaw(size(rawRanking,1)+4,1)={'Ranking matrix'};
LandauRaw(size(rawRanking,1)+5:size(rawRanking,1)+4+size(RankingMatrix,1),1:size(RankingMatrix,2))=num2cell(RankingMatrix);

%% Create matrix for David Score
DavidRaw(1,2)={'Rank David Score'};
DavidRaw(1,2)={'David Score'};
DavidRaw(2:length(NormDSWithoutSorting)+1,2)=num2cell(NormDSWithoutSorting);
DavidRaw(2:length(NormDSWithoutSorting)+1,1)=rawRanking(:,1);
%% Create matrix for resume parameters
ResumeRaw(1,1)={'Landau coefficient'};
ResumeRaw(1,2)={'p-value of Landau coefficient'};
ResumeRaw(1,3)={'DC-index'};
ResumeRaw(1,4)={'Steppness'};
ResumeRaw(1,5)={'Despotism'};

ResumeRaw(2,1)=num2cell(LandauCoefAllEvents);
ResumeRaw(2,2)=num2cell(pvalueAllEvents);
ResumeRaw(2,3)=num2cell(DCIndexAllEvents);
ResumeRaw(2,4)=num2cell(Steepness);
ResumeRaw(2,5)=num2cell(Despotism1);

%% 
%  %% Save data
 if (get(h.Checkbox1,'Value') == 1)
 sheet1=['Socialmatrix_LandauCoefficient'];
 sheet2=['David_Score'];
 sheet3=['Parameters Resume'];
 try
  xlswrite(filename,LandauRaw,sheet1)
  xlswrite(filename,DavidRaw,sheet2)
  xlswrite(filename,ResumeRaw,sheet3)
 catch
    msgbox('CLOSE YOUR EXCEL FILE') 
 end
 

 end


hl=msgbox('Finish landau calculation')

close(hl)
end




%% %% Auxiliary functions
function pvalue=Zcalc(RandDist,Exper)

Zcalc=(Exper-mean(RandDist))/(std(RandDist));
if Zcalc>=0
pvalue=2*(1-normcdf(Zcalc)); %take 2 tails
else
 pvalue=2*(normcdf(Zcalc));   
end
end
