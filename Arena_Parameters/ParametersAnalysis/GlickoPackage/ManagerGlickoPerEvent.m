function ManagerGlickoPerEvent(DataToUse,filename)
%% Calculate Glicko rating according to 
% http://www.glicko.net/glicko/glicko.pdf
% input data chasing table from csv/excel
%% Variables Reset
clear Rglicko
clear RDglicko
clear GlickoMatrix

%% Load parameters
Params = GlickoRatingParams();
InitialRating=Params.InitialRating;
Cconstant=Params.Cconstant;
InitialRatingDesviation=Params.InitialRatingDesviation;
NumberDaysExp=Params.DaysExp;

SubsetData=DataToUse.SubsetData;
MouseID=DataToUse.MouseID;
IndexChasing=DataToUse.IndexChasing;
IndexBeingChasing=DataToUse.IndexBeingChasing;
IndexEvents=DataToUse.IndexEvents;
begin=DataToUse.begin;

hwait = waitbar(0,'Please wait Glicko calculation...');


%% CALCULATION OF the glicko rating system
 close(hwait)
hwait = waitbar(0.5,'Please wait...');
 [Rglicko, RDglicko]=GlickoCalculation(SubsetData,MouseID,Cconstant,InitialRating,InitialRatingDesviation,...
                          IndexChasing,IndexBeingChasing,IndexEvents);
                      
   %% Create a table with the glicko results

Raux=[InitialRating*ones(1,size(Rglicko,1));Rglicko'];
RDaux=[InitialRatingDesviation*ones(1,size(RDglicko,1));RDglicko'];

%create elorating matrix
GlickoMatrix(1,1)={'Experiment date'};
GlickoMatrix(1,2)={'Time begin'};
GlickoMatrix(1,3)={'Time end'};

for i=1:length(MouseID)
GlickoMatrix(1,i+3)=strcat('''',MouseID(i),'''');
GlickoMatrix(1,i+3+length(MouseID))=strcat('''',MouseID(i),'''');
end

%add zero time
GlickoMatrix(2:size(SubsetData,1)+2,1)=[0; SubsetData(:,1)];
GlickoMatrix(2:size(SubsetData,1)+2,2)=[0; SubsetData(:,2)];
GlickoMatrix(2:size(SubsetData,1)+2,3)=[0; SubsetData(:,3)];

GlickoMatrix(2:size(SubsetData,1)+2,4:length(MouseID)+3)=num2cell(Raux);    % save rating
GlickoMatrix(2:size(SubsetData,1)+2,length(MouseID)+4:length(MouseID)+length(MouseID)+3)=num2cell(RDaux);     % save RD                   


 %% Save number of events
widthM=size((GlickoMatrix),2)+1;
GlickoMatrix(1,widthM)={'Events'};
GlickoMatrix(2:end,widthM)=num2cell([0:size((GlickoMatrix),1)-2]);

%% Save only the days choose by the user
IndexToRemove=DaysRemove(GlickoMatrix(:,1),NumberDaysExp);
if IndexToRemove>0
  GlickoMatrix(IndexToRemove+2,:)={''};
    
end                     
%% Save in excel file and plot 

 sheet1=['Glicko-rating All Events'];
 try
  xlswrite(filename,GlickoMatrix,sheet1)
 catch
    msgbox('CLOSE YOUR EXCEL FILE') 
 end

 PlotGlickoPerEvent(GlickoMatrix,MouseID,filename);

close(hwait)
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Auxiliary functions


%% 
    function I=DaysRemove(A,NumberDaysExp)
    Days=[];
    DaysWR=[];
   A=A(3:end);
    for i=1:length(A)
         
      Ax=char(strrep(A(i),'''','')); %remove every comma
    k=strfind(Ax,'.');
    
    Days(i)=str2num(Ax(1:k(1)-1));
  
    end
     Days=Days';
 %remove repeats days and locations
     DaysWR=unique(Days,'stable')
     
     %find not consider days
     if NumberDaysExp==length(DaysWR)
         I=0;
     else
     DaysNC=DaysWR(NumberDaysExp+1:length(DaysWR));
     for i=1:length(DaysNC)
         if i==1
        I=find(Days==DaysNC(i));
         else
             I1=find(Days==DaysNC(i));
             I=[I;I1];
         end
     end    
     end    
         
 end