function PlotEthogramGroups(SaveFolder,Experiment,Folder_Data,IndexOrder)
%% Read the list of files 
      Folder_Data=char(Folder_Data);
      ListFiles=dir([Folder_Data,'*.mat']);
      
      for i=1:length(ListFiles(not([ListFiles.isdir])))
              I=strfind(ListFiles(i).name,'-');
              Aux=char(ListFiles(i).name);
               ListDates(i)=cellstr(Aux(1:I(1)-1));
      end
   
VectorDate=datevec(unique(ListDates),'DD.MM.YYYY');
VectorDateSort=sortrows(VectorDate,[1,5,3]);
Year=VectorDateSort(:,1);
Month=VectorDateSort(:,5);
Day=VectorDateSort(:,3);
for jj=1:length(Day)
    D=num2str(Day(jj));
    M=num2str(Month(jj));
    Y=num2str(Year(jj));
    B{jj}=strcat(D,'.',M,'.',Y);
end
subStr_arrA{1,:}=B;
% Open new figure

%% Loop over each day
for countDay=1:length(subStr_arrA{1,:})
 %  for countDay=1  
     SelectedFilesNumber=[]; %clearence
     Sleeping=[];
     Hiding=[];
     Food=[];
     Water=[];
     Arena=[];
     SleepingM=[];
     HidingM=[];
     Running=[];
     Static=[];
     Walking=[];
     IsChasingConsider=[];
     IsChasedConsider=[];
     IstogetherConsider=[];
     IsapproachingConsider=[];
     IsBeApproachingConsider=[];
     IsbeavoidingConsider=[];
     IsAvoidingConsider=[];
     SleepingB=[];
     HidingB=[];
     SelectedFilesNumber=find(strcmp(subStr_arrA{1,:}(countDay),ListDates)==1);
     % --------------------------Loop over the addecuate files---------------
      for countFile=1:size(SelectedFilesNumber,2)
     %  for countFile=2
            load(strcat(Folder_Data,ListFiles(SelectedFilesNumber(countFile)).name)); 
            Sleeping=[Sleeping ; Locomotion.AssigRFID.IsSleeping([1:100:size(Locomotion.AssigRFID.IsSleeping,1)],:)];
            Hiding=[Hiding;Locomotion.AssigRFID.Hiding.IsHiding([1:100:size(Locomotion.AssigRFID.Hiding.IsHiding,1)],:)];
            Food=[Food; Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlaceVelocity([1:100:size(Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlaceVelocity,1)],:)];
            Water=[Water;Locomotion.AssigRFID.EatingDrinking.IsDrinking([1:100:size(Locomotion.AssigRFID.EatingDrinking.IsDrinking,1)],:)];
            % --------For movement parameters----------------------------------------
            SleepingM=[SleepingM; Locomotion.AssigRFID.IsSleeping([1:100:size(Locomotion.AssigRFID.IsSleeping,1)],:)];
            HidingM=[HidingM;Locomotion.AssigRFID.Hiding.IsHiding([1:100:size(Locomotion.AssigRFID.Hiding.IsHiding,1)],:)];
            Static=[Static; Locomotion.AssigRFID.Arena.IsStopping([1:100:size(Locomotion.AssigRFID.Arena.IsStopping,1)],:)];
            Running=[Running; Locomotion.AssigRFID.Arena.IsRunning([1:100:size(Locomotion.AssigRFID.Arena.IsRunning,1)],:)];
            Walking=[Walking;Locomotion.AssigRFID.Arena.IsWalking([1:100:size(Locomotion.AssigRFID.Arena.IsWalking,1)],:)];
            
     % ----------------Remove from arena water and food---------------------
             ArenaA=[];
             ArenaA= (Locomotion.AssigRFID.Arena.InArena)& ~(Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlaceVelocity);
             ArenaA=ArenaA & ~(Locomotion.AssigRFID.EatingDrinking.IsDrinking);
             Arena=[Arena; ArenaA([1:100:size(ArenaA,1)],:)];  
      %--------------------Create is chasing, and take the necessary-------------------  
      IsChasing=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2));
      IsChasing=CreateIs(Locomotion.AssigRFID.Behaviour.Chasing.chasing,IsChasing);  
     % IsChasingConsider=[IsChasingConsider;IsChasing([1:50:size(IsChasing,1)],:)]; %take given frames
      IsChasingConsider=[IsChasingConsider;IsChasing];
      %--------------------Create being chasing-------------------------------
      IsChased=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2));
      IsChased=CreateIs(Locomotion.AssigRFID.Behaviour.Chasing.chased,IsChased);  
     %IsChasedConsider=[IsChasedConsider;IsChased([1:50:size(IsChased,1)],:)]; %take given frames
       IsChasedConsider=[IsChasedConsider;IsChased];
      %---------------------------Create together---------------------------
