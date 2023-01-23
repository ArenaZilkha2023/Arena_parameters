function AllChasing = GetEvents
%Create Excel file with chasing events
%Create Excel file with avoidance and approaching events
%% 
%%------------------Parameters----------------------------
Params=ParametersComputeAll;
%% ------------------------------------Read mat files----------------------
MatFilesobj=FilesTreat; %use class Files Treat
MatFilesobj.directory=Params.resultsDir; %where are the results
MatFilesobj.extension='.mat';
NumMat=MatFilesobj.NumFiles(MatFilesobj.ListFiles);
% DateFiles=MatFilesobj.DateFiles(MatFilesobj.ListFiles,NumMat);
AllFiles=MatFilesobj.ListFiles;
AllChasing={};
AllAvoiding={};
AllApproaching={};

%% -------------------------------Loop over the mat files---------------------------------------
for i=1:NumMat %loop over the mat files
load(strcat(Params.resultsDir,'\',AllFiles(i).name));
names=Locomotion.miceList;
clear AllChasingAux
AllChasingAux={};

clear AllAvoidingAux
AllAvoidingAux={};

clear AllApproachingAux
AllApproachingAux={};

%% -----------------------------loop over the mice---------------------------
for doing=1:length(names)
    %% clear variables
    clear AuxMatrix
 
    clear chased
    clear BegFrame
    clear EndFrame
    clear chasing
    
    clear ExpDate
    clear InitialTime
    clear FinalTime
    clear CorrectSign
    
    if ~isempty(Locomotion.ChasingAll{1,doing})
      
        
      chased=Locomotion.ChasingAll{1,doing}(:,3)
      
      BegFrameA=Locomotion.ChasingAll{1,doing}(:,1);
      BegFrame=Locomotion.RepeatedFrames(BegFrameA);%real frame
      EndFrameA=Locomotion.ChasingAll{1,doing}(:,2);
      EndFrame=Locomotion.RepeatedFrames(EndFrameA);%real frame
      
      chasing=repmat(doing,length(chased),1);
      ExpDate=repmat(AllFiles(i).name,length(chased),1);
      InitialTime=Locomotion.TimeWithoutRepeats(BegFrameA,1);
      FinalTime=Locomotion.TimeWithoutRepeats(EndFrameA,1);
      CorrectSign=repmat('Y',length(chased),1); %add Y to be corrected later
      MarkSmallEvents=Locomotion.ChasingAll{1,doing}(:,6);
      
      AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(chasing))',''''),strcat('''',(names(chased))',''''),cellstr(CorrectSign),num2cell(BegFrame),num2cell(EndFrame),num2cell(MarkSmallEvents));

%      AuxMatrix=sortrows(AuxMatrix,7);%sort according to column seven
     AllChasingAux=[AllChasingAux; AuxMatrix]; 
        
        
    end    




end
 %%-------------------------------Sort after each file------------
 if ~isempty(AllChasingAux)
 A=AllChasingAux(:,2)
 TimeAux=datenum(AllChasingAux(:,2));
 [B,I]=sort(TimeAux);
 AllChasingAux=AllChasingAux(I,:); %sort for each date
 AllChasing=[AllChasing; AllChasingAux]; 
 else
     continue;
 end
 i
    end
%% 


end

%% -------------------------Auxiliary functions-----------------------------------------------------

%% -----------Function to reorder the information of the social parameters----------------------

function AuxMatrix=Reorder_Social_Parameters(Social_Parameter,RepeatedFrames,doing,FileName,TimeWithoutRepeats,names)


      
        
      Mouse_Involved=Social_Parameter{1,doing}(:,3); %mouse affected by the action as:chased,approached mouse, and the mouse who induced avoiding
      
      BegFrameA=Social_Parameter{1,doing}(:,1);
      BegFrame=RepeatedFrames(BegFrameA);%real frame
      EndFrameA=Social_Parameter{1,doing}(:,2);
      EndFrame=RepeatedFrames(EndFrameA);%real frame
      
      Mouse_Doing=repmat(doing,length(Mouse_Involved),1);
      ExpDate=repmat(FileName,length(Mouse_Involved),1);
      InitialTime=TimeWithoutRepeats(BegFrameA,1);
      FinalTime=TimeWithoutRepeats(EndFrameA,1);
      CorrectSign=repmat('Y',length(Mouse_Involved),1); %add Y to be corrected later
      if ~isempty(Social_Parameter{1,doing}(:,6))
      MarkSmallEvents=Social_Parameter{1,doing}(:,6);
      
      AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrame),num2cell(EndFrame),num2cell(MarkSmallEvents));

%      AuxMatrix=sortrows(AuxMatrix,7);%sort according to column seven
     
     
      else
     
       AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrame));

      end   
        
        


end





%% 





