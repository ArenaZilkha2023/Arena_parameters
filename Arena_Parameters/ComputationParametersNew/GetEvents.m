function [AllChasing AllApproaching  AllBeAvoiding]  = GetEvents
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
AllApproaching={};
AllBeAvoiding={};

%% -------------------------------Loop over the mat files---------------------------------------
for i=1:NumMat %loop over the mat files
    strcat(Params.resultsDir,'\',AllFiles(i).name)
load(strcat(Params.resultsDir,'\',AllFiles(i).name));
names=Locomotion.AssigRFID.miceList;
clear AllChasingAux
AllChasingAux={};
AllApproachingAux={};
AllBeAvoidingAux={};

%% -----------------------------loop over the mice---------------------------
for doing=1:length(names)
    %% clear variables
    clear AuxMatrixChasing
 
    behaviour=0; %initialization
    
   
   for behaviour=1:3 
    switch(behaviour)
        case 1
             if ~isempty(Locomotion.AssigRFID.Behaviour.Chasing.chasing{1,doing})
             AuxMatrixChasing=Reorder_Social_Parameters(Locomotion.AssigRFID.Behaviour.Chasing.chasing,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
             AllChasingAux=[AllChasingAux; AuxMatrixChasing];
             end
          case 2
             if ~isempty(Locomotion.AssigRFID.Behaviour.Approaching{1,doing})
             AuxMatrixApproaching=Reorder_Social_Parameters(Locomotion.AssigRFID.Behaviour.Approaching,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
             AllApproachingAux=[AllApproachingAux; AuxMatrixApproaching];
             end
          case 3
             if ~isempty(Locomotion.AssigRFID.Behaviour.BeAvoiding{1,doing})
             AuxMatrixBeAvoiding=Reorder_Social_Parameters(Locomotion.AssigRFID.Behaviour.BeAvoiding,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
             AllBeAvoidingAux=[AllBeAvoidingAux; AuxMatrixBeAvoiding];
             end
    end
   end    
      
   doing     
        
    end    


 %%-------------------------------Sort after each file------------

 
 if ~isempty(AllChasingAux)
 AllChasingAux=Sort_Matrix(AllChasingAux);
 AllChasing=[AllChasing; AllChasingAux]; 
 else
     continue;
 end
 
 if ~isempty(AllApproachingAux)
 AllApproachingAux=Sort_Matrix(AllApproachingAux);
 AllApproaching=[AllApproaching; AllApproachingAux]; 
 else
     continue;
 end
 
 
 if ~isempty(AllBeAvoidingAux)
 AllBeAvoidingAux=Sort_Matrix(AllBeAvoidingAux);
 AllBeAvoiding=[AllBeAvoiding; AllBeAvoidingAux]; 
 else
     continue;
 end
 
 
 i
    end
%% 


end

%% -------------------------Auxiliary functions-----------------------------------------------------

%% -----------Function to reorder the information of the social parameters----------------------

function AuxMatrix=Reorder_Social_Parameters(Social_Parameter,doing,FileName,names,behaviour,RealTime)


      
        
      Mouse_Involved=Social_Parameter{1,doing}(:,3); %mouse affected by the action as:chased mouse
      
      BegFrameA=Social_Parameter{1,doing}(:,1); %begin frame of chasing
     
      EndFrameA=Social_Parameter{1,doing}(:,2); %finish frame of chasing
     
      
      Mouse_Doing=repmat(doing,length(Mouse_Involved),1);
      ExpDate=repmat(FileName,length(Mouse_Involved),1);
     if iscell(BegFrameA) 
      BegFrameA=cell2mat(BegFrameA);
      EndFrameA=cell2mat(EndFrameA);
      InitialTime=RealTime(BegFrameA,1); 
      FinalTime=RealTime(EndFrameA,1);
     else
        InitialTime=RealTime(BegFrameA,1); 
        FinalTime=RealTime(EndFrameA,1);  
     end
      CorrectSign=repmat('Y',length(Mouse_Involved),1); %add Y to be corrected later
      names=names';
      if behaviour==1 %for chasing
%      MarkSmallEvents=Social_Parameter{1,doing}(:,4);
      
%       AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA),num2cell(MarkSmallEvents));
        AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA));

%      AuxMatrix=sortrows(AuxMatrix,7);%sort according to column seven
     
     
      else
     
%        AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA));
         Mouse_Involved=cell2mat(Mouse_Involved);
         AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('',(names(Mouse_Doing))',''),strcat('',(names(Mouse_Involved))',''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA));

      end   
        
        


end

%% ---------------------------Sort the matrix--------------------------
function All=Sort_Matrix(All)
 A=All(:,2)
 TimeAux=datenum(All(:,2));
 [B,I]=sort(TimeAux);
 All=All(I,:); %sort for each date



end




%% 





