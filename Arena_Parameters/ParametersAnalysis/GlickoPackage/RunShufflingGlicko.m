
function SaveArray=RunShufflingGlicko(DataToUse,FilenameN,...
    DaysWR,IndexChasing,IndexBeingChasing,MouseID,...
    InitialRating,InitialRatingDesviation,Cconstant,Days,GlickoMatrixToDelta)
%% Define and reset variables
global h
clear EloeTotal;
clear EloeDayTotal;
clear NewSubsetData;
clear  dataexp;
clear MouseID;
clear SaveArray;
clear PvalueArrayDay;
clear PvalueArrayLastEvent;
clear  GlickoDayTotal;
%% Load parameters
Params = EloRatingParams();
%k=Params.k;
%initial_rating=Params.initial_rating;
%% Load parameters 
%k=Params.k;
%initial_rating=Params.initial_rating;
% Filename=Params.Filename;
ShufflingNumberTimes=Params.ShufflingNumberTimesGlicko;
%NumberDaysExp=Params.DaysExp;

SubsetData=DataToUse.SubsetData;
IndexChasing=DataToUse.IndexChasing;
IndexBeingChasing=DataToUse.IndexBeingChasing;
IndexEvents=DataToUse.IndexEvents;
%numR=DataToUse.numR; %related with numeric value of ranking according to last event
rawR=DataToUse.rawR;  %related with the mouse ranking according to last event
%numElo=DataToUse.numElo;
%% 


%% 
%% % %% Find the identity of the mouse from column chasing and being chasing