%        Istogether=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2));
%        Istogether=CreateIs(Locomotion.AssigRFID.Behaviour.Together.TogetherAll,Istogether);  
%        IstogetherConsider=[IstogetherConsider;Istogether([1:100:size(Istogether,1)],:)]; %take given frames
       
       SleepingB=[SleepingB; Locomotion.AssigRFID.IsSleeping([1:100:size(Locomotion.AssigRFID.IsSleeping,1)],:)];
       HidingB=[HidingB;Locomotion.AssigRFID.Hiding.IsHiding([1:100:size(Locomotion.AssigRFID.Hiding.IsHiding,1)],:)];
       
       countFile
       %-----------------------------Create approaching and be approaching-------------------------------
        Isapproaching=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2));
        IsBeApproaching=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2));
        
        Isapproaching=CreateIsvs2(Locomotion.AssigRFID.Behaviour.Approaching,Isapproaching);
        IsBeApproaching=CreateIsBevs2(Locomotion.AssigRFID.Behaviour.Approaching,IsBeApproaching);
    
       IsapproachingConsider=[IsapproachingConsider;Isapproaching];
       IsBeApproachingConsider=[IsBeApproachingConsider;IsBeApproaching];
       %------------------------create be avoiding
        Isbeavoiding=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2));
        IsAvoiding=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2)); %escape
        
        Isbeavoiding=CreateIsvs2(Locomotion.AssigRFID.Behaviour.BeAvoiding,Isbeavoiding);
        IsAvoiding=CreateIsBevs2(Locomotion.AssigRFID.Behaviour.BeAvoiding,IsAvoiding);
      
         IsbeavoidingConsider=[ IsbeavoidingConsider;Isbeavoiding];
        IsAvoidingConsider=[IsAvoidingConsider;IsAvoiding];
        
       %---------------other------------------------
       %IsotherBehaviour=zeros(size(Locomotion.AssigRFID.IsSleeping,1),size(Locomotion.AssigRFID.IsSleeping,2));
      %-------------------------------------------------------------------------
     end
     % -------------Save-------------
       SleepingD{countDay}=Sleeping(:,IndexOrder); % Arrange in the order  of dominance
       HidingD{countDay}=Hiding(:,IndexOrder);
       FoodD{countDay}=Food(:,IndexOrder);
       WaterD{countDay}=Water(:,IndexOrder);
       ArenaD{countDay}=Arena(:,IndexOrder);
     %-----------------------Save for movement ethogram----------
      SleepingMD{countDay}=SleepingM(:,IndexOrder); % Arrange in the order  of dominance
      HidingMD{countDay}=HidingM(:,IndexOrder);
      StaticD{countDay}=Static(:,IndexOrder);
      RunningD{countDay}=Running(:,IndexOrder);
      WalkingD{countDay}=Walking(:,IndexOrder);
     %----------------------------- Save for social etogram-----------------
     SleepingBD{countDay}=SleepingB(:,IndexOrder); % Arrange in the order  of dominance
      HidingBD{countDay}=HidingB(:,IndexOrder);
     ChasingD{countDay}=IsChasingConsider(:,IndexOrder);
     ChasedD{countDay}=IsChasedConsider(:,IndexOrder);
     % Remove from together chasing and chased events
%      IstogetherConsider=IstogetherConsider & ~(IsChasingConsider);
%      IstogetherConsider=IstogetherConsider & ~(IsChasedConsider);
%      TogetherD{countDay}=IstogetherConsider(:,IndexOrder);
%        IsapproachingConsider=IsapproachingConsider & ~(IsChasingConsider); %eliminate chasing events 
%        IsbeavoidingConsider==IsbeavoidingConsider & ~(IsChasingConsider); %eliminate chasing events 
%         IsapproachingConsider=IsapproachingConsider & ~(IsChasedConsider); %eliminate be chasing events 
%        IsbeavoidingConsider==IsbeavoidingConsider & ~(IsChasedConsider); %eliminate be chasing events 
       IsapproachingConsiderD{countDay}=IsapproachingConsider(:,IndexOrder);
       IsbeavoidingConsiderD{countDay}=IsbeavoidingConsider(:,IndexOrder);
       IsBeApproachingConsiderD{countDay}= IsBeApproachingConsider(:,IndexOrder);
       IsAvoidingConsiderD{countDay}=IsAvoidingConsider(:,IndexOrder);%mouse escape

end
 %get the order of the mice from the dominant
 MiceListOrder=Locomotion.AssigRFID.miceList(IndexOrder,1);  
 %% ----------Do ethogram groups----------
 cg=gray(5);
 colors={'c','y','m','g','r'};
 DoEthogram(SleepingD,HidingD,FoodD,WaterD,ArenaD,colors,SaveFolder,MiceListOrder,Experiment)
%DoEthogramSecond(SleepingMD,HidingMD,StaticD,RunningD,WalkingD,colors,SaveFolder,MiceListOrder,Experiment)
 %DoEthogramThird(SleepingBD,HidingBD, IsapproachingConsiderD,IsbeavoidingConsiderD,ChasingD,ChasedD,colors)
  %DoEthogramFour(IsapproachingConsiderD,IsbeavoidingConsiderD,ChasingD,ChasedD,IsBeApproachingConsiderD,IsAvoidingConsiderD,colors,SaveFolder,MiceListOrder,Experiment)
     %% 

end