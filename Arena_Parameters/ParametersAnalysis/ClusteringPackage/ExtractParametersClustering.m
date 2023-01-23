function  [Aux,AuxMiceList,AuxRank1]=ExtractParametersClustering(Experiment,NumberMouse,FromDay,ToDay,ExpListParams)
%Create a table in which the columns are parameters and the rows are
%observations
%% -----------------Variables---------------------------
global h
AuxRank={};
%% -------------Read the adequate excel sheet--------------------
   sheet=char(Experiment);
  [num,txt,raw]=xlsread(get(h.editRunParamsPCA,'string'),sheet); %include all the parameters
  
  %% Get the type of ranking
   switch get(h.Popup3PCA,'Value')
      case 2 %for elorating average
          I1=find(strcmp(raw(:,1),'Ranking according to elo-rating')==1);
          [B,Is]=sort(cell2mat(raw(I1:I1+NumberMouse-1,4)),'descend');
          C=raw(I1:I1+NumberMouse-1,3);
          
           AuxRank=C(Is,1);
      case 3 %for david score average
          I1=find(strcmp(raw(:,1),'Normalized David Score from Dominance matrix all the experiment')==1);
          [B,Is]=sort(cell2mat(raw(I1:I1+NumberMouse-1,3)),'descend');
          C=raw(I1:I1+NumberMouse-1,2);
          
           AuxRank=C(Is,1);
           
       case 4 %for calculation according to last day in the average per day elorating
          I1=find(strcmp(raw(:,1),'Mean Elorating per day')==1);
          [B,Is]=sort(cell2mat(raw(I1:I1+NumberMouse-1,3+ToDay-1)),'descend');
          C=raw(I1:I1+NumberMouse-1,2);
          
           AuxRank=C(Is,1);
  end
  
  

  %% ---------Loop into each parameter---------------------
  for i=1:length(ExpListParams)
   rawNumber=find(strcmp(ExpListParams(i),raw(:,1))==1);   
   ArrayParameters(:,:,i)=raw(rawNumber:rawNumber+NumberMouse-1,2+FromDay:2+ToDay);  
   MiceList(:,i)=raw(rawNumber:rawNumber+NumberMouse-1,2);   
  end
  %% ---------------Insert working mode-------------
  switch get(h.Popup2PCA,'Value')
      case 2 %for averaging the selected days
     Aux=mean(cell2mat(ArrayParameters),2);
      case 3
    Aux=reshape(ArrayParameters,[size(ArrayParameters,1)*size(ArrayParameters,2),1,length(ExpListParams)]);
  end
  
     %% --------Bring all the parameters to the same table---------
     Aux=reshape(Aux,[size(Aux,1),length(ExpListParams)]); 
    
     AuxMiceList=reshape(repmat(MiceList(:,1),1,size(Aux,1)/NumberMouse),[size(Aux,1),1]);
     
     %% -------------Associate the ranking to each mouse in which t=1 is the alpha t=2 is the beta----------
     for t=1:length(AuxRank)
     Ind=find(strcmp(AuxRank(t,1),AuxMiceList)==1);
     AuxRank1(Ind,1)=t;
     end
     
end