MouseID=unique(vertcat(strrep(SubsetData(:,IndexChasing),'''',''),strrep(SubsetData(:,IndexBeingChasing),'''','')));






%% Program
%% First step-shuffling ALL EVENTS

NumberEvents=size(SubsetData,1)
%% Repeat procedure several times to create randomization
hwait = waitbar(0,'Please wait Randomization test is running...');
for t=1:ShufflingNumberTimes
Idoing = randperm(2*NumberEvents,NumberEvents);
Ibeing = randperm(2*NumberEvents,NumberEvents);

%concatenate doing with being chasing
All=[SubsetData(:,IndexChasing);SubsetData(:,IndexBeingChasing)];

%change who is chasing and being chasing
NewSubsetData=SubsetData;

%change with the permutation the chasing and being chasing columns
NewSubsetData(:,IndexChasing)=All(Idoing');
NewSubsetData(:,IndexBeingChasing)=All(Ibeing');

%Re-evaluate if doing mouse is equal to being thus change its rating
%strcmp(strrep(NewSubsetData(:,IndexChasing),'''',''),strrep(NewSubsetData(:,IndexBeingChasing),'''',''));
I=find(strcmp(strrep(NewSubsetData(:,IndexChasing),'''',''),strrep(NewSubsetData(:,IndexBeingChasing),'''',''))==1);
for i=1:length(I)
   I1=find( strcmp(strrep(NewSubsetData(I(i),IndexChasing),'''',''),MouseID)==1);%found mouse number
   I2=randperm(5,1);
    while I2==I1
        I2=randperm(5,1);
    end
   NewSubsetData(I(i),IndexBeingChasing)=MouseID(I2); 
    
    
    
end

%% Calculate elo rating


[Rmatrixglico,RDmatrixglico] = PreprocessGlicko(NewSubsetData,DaysWR,IndexChasing,IndexBeingChasing,MouseID,...
    InitialRating,InitialRatingDesviation,Cconstant,Days)
Rmatrixglico=Rmatrixglico';

 %% Arrange randomic data per day
%  [eloeday,NumberEventsPerDay,Intervalbegin,Intervalfinish]= EloRatingperDay(NewSubsetData,eloe,MouseID,NumberDaysExp);
%  eloeday=cell2mat(eloeday(2:size(eloeday,1),2:size(eloeday,2)));
 %% 
 GlickoDayTotal(:,:,t)=Rmatrixglico;

%get a multidimensional  matrix for each running
% EloeTotal(:,:,t)=eloe;

waitbar(t/ShufflingNumberTimes)
end
%% Plotting for checking
% figure
% subplot(2,2,1)
% for i=1:size(EloeDayTotal,2)
% err=std(EloeDayTotal(:,i,:),0,3);
% errorbar([0:7]',mean(EloeDayTotal(:,i,:),3),err);
% mean(EloeDayTotal(:,i,:),3);
% hold all;
% end
% ylim([500,1500]);
% title('Elo-rating per day of all mice, taking mean')
% subplot(2,2,2)
% 
% for i=1:size(EloeDayTotal,3)
% 
% plot([0:7]',EloeDayTotal(:,1,i));
% 
% hold all;
% end
% ylim([500,1500]);
% title('Elo-rating per day of first mouse')
% 
% subplot(2,2,3)
% 
% for i=1:size(EloeDayTotal,3)
% 
% plot([0:7]',EloeDayTotal(:,2,i));
% 
% hold all;
% end
% ylim([500,1500]);
% title('Elo-rating per day of second mouse')
% 
% 
% 
% subplot(2,2,4)
% 
% for i=1:size(EloeDayTotal,3)
% 
% plot([0:7]',EloeDayTotal(:,3,i));
% 
% hold all;
% end
% ylim([500,1500]);
% title('Elo-rating per day of second mouse')
%% 

%% Locate in numbers who is the dominant and submissive in the experiment
DominantMouse=find(strcmp(strrep( rawR(1,1),'''',''),strrep( MouseID,'''',''))==1);
SubmisiveMouse=find(strcmp(strrep( rawR(size(rawR,1),1),'''',''),strrep( MouseID,'''',''))==1);


%% Generate difference along the multidimensional matrix of last event
Delta=GlickoDayTotal(size(GlickoDayTotal,1),DominantMouse,:)-GlickoDayTotal(size(GlickoDayTotal,1),SubmisiveMouse,:);
Delta=reshape(Delta,[size(Delta,1)*size(Delta,3),1,1]);



%% Generate delta between all mice
%find index from dominant to submissive
for i=1:length(MouseID)
 IndexOrder(i)=find(strcmp(strrep( rawR(i,1),'''',''),strrep( MouseID,'''',''))==1); 
end
%for last event
 TimeCalculation=size(GlickoDayTotal,1);
 
 %last event experiment
 GlickoMatrixToDeltaLastDay=[GlickoMatrixToDelta(size(GlickoMatrixToDelta,1),IndexOrder)]
 
 PvalueArrayLastEvent=ShufflingGetPvalueGlicko(GlickoDayTotal,IndexOrder,TimeCalculation,MouseID,GlickoMatrixToDeltaLastDay); % get p value from the differences. from more dominant to less dominant mouse
 PvalueArrayLastEvent(1,1)={'Last Event'};
 %% Do the same Per day
%Arrange num elo according to the ranking of the last event

for i=1:length(MouseID)
   GlickoMatrixToDelta1(:,i)=GlickoMatrixToDelta(:,IndexOrder(i)); 
    
end

 for i=1:size(GlickoMatrixToDelta,1)
 clear dataexp;
 dataexp = GlickoMatrixToDelta1(i,:);
 TimeCalculation=i;%this  is the number ofday
 try
 PvalueArrayDay(:,:,i)=ShufflingGetPvalueGlicko(GlickoDayTotal,IndexOrder,TimeCalculation,MouseID,dataexp);
 catch
     
   msgbox('Warning: CHECK THAT YOU ARE NOT SAVING ON ANOTHER EXPERIMENTS DAYS-DO AGAIN!!!') 
     
 end
 PvalueArrayDay(1,1,i)=cellstr(strcat('Day',num2str(i)));
 
 end
%% 
close(hwait)
%% Save data into the structure
SaveArray={};
SaveArray=[PvalueArrayLastEvent;cell(1,size(PvalueArrayLastEvent,2))]; %add row
for i=1:size(PvalueArrayDay,3)
SaveArray=[SaveArray;PvalueArrayDay(:,:,i);cell(1,size(PvalueArrayDay,2))];
end

DataToUse.SaveArrayGlickoPvalue=SaveArray;






%% 


hh=msgbox('The randomic running of glicko was finished')
close(hh)
end

%% 
% %% Auxiliary functions
%   function result=FilterData(x)
%  
%         if strcmp(x,'Y')==1 | strcmp(x,'R')==1
%          result=1;
%         elseif strcmp(x,'N')==1
%             result=0;
%         end
% end












