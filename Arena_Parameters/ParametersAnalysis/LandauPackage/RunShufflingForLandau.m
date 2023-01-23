function [LandauCoefAllEvents,LandauCoefPerDay]=RunShufflingForLandauAll(SubsetDataWithR,rawRanking,DaysWR,IndexChasing,IndexBeingChasing,Int)
%% Define and reset variables

clear SocialMatrixN 
clear SocialMatix
clear RankingMatrix 
clear RankingMatrixSocial
 clear LandauCoefAllEvents
 clear LandauCoefPerDay
%% Load parameters
Params = EloRatingParams();

%% 

% Filename=Params.Filename;
ShufflingNumberTimes=Params.ShufflingNumberTimes; %take the same number as randomization of elorating


%% % %% Find the identity of the mouse from column chasing and being chasing

MouseIDpart=unique(vertcat(strrep(SubsetDataWithR(:,IndexChasing),'''',''),strrep(SubsetDataWithR(:,IndexBeingChasing),'''','')));






%% Program
%% First step-shuffling ALL EVENTS

NumberEvents=size(SubsetDataWithR,1); %consider right events and according the days consider
%% Repeat procedure several times to create randomization
hwait = waitbar(0,'Please wait Randomization test for landau is running...');

for t=1:ShufflingNumberTimes %doing randomization
Idoing = randperm(2*NumberEvents,NumberEvents);
Ibeing = randperm(2*NumberEvents,NumberEvents);

%concatenate doing with being chasing
All=[SubsetDataWithR(:,IndexChasing);SubsetDataWithR(:,IndexBeingChasing)];

%change who is chasing and being chasing
NewSubsetData=SubsetDataWithR;

%change with the permutation the chasing and being chasing columns
NewSubsetData(:,IndexChasing)=All(Idoing');
NewSubsetData(:,IndexBeingChasing)=All(Ibeing');

%Re-evaluate if doing mouse is equal to being thus change its rating
% strcmp(strrep(NewSubsetData(:,IndexChasing),'''',''),strrep(NewSubsetData(:,IndexBeingChasing),'''',''));
I=find(strcmp(strrep(NewSubsetData(:,IndexChasing),'''',''),strrep(NewSubsetData(:,IndexBeingChasing),'''',''))==1);
for i=1:length(I)
   I1=find( strcmp(strrep(NewSubsetData(i,IndexChasing),'''',''),MouseIDpart)==1);%found mouse number
   I2=randperm(5,1);
    while I2==I1
        I2=randperm(5,1);
    end
   NewSubsetData(i,IndexBeingChasing)=MouseIDpart(I2); 
end    
   %% Calculate landau index for the randomization
   %create social matrix frequency

    SocialMatrixN=SocialMatix(NewSubsetData(:,IndexChasing),NewSubsetData(:,IndexBeingChasing),rawRanking); %Change  4 and 5 by general

%Calculate with the social matrix a ranking matrix

    RankingMatrix=RankingMatrixSocial(SocialMatrixN);


%Calculate landau coefficient for all the events

    LandauCoefAllEvents(t)=LandauCoef(RankingMatrix);%for each iteration
    
    %% Calculation for each day- for each day is a dristribution for h
    
    for i=1:length(DaysWR)
    
     if i==1
     clear SocialMatrixPerDay;
     clear RankingMatrix;
    
     
     SocialMatrixPerDay=SocialMatix(NewSubsetData(1:Int(1),IndexChasing),NewSubsetData(1:Int(1),IndexBeingChasing),rawRanking);
     RankingMatrix=RankingMatrixSocial(SocialMatrixPerDay);
     LandauCoefPerDay(i,t)=LandauCoef(RankingMatrix);
     else
     clear SocialMatrixPerDay;
     clear RankingMatrix;
   
     
     SocialMatrixPerDay=SocialMatix(NewSubsetData(Int(i-1)+1:Int(i),IndexChasing),NewSubsetData(Int(i-1)+1:Int(i),IndexBeingChasing),rawRanking);  
     RankingMatrix=RankingMatrixSocial(SocialMatrixPerDay);
     LandauCoefPerDay(i,t)=LandauCoef(RankingMatrix); 
      
     end
     
    
    
    
    
    %% Finish randomization
    
    end
waitbar(t/ShufflingNumberTimes)
end



end

