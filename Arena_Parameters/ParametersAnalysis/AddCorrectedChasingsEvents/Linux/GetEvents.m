function [ParamToSave AllChasing AllApproaching  AllBeAvoiding AllClose AllCloseClose]  = GetEvents(Params)
%Create data with chasing events
%Create data with avoidance and approaching events
%% 
%% ------------------------------------Read mat files----------------------
MatFilesobj=FilesTreat; %use class Files Treat
A=dir(Params.Directory);
for i=3:size(A,1)
 I1=strfind(A(i).name,'ResultsMatlab');   
   if ~isempty(I1)    
      MatFilesobj.directory=strcat(Params.Directory,'/',A(i).name); %where are the results
       break
   end
end
MatFilesobj.extension='.mat';
NumMat=MatFilesobj.NumFiles(MatFilesobj.ListFiles);
% DateFiles=MatFilesobj.DateFiles(MatFilesobj.ListFiles,NumMat);
AllFiles=MatFilesobj.ListFiles;
AllChasing={};
AllApproaching={};
AllBeAvoiding={};
AllClose={};
AllCloseClose={};
%% -------------------------------Loop over the mat files---------------------------------------
for i=1:NumMat %loop over the mat files
 i 
load(strcat(MatFilesobj.directory,'/',AllFiles(i).name));
names=Locomotion.AssigRFID.miceList;

%% Add the parameters
ParamToSave=Locomotion.AssigRFID.Behaviour.Chasing.ParamToSave;


%%

clear AllChasingAux
AllChasingAux={};
AllApproachingAux={};
AllBeAvoidingAux={};
 AllCloseAux={};
 AllCloseCloseAux={};
%% -----------------------------loop over the mice---------------------------
  
for doing=1:length(names)
    %% clear variables
    clear AuxMatrixChasing
 
    behaviour=0; %initialization
    
   
   for behaviour=1:5 
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
          case 4
             if ~isempty(Locomotion.AssigRFID.Behaviour.TogetherClose.TogetherAll{1,doing})
             AuxMatrixClose=Reorder_Social_Parameters(Locomotion.AssigRFID.Behaviour.TogetherClose.TogetherAll,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
             AllCloseAux=[AllCloseAux; AuxMatrixClose];
             end    
          case 5
             if ~isempty(Locomotion.AssigRFID.Behaviour.TogetherClose.TogetherAllClose{1,doing})
             AuxMatrixCloseClose=Reorder_Social_Parameters(Locomotion.AssigRFID.Behaviour.TogetherClose.TogetherAllClose,doing,AllFiles(i).name,names,behaviour,Locomotion.ExperimentTime);
             AllCloseCloseAux=[AllCloseCloseAux; AuxMatrixCloseClose];
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
 
  if ~isempty(AllCloseAux)
 AllCloseAux=Sort_Matrix(AllCloseAux);
 AllClose=[AllClose; AllCloseAux]; 
 else
     continue;
  end
  
  if ~isempty(AllCloseCloseAux)
 AllCloseCloseAux=Sort_Matrix(AllCloseCloseAux);
 AllCloseClose=[AllCloseClose; AllCloseCloseAux]; 
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
      InitialTime=
      Time(BegFrameA,1); 
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
        if behaviour < 4
         Mouse_Involved=cell2mat(Mouse_Involved);
        
         AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('',(names(Mouse_Doing))',''),strcat('',(names(Mouse_Involved))',''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA));
        elseif behaviour == 4
          
          AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('',(names(Mouse_Doing))',''),strcat('',(names(Mouse_Involved))',''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA));
        else %for behaviour 5
          
          AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('',(names(Mouse_Doing))',''),strcat('',(names(Mouse_Involved))',''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA),num2cell(Social_Parameter{1,doing}(:,4)),...
             num2cell(Social_Parameter{1,doing}(:,5)),num2cell(Social_Parameter{1,doing}(:,6)),num2cell(Social_Parameter{1,doing}(:,7)),...
             num2cell(Social_Parameter{1,doing}(:,8)),num2cell(Social_Parameter{1,doing}(:,9)),...
             num2cell(Social_Parameter{1,doing}(:,10)),num2cell(Social_Parameter{1,doing}(:,11)),...
             num2cell(Social_Parameter{1,doing}(:,12)),num2cell(Social_Parameter{1,doing}(:,13)),...
             num2cell(Social_Parameter{1,doing}(:,14)),num2cell(Social_Parameter{1,doing}(:,15)));
         
        end  
          
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





