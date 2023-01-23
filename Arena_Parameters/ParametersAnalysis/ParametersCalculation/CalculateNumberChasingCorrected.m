 %% -------------Calculation of chasing with corrected list------------

function [NormDS EloratingAveragePerDay ChasingEventsPerDay BeingChasingEventsPerDay ChasingDurationPerDay  InteractionMatrix ChasingPlusChased BeingChasingDurationPerDay ChasingBeingChasedEventsPerDay]=CalculateNumberChasingCorrected( miceList,ChasingList,EloratingList,NumberDays,Days)

%% Indexes of excel sheet
% 
% DateIndex=find(strcmp(ChasingList(1,:),'Experiment date')==1);
ChasingIndex=find(strcmp(ChasingList(1,:),'Chasing mouse')==1);
ChasedIndex=find(strcmp(ChasingList(1,:),'Chased mouse')==1);
CorrectedIndex=find(strcmp(ChasingList(1,:),'Corrected events')==1);
DIndex=find(strcmp(EloratingList(1,:),'Day')==1);
FrameBeginChasing=find(strcmp(ChasingList(1,:),'Frame begin chasing')==1);
FrameFinishChasing=find(strcmp(ChasingList(1,:),'Frame finish chasing')==1);

TimeBeginChasing=find(strcmp(ChasingList(1,:),'Time begin event')==1);
TimeFinishChasing=find(strcmp(ChasingList(1,:),'Time end event')==1);

