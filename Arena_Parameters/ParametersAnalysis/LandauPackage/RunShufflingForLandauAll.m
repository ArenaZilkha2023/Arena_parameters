function [LandauCoefAllEvents]=RunShufflingForLandauAll(rawRanking)
%% Define and reset variables


clear RankingMatrixRandom 

 clear LandauCoefAllEvents
 RankingMatrixRandom=NaN*zeros(length(rawRanking),length(rawRanking));
%% Load parameters
Params = EloRatingParams();

%% 

% Filename=Params.Filename;
ShufflingNumberTimesLandau=Params.ShufflingNumberTimesLandau; %take the same number as randomization of elorating




%% Program

%% Repeat procedure several times to create randomization
hwait = waitbar(0,'Please wait Randomization test for landau is running...');
%% 

for t=1:ShufflingNumberTimesLandau %doing randomization create arbitrary random 

    
    %% Calculate randomic ranking matrix
    C=[0 0.5 1];
    for i=1:length(rawRanking)
        for j=1:length(rawRanking)
            if (j>i)
    RankingMatrixRandom (i,j)=C(randperm(3,1));
    RankingMatrixRandom (j,i)=abs(RankingMatrixRandom(i,j)-1);
            end
        end
    end    

    %% 


%Calculate landau coefficient for all the events

    LandauCoefAllEvents(t)=LandauCoef(RankingMatrixRandom);%for each iteration
    
   
    RankingMatrixRandom=NaN*zeros(length(rawRanking),length(rawRanking));
    
    
    waitbar(t/ShufflingNumberTimesLandau)
end
 close(hwait)
    %% Finish randomization
end





