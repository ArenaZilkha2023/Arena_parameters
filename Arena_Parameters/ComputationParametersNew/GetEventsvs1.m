function [AllChasing,AllAvoiding,AllApproaching]  = GetEvents
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
    clear AuxMatrixChasing
    clear AuxMatrixAvoiding
    clear AuxMatrixApproaching
    behaviour=0; %initialization
    
   
   for behaviour=1:3 
    switch(behaviour)
        case 1
             if ~isempty(Locomotion.ChasingAll{1,doing})
             AuxMatrixChasing=Reorder_Social_Parameters(Locomotion.ChasingAll,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
             AllChasingAux=[AllChasingAux; AuxMatrixChasing];
             end
        case 2
             if ~isempty(Locomotion.avoiding{1,doing})
              AuxMatrixAvoiding=Reorder_Social_Parameters(Locomotion.avoiding,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
              AllAvoidingAux=[AllAvoidingAux; AuxMatrixAvoiding]; 
            end
        case 3
              if ~isempty(Locomotion.ApproachingAll{1,doing})
               AuxMatrixApproaching=Reorder_Social_Parameters(Locomotion.ApproachingAll,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
               AllApproachingAux=[AllApproachingAux; AuxMatrixApproaching];
              end
        
    end
   end    
      
   doing     
        
    end    

    
      
        
     

    
      


 %%-------------------------------Sort after each file------------
  if ~isempty(AllApproachingAux)
 AllApproachingAux=Sort_Matrix(AllApproachingAux);
 AllApproaching=[AllApproaching; AllApproachingAux]; 
  end
 
   if ~isempty(AllAvoidingAux)
 AllAvoidingAux=Sort_Matrix(AllAvoidingAux);
 AllAvoiding=[AllAvoiding; AllAvoidingAux]; 
 end
 
 if ~isempty(AllChasingAux)
 AllChasingAux=Sort_Matrix(AllChasingAux);
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

function AuxMatrix=Reorder_Social_Parameters(Social_Parameter,doing,FileName,names,behaviour,RealTime)


      
        
      Mouse_Involved=Social_Parameter{1,doing}(:,3); %mouse affected by the action as:chased,approached mouse, and the mouse who induced avoiding
      
      BegFrameA=Social_Parameter{1,doing}(:,1); %begin frame of chasing
     
      EndFrameA=Social_Parameter{1,doing}(:,2); %finish frame of chasing
     
      
      Mouse_Doing=repmat(doing,length(Mouse_Involved),1);
      ExpDate=repmat(FileName,length(Mouse_Involved),1);
      InitialTime=RealTime(BegFrameA,1); 
      FinalTime=RealTime(EndFrameA,1);
      CorrectSign=repmat('Y',length(Mouse_Involved),1); %add Y to be corrected later
      if behaviour==1 %for chasing
      MarkSmallEvents=Social_Parameter{1,doing}(:,4);
      
%       AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA),num2cell(MarkSmallEvents));
        AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('',(names(Mouse_Doing))',''),strcat('',(names(Mouse_Involved))',''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA),num2cell(MarkSmallEvents));

%      AuxMatrix=sortrows(AuxMatrix,7);%sort according to column seven
     
     
      else
     
%        AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA));

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





