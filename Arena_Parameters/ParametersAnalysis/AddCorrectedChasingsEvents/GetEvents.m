function AllChasing  = GetEvents(Folder_Data)
%Create data with chasing events
%Create data with avoidance and approaching events
%% 
%% ------------------------------------Read mat files----------------------
Folder_Data=char(Folder_Data);
ListFiles=dir([Folder_Data,'*.mat']);
AllChasing={};

%% -------------------------------Loop over the mat files---------------------------------------
for countFile=1:1:length(ListFiles(not([ListFiles.isdir]))) %GO OVER EACH FILE
 countFile
 load(strcat(Folder_Data,ListFiles(countFile).name));    
 ListFiles(countFile).name  
 names=Locomotion.AssigRFID.miceList;

%%

clear AllChasingAux
AllChasingAux={};

%% -----------------------------loop over the mice---------------------------
  
for doing=1:length(names)
    %% clear variables
    clear AuxMatrixChasing

             if ~isempty(Locomotion.AssigRFID.Behaviour.Chasing.chasing{1,doing})
             AuxMatrixChasing=Reorder_Social_Parameters(Locomotion.AssigRFID.Behaviour.Chasing.chasing,doing,ListFiles(countFile).name,names,Locomotion.ExperimentTime);
             AllChasingAux=[AllChasingAux; AuxMatrixChasing];
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
 
 
 

  end
%% 


end

%% -------------------------Auxiliary functions-----------------------------------------------------

%% -----------Function to reorder the information of the social parameters----------------------

function AuxMatrix=Reorder_Social_Parameters(Social_Parameter,doing,FileName,names,RealTime)


      
        
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
        BegFrameA 
        InitialTime=RealTime(BegFrameA,1); 
        FinalTime=RealTime(EndFrameA,1);  
     end
      CorrectSign=repmat('Y',length(Mouse_Involved),1); %add Y to be corrected later
      names=names';
     %for chasing
%      MarkSmallEvents=Social_Parameter{1,doing}(:,4);
      
%       AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA),num2cell(MarkSmallEvents));
        AuxMatrix=cat(2,cellstr(ExpDate),InitialTime,FinalTime,strcat('''',(names(Mouse_Doing))',''''),strcat('''',(names(Mouse_Involved))',''''),cellstr(CorrectSign),num2cell(BegFrameA),num2cell(EndFrameA));

%      AuxMatrix=sortrows(AuxMatrix,7);%sort according to column seven
     
     
      
          
      end   
        
        




%% ---------------------------Sort the matrix--------------------------
function All=Sort_Matrix(All)
 A=All(:,2)
 TimeAux=datenum(All(:,2));
 [B,I]=sort(TimeAux);
 All=All(I,:); %sort for each date



end




%% 