AuxHeader=strrep(EloratingList(1,:),'''','');
ChasingList=ChasingList(2:end,:); %Datawithout headers
EloratingList=EloratingList(3:end,:); %Without headers and the row of 1000

% New variables
  ChasingEventsPerDay=zeros(length(miceList),NumberDays);
  BeingChasingEventsPerDay=zeros(length(miceList),NumberDays);
  ChasingBeingChasedEventsPerDay=zeros(length(miceList),NumberDays);
  ChasingPlusChased=zeros(length(miceList),NumberDays);
  ChasingDurationPerDay=zeros(length(miceList),NumberDays);
  BeingChasingDurationPerDay=zeros(length(miceList),NumberDays);
  InteractionMatrix=zeros(length(miceList),length(miceList),NumberDays);
  P=zeros(length(miceList),length(miceList),NumberDays);%for David's score calculation
  W=zeros(length(miceList),NumberDays); %for David's score calculation
  W2=zeros(length(miceList),NumberDays);%for David's score calculation
  
   ll=zeros(length(miceList),NumberDays); %for David's score calculation
   ll2=zeros(length(miceList),NumberDays);
   NormDS=zeros(length(miceList),NumberDays);
   
   %Days of the chasing list
   Every_Day = extractBefore(ChasingList(:,1),'.');%this includes all days without correction
   Every_Day_Elo = extractBefore(EloratingList(:,1),'.');%this includes all days with correction
   
for i=1:NumberDays %Loop on the days
    %find beginning and end of the day
    %DayBeginInd=find(cell2mat(EloratingList(:,DIndex))==i,1,'first');
   % DayEndInd=find(cell2mat(EloratingList(:,DIndex))==i,1,'last');
    ChasingListAux=[];
    EloratingListAux=[];
    %Find the days according to 
    Index=find(strcmp(Every_Day,num2str(Days(i)))==1);
    Index_Elo=find(strcmp(Every_Day_Elo,num2str(Days(i)))==1);
  if isempty(Index)==0 %if there are day    
   DayBeginInd=Index(1);
   DayEndInd =Index(length(Index));
    DayBeginInd_Elo=Index_Elo(1);
    DayEndInd_Elo =Index(length(Index_Elo));
    for j=1:length(miceList) %loop on the mice
        
       %for chasing 
     Ichasing1=[];%clear
     Ichasing2=[];
      Ibeingchasing1=[];%clear
     Ibeingchasing2=[];
     AuxChasingList=[];
     AuxChasedList=[];
     Iadditional1=[];
     Iadditional2=[];
     Iadditional1b=[];
     Iadditional2b=[];
     
     
     ChasingListAux=ChasingList(DayBeginInd:DayEndInd,:);
     
     %Remove quotes from mouse names
     AuxChasingList=strrep(ChasingListAux(:,ChasingIndex),'''',''); %limit to the events of the same day
     AuxChasedList=strrep(ChasingListAux(:,ChasedIndex),'''','');
     
     Ichasing1=strcmp(ChasingListAux(strcmp(AuxChasingList,miceList(j)),CorrectedIndex),'Y'); %take the specific range of the given day,find the given chasing mouse then inside the list look if the event is correct
     Ichasing2=strcmp(ChasingListAux(strcmp(AuxChasedList,miceList(j)),CorrectedIndex),'R'); %take the specific range of the given day,find the given chased mouse then inside the list look if the event is Reverse
      
    
     ChasingEventsPerDay(j,i)=length(Ichasing1(Ichasing1==1))+length(Ichasing2(Ichasing2==1)); %count the number of corrected events
    
    %for being chasing
     Ibeingchasing1=[];%clear
     Ibeingchasing2=[];
     V1=[];
    
     Ibeingchasing1=strcmp(ChasingListAux(strcmp(AuxChasedList,miceList(j)),CorrectedIndex),'Y'); %take the specific range of the given day,find the given chased mouse then inside the list look if the event is correct
     Ibeingchasing2=strcmp(ChasingListAux(strcmp(AuxChasingList,miceList(j)),CorrectedIndex),'R'); %take the specific range of the given day,find the given chasing mouse then inside the list look if the event is Reverse
        
     BeingChasingEventsPerDay(j,i)=length(Ibeingchasing1(Ibeingchasing1==1))+length(Ibeingchasing2(Ibeingchasing2==1)); %count the number of corrected events
     ChasingPlusChased(j,i)= ChasingEventsPerDay(j,i)+  BeingChasingEventsPerDay(j,i);
     %calculate chasing duration per day 
%     Ibeg1= ChasingListAux(strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y'),FrameBeginChasing);
%     Ibeg2= ChasingListAux(strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R'),FrameBeginChasing); 
%      
%     Ifin1= ChasingListAux(strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y'),FrameFinishChasing);
%     Ifin2= ChasingListAux(strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R'),FrameFinishChasing); 
     
    %ChasingDurationPerDay(j,i)=sum([cell2mat(Ifin1)-cell2mat(Ibeg1);cell2mat(Ifin2)-cell2mat(Ibeg2)],'omitnan');
    
     Ibeg1= ChasingListAux(strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y'),TimeBeginChasing);
     Ibeg2= ChasingListAux(strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R'),TimeBeginChasing); 
     
     Ifin1= ChasingListAux(strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y'),TimeFinishChasing);
     Ifin2= ChasingListAux(strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R'),TimeFinishChasing); 
    
     Ibeg1=strrep(Ibeg1,'''','');
     Ibeg2=strrep(Ibeg2,'''','');
     Ifin1=strrep(Ifin1,'''','');
     Ifin2=strrep(Ifin2,'''','');
     
     V1=[etime(datevec(Ifin1,'HH:MM:SS.FFF'),datevec(Ibeg1,'HH:MM:SS.FFF'));etime(datevec(Ifin2,'HH:MM:SS.FFF'),datevec(Ibeg2,'HH:MM:SS.FFF'))];
   if(isempty(V1)== 0)
     ChasingDurationPerDay(j,i)=sum(V1,'omitnan');
   end
 %% about being chased duration  
    
     
     Ibeg1bc= ChasingListAux(strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y'),TimeBeginChasing);
     Ibeg2bc= ChasingListAux(strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R'),TimeBeginChasing);
     
     Ifin1bc= ChasingListAux(strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y'),TimeFinishChasing);
     Ifin2bc= ChasingListAux(strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R'),TimeFinishChasing);
     
    
    
     Ibeg1bc=strrep(Ibeg1bc,'''','');
     Ibeg2bc=strrep(Ibeg2bc,'''','');
     Ifin1bc=strrep(Ifin1bc,'''','');
     Ifin2bc=strrep(Ifin2bc,'''','');
     
     V1bc=[etime(datevec(Ifin1bc,'HH:MM:SS.FFF'),datevec(Ibeg1bc,'HH:MM:SS.FFF'));etime(datevec(Ifin2bc,'HH:MM:SS.FFF'),datevec(Ibeg2bc,'HH:MM:SS.FFF'))];
   if(isempty(V1bc)== 0)
    BeingChasingDurationPerDay(j,i)=sum(V1bc,'omitnan');
   end
  
   
   
   ChasingBeingChasedEventsPerDay(j,i)=BeingChasingDurationPerDay(j,i)+ChasingDurationPerDay(j,i);
    
    %% 
     
    %Calculation of Average Elorating per day
    j
    i
    DayBeginInd_Elo 
    DayEndInd_Elo
    EloratingListAux=EloratingList(DayBeginInd_Elo:DayEndInd_Elo,:);
    
     IndexMouse=find(strcmp(AuxHeader,miceList(j))==1);
     
     EloratingAveragePerDay(j,i)=mean(cell2mat(EloratingListAux(:,IndexMouse)));
    
     %% 
    %--------------Do an interaction matrix for each day Check number of chasing events for each mouse---------------
    
    
         Iadditional1= strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y');  %j is chasing
         Iadditional2= strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R');  
         
         Iadditional1b= strcmp(AuxChasedList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'Y');  %j is chased
         Iadditional2b= strcmp(AuxChasingList,miceList(j))& strcmp(ChasingListAux(:,CorrectedIndex),'R'); 
         
    for t=1:length(miceList) %loop on the second mice
        if t~=j
            %Number of interaction between j and t in the day i
        
            
       InteractionMatrix(j,t,i)= sum(Iadditional1 &  strcmp( AuxChasedList,miceList(t)))+ sum(Iadditional2 &  strcmp( AuxChasingList,miceList(t)));
       
      %The idea is to find events where j is the chasing mouse and t is the chased mouse thus  a matrix is build with the row the chasing mouse and the column the being chasing
      
      %% ------Preparation of David Score--------------------
       %------------Calculation P fraction of time is win and W
       NumberInteractions(j,t,i)=sum(Iadditional1 &  strcmp( AuxChasedList,miceList(t)))+ sum(Iadditional2 &  strcmp( AuxChasingList,miceList(t)))+sum(Iadditional1b &  strcmp( AuxChasingList,miceList(t)))+ sum(Iadditional2b &  strcmp( AuxChasedList,miceList(t)));
      if  NumberInteractions(j,t,i)>0
        P(j,t,i)= (InteractionMatrix(j,t,i)/NumberInteractions(j,t,i));
        W(j,i)=W(j,i)+P(j,t,i);
      end 
      
      
      
      
        end
    end
    
    
    
    end
    %% %%----------- Calculation weighted sume of fraction of times is win for david score----------------
   for i=1:NumberDays %Loop on the days  
   W2(:,i)=P(:,:,i)*W(:,i);
   %%  %% -------------Sum of fractions of losses (escapes) the losses are given by 1-Pij ---------------
   lost(:,:,i)=1-P(:,:,i);
   for u=1:length(miceList)
   lost(u,u,i)=0;
   end
   ll(:,i)=sum(lost(:,:,i),2);
   ll2(:,i)=lost(:,:,i)*ll(:,i);
   DS(:,i)=W(:,i)+W2(:,i)-ll(:,i)-ll2(:,i);
   
   end
   %--------------------Normalize David score for getting David score between 0 and N-1----------------------------
   N=length(miceList);
   NormDS=(DS+N*(N-1)/2)/N; 
   
  
   
 end  
end










end

